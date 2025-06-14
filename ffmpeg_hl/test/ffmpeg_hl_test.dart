import 'package:flutter_test/flutter_test.dart';
import 'package:ffmpeg_hl/ffmpeg_hl.dart';
import 'package:ffmpeg_hl/ffmpeg_hl_platform_interface.dart';
import 'package:ffmpeg_hl/ffmpeg_hl_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFfmpegHlPlatform
    with MockPlatformInterfaceMixin
    implements FfmpegHlPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FfmpegHlPlatform initialPlatform = FfmpegHlPlatform.instance;

  test('$MethodChannelFfmpegHl is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFfmpegHl>());
  });

  test('getPlatformVersion', () async {
    FfmpegHl ffmpegHlPlugin = FfmpegHl();
    MockFfmpegHlPlatform fakePlatform = MockFfmpegHlPlatform();
    FfmpegHlPlatform.instance = fakePlatform;

    expect(await ffmpegHlPlugin.getPlatformVersion(), '42');
  });
}
