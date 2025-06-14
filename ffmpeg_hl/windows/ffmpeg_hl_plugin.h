#ifndef FLUTTER_PLUGIN_FFMPEG_HL_PLUGIN_H_
#define FLUTTER_PLUGIN_FFMPEG_HL_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace ffmpeg_hl {

class FfmpegHlPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FfmpegHlPlugin();

  virtual ~FfmpegHlPlugin();

  // Disallow copy and assign.
  FfmpegHlPlugin(const FfmpegHlPlugin&) = delete;
  FfmpegHlPlugin& operator=(const FfmpegHlPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace ffmpeg_hl

#endif  // FLUTTER_PLUGIN_FFMPEG_HL_PLUGIN_H_
