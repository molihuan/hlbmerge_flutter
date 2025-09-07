#include "ffmpeg_hl_plugin.h"
#include "ffmpeg/ffmpeg_merge.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace ffmpeg_hl {

// static
void FfmpegHlPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "ffmpeg_hl",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<FfmpegHlPlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

FfmpegHlPlugin::FfmpegHlPlugin() {}

FfmpegHlPlugin::~FfmpegHlPlugin() {}

void FfmpegHlPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else if(method_call.method_name().compare("getAvcodecCfg") == 0){
      std::string ffmpeg_cfg = avcodec_configuration();
      result->Success(flutter::EncodableValue(ffmpeg_cfg));
  } else if(method_call.method_name().compare("mergeAudioVideo") == 0){
      // Get all the arguments passed by the flutter side and convert them to maps
      const auto* args = std::get_if<flutter::EncodableMap>(method_call.arguments());

      if (!args){
          result->Error("Win no param");
          return;
      }

      std::string audioPath = std::get<std::string>(args->find(flutter::EncodableValue("audioPath"))->second);
      std::string videoPath = std::get<std::string>(args->find(flutter::EncodableValue("videoPath"))->second);
      std::string outputPath = std::get<std::string>(args->find(flutter::EncodableValue("outputPath"))->second);

      std::cout << "Win C++ Received:" << audioPath << ", " << videoPath << ", " << outputPath << std::endl;

      bool bool_ret = merge_audio_video(videoPath, audioPath, outputPath);
      std::cout << bool_ret << std::endl;

      flutter::EncodableMap response;
      response[flutter::EncodableValue("success")] = flutter::EncodableValue(true);
      response[flutter::EncodableValue("message")] = flutter::EncodableValue("操作成功");
      result->Success(flutter::EncodableValue(response));
  }else {
    result->NotImplemented();
  }
}

}  // namespace ffmpeg_hl
