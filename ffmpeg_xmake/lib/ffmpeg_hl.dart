import 'impl/ffmpeg_stub.dart'
if (dart.library.ffi) 'impl/ffmpeg_native.dart'
if (dart.library.js_interop) 'impl/ffmpeg_web.dart';


import 'ffmpeg_interface.dart';

final FfmpegInterface ffmpegInterface = createFfmpeg();