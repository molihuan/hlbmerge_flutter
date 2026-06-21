import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;
import 'package:universal_ffi/ffi.dart';
import 'package:universal_ffi/ffi_helper.dart';
import 'package:universal_ffi/ffi_utils.dart';

import '../ffmpeg_interface.dart';
import '../g/ffmpeg_hl_web_bindings.g.dart';

class FfmpegWeb implements FfmpegInterface {
  @override
  Future<bool> init() async {
    if (_ffiHelper != null) {
      return true;
    }

    try {
      _ffiHelper = await FfiHelper.load(
        _libName,
        // options: {LoadOption.isFfiPlugin},
      );
      _bindings = FfmpegHlBindings(_ffiHelper!.library);
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  @override
  String? ffmpegVersion() {
    Pointer<Char> nativeVersion = nullptr;

    try {
      nativeVersion = _safeBindings.get_ffmpeg_version();
      final version = nativeVersion.cast<Utf8>().toDartString();
      return version;
    } catch (e) {
      print(e);
      return null;
    } finally {
      // 需要释放内存,否则会内存泄漏
      _safeBindings.free_string(nativeVersion);
    }
  }

  @override
  Future<String?> mergeAudioVideo(
    String videoPath,
    String audioPath,
    String outputPath,
  ) async {
    const vVirtualIn = '/video.mp4';
    const aVirtualIn = '/audio.mp3';
    const vVirtualOut = '/merged.mp4';
    final nativeVideoPath = vVirtualIn.toNativeUtf8().cast<Char>();
    final nativeAudioPath = aVirtualIn.toNativeUtf8().cast<Char>();
    final nativeOutputPath = vVirtualOut.toNativeUtf8().cast<Char>();

    String? status;

    try {
      final videoResponse = await http.get(Uri.parse(videoPath));

      if (videoResponse.statusCode != 200) {
        return "无法读取选择的文件";
      }
      // 写入 WASM 虚拟文件系统
      JSBoolean writeResult = await jsWasmWriteFile(vVirtualIn.toJS, videoResponse.bodyBytes.toJS).toDart;
      if (!writeResult.toDart) {
        return "无法写入文件";
      }

      final audioResponse = await http.get(Uri.parse(audioPath));
      if (audioResponse.statusCode != 200) {
        return "无法读取选择的文件";
      }

      writeResult = await jsWasmWriteFile(aVirtualIn.toJS, audioResponse.bodyBytes.toJS).toDart;
      if (!writeResult.toDart) {
        return "无法写入文件";
      }

      // status = await Isolate.run(() {
        final nativeResult = _safeBindings.run_merge_audio_video(
          nativeVideoPath,
          nativeAudioPath,
          nativeOutputPath,
        );

        if (nativeResult == nullptr) {
          jsWasmDownloadFile(vVirtualOut.toJS, outputPath.toJS);
          //处理成功
          return null;
        }

        final result = nativeResult.cast<Utf8>().toDartString();

        // 需要释放内存,否则会内存泄漏
        _safeBindings.free_string(nativeResult);
        //处理失败
        return result;
      // });
    } catch (e) {
      print(e);
    }finally{
      // 释放内存
      malloc.free(nativeVideoPath);
      malloc.free(nativeAudioPath);
      malloc.free(nativeOutputPath);
      // 清理 WASM 虚拟文件
      try {
        jsWasmUnlink(vVirtualIn.toJS);
        jsWasmUnlink(aVirtualIn.toJS);
        jsWasmUnlink(vVirtualOut.toJS);
      } catch (e) {
        print(e);
      }
    }

    return status;
  }

  @override
  Future<String?> mergeVideos(
    List<String> videoPaths,
    String outputPath,
  ) async {
    // TODO: implement mergeVideos
    throw UnimplementedError();
  }
}

/// 全局FfiHelper实例
FfiHelper? _ffiHelper;
FfmpegHlBindings? _bindings;

// 当前插件名称
const String ffmpegPluginName = 'ffmpeg_hl';

const String _libName =
    'assets/packages/$ffmpegPluginName/assets/wasm/ffmpeg_core.js';

/// 获取绑定实例（确保已初始化）
FfmpegHlBindings get _safeBindings {
  if (_bindings == null) {
    throw StateError('FFI plugin not init. Call init() first.');
  }
  return _bindings!;
}

FfmpegInterface createFfmpeg() {
  return FfmpegWeb();
}

@JS('wasmWriteFile')
external JSPromise<JSBoolean> jsWasmWriteFile(JSString path, JSUint8Array data);

@JS('wasmReadFile')
external JSUint8Array jsWasmReadFile(JSString path);

@JS('wasmUnlink')
external void jsWasmUnlink(JSString path);

@JS('wasmDownloadFile')
external void jsWasmDownloadFile(JSString vfsPath, JSString downloadName);
