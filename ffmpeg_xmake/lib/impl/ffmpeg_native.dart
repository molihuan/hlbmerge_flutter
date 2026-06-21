import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:isolate';

import 'package:ffi/ffi.dart';

import '../ext/ffi_ext.dart';
import '../g/ffmpeg_hl_native_bindings.g.dart';

import '../ffmpeg_interface.dart';


class FfmpegNative implements FfmpegInterface {
  @override
  Future<bool> init() async {
    return true;
  }

  @override
  String? ffmpegVersion() {
    ffi.Pointer<ffi.Char> nativeVersion = ffi.nullptr;

    try {
      nativeVersion = _bindings.get_ffmpeg_version();
      final version = nativeVersion.cast<Utf8>().toDartString();
      return version;
    } catch (e) {
      print(e);
      return null;
    } finally {
      // 需要释放内存,否则会内存泄漏
      _bindings.free_string(nativeVersion);
    }
  }

  @override
  Future<String?> mergeAudioVideo(
    String videoPath,
    String audioPath,
    String outputPath,
  ) async {
    final nativeVideoPath = videoPath.toNativeUtf8().cast<ffi.Char>();
    final nativeAudioPath = audioPath.toNativeUtf8().cast<ffi.Char>();
    final nativeOutputPath = outputPath.toNativeUtf8().cast<ffi.Char>();

    String? status;

    try {
      status = await Isolate.run(() {
        final nativeResult = _bindings.run_merge_audio_video(
          nativeVideoPath,
          nativeAudioPath,
          nativeOutputPath,
        );

        if (nativeResult.isNullPtr()) {
          //处理成功
          return null;
        }

        final result = nativeResult.cast<Utf8>().toDartString();

        // 需要释放内存,否则会内存泄漏
        _bindings.free_string(nativeResult);
        //处理失败
        return result;
      });
    } finally {
      // 释放内存
      malloc.free(nativeVideoPath);
      malloc.free(nativeAudioPath);
      malloc.free(nativeOutputPath);
    }

    return status;
  }

  @override
  Future<String?> mergeVideos(
    List<String> videoPaths,
    String outputPath,
  ) async {
    ffi.Pointer<ffi.Pointer<ffi.Char>> nativeArray = ffi.nullptr;
    final nativeOutputPath = outputPath.toNativeUtf8().cast<ffi.Char>();

    String? status;

    try {
      nativeArray = videoPaths.toNativeUtf8Array().cast();

      status = await Isolate.run(() {
        final nativeResult = _bindings.run_merge_videos(
          nativeArray,
          videoPaths.length,
          nativeOutputPath,
        );

        if (nativeResult.isNullPtr()) {
          //处理成功
          return null;
        }
        final result = nativeResult.cast<Utf8>().toDartString();
        // 需要释放内存,否则会内存泄漏
        _bindings.free_string(nativeResult);
        return result;
      });
    } finally {
      nativeArray.freeArray(videoPaths.length);
      malloc.free(nativeOutputPath);
    }

    return status;
  }


  /// sum
  int sum(int a, int b) => _bindings.sum(a, b);

  Future<int> sumAsync(int a, int b) async {
    final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
    final int requestId = _nextSumRequestId++;
    final _SumRequest request = _SumRequest(requestId, a, b);
    final Completer<int> completer = Completer<int>();
    _sumRequests[requestId] = completer;
    helperIsolateSendPort.send(request);
    return completer.future;
  }

}


/// Load the dynamic library
const String _libName = 'ffmpeg_hl';

final ffi.DynamicLibrary _dylib = () {
  // if (Platform.isIOS) {
  //   return ffi.DynamicLibrary.process();
  // }
  if (Platform.isMacOS || Platform.isIOS) {
    return ffi.DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid ||
      Platform.isLinux ||
      Platform.operatingSystem == "ohos") {
    return ffi.DynamicLibrary.open('lib$_libName.so');
  }
  if (Platform.isWindows) {
    return ffi.DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final FfmpegHlBindings _bindings = FfmpegHlBindings(_dylib);

/// About async sum
class _SumRequest {
  final int id;
  final int a;
  final int b;

  const _SumRequest(this.id, this.a, this.b);
}

class _SumResponse {
  final int id;
  final int result;

  const _SumResponse(this.id, this.result);
}

int _nextSumRequestId = 0;

final Map<int, Completer<int>> _sumRequests = <int, Completer<int>>{};

// Helper isolate
Future<SendPort> _helperIsolateSendPort = () async {
  final Completer<SendPort> completer = Completer<SendPort>();

  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is _SumResponse) {
        final Completer<int> completer = _sumRequests[data.id]!;
        _sumRequests.remove(data.id);
        completer.complete(data.result);
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        // On the helper isolate listen to requests and respond to them.
        if (data is _SumRequest) {
          final int result = _bindings.sum_long_running(data.a, data.b);
          final _SumResponse response = _SumResponse(data.id, result);
          sendPort.send(response);
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });

    // Send the port to the main isolate on which we can receive requests.
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);

  return completer.future;
}();


FfmpegInterface createFfmpeg() {
  return FfmpegNative();
}
