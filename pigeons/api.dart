import 'package:pigeon/pigeon.dart';

// # Config
@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/generate/pigeon/flutter_native_api.g.dart',
    dartOptions: DartOptions(),
    kotlinOut:
        'android/app/src/main/kotlin/com/molihuan/hlbmerge/pigeon/FlutterNativeApi.g.kt',
    kotlinOptions: KotlinOptions(),
    arkTSOut: 'ohos/entry/src/main/ets/pigeon/FlutterNativeApi.g.ets',
    arkTSOptions: ArkTSOptions(),
    dartPackageName: 'hlbmerge',
  ),
)
// native页面参数
class NativePageParams {
  NativePageParams({this.fromFlutter = true});

  bool fromFlutter;
}

class TupleBool {
  TupleBool(this.code, this.msg, this.data);

  int code;
  String msg;
  bool data;
}

class TupleStr {
  TupleStr(this.code, this.msg, this.data);

  int code;
  String msg;
  String? data;
}

// flutter调用native api声明
@HostApi()
abstract class NativeApis {
  /// 跳转原生页面
  TupleBool goNativePage(String router, NativePageParams? params);

  /// 是否有读写权限
  TupleBool hasReadWritePermission();

  /// 请求读写权限,需要异步
  @async
  TupleBool grantReadWritePermission();

  TupleStr getExternalStorageRootPath();

  TupleStr getDefaultOutputDirPath();

  @async
  TupleBool copyCacheAudioVideoFile(String sufPath);

  @async
  TupleBool copyCacheStructureFile();

  @async
  TupleBool notifyExportComplete();
}

class FlutterPageParams {
  FlutterPageParams({this.fromNative = true});

  bool fromNative;
}

// native调用flutter api声明
@FlutterApi()
abstract class FlutterApis {
  void backFlutterPageFromNativePage(FlutterPageParams? params);
}
