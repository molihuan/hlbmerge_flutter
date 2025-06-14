#include "include/ffmpeg_hl/ffmpeg_hl_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "ffmpeg_hl_plugin.h"

void FfmpegHlPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  ffmpeg_hl::FfmpegHlPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
