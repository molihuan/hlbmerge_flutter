#include "ffmpeg/ffmpeg_merge.h"
#include "include/ffmpeg_hl/ffmpeg_hl_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>

#include "ffmpeg_hl_plugin_private.h"

#define FFMPEG_HL_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), ffmpeg_hl_plugin_get_type(), \
                              FfmpegHlPlugin))

struct _FfmpegHlPlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(FfmpegHlPlugin, ffmpeg_hl_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void ffmpeg_hl_plugin_handle_method_call(
    FfmpegHlPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    response = get_platform_version();
  } else if(strcmp(method, "getAvcodecCfg") == 0) {
      const char* cfg = avcodec_configuration();
      g_autoptr(FlValue) result = fl_value_new_string(cfg);
      response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else if(strcmp(method, "mergeAudioVideo") == 0) {
      response = handle_merge_audio_video(method_call);
  }else{
      response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* handle_merge_audio_video(FlMethodCall* method_call) {
    FlValue* args = fl_method_call_get_args(method_call);

    if (fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
        return FL_METHOD_RESPONSE(fl_method_error_response_new("Linux no param", nullptr, nullptr));
    }

    FlValue* audio_path_value = fl_value_lookup_string(args, "audioPath");
    FlValue* video_path_value = fl_value_lookup_string(args, "videoPath");
    FlValue* output_path_value = fl_value_lookup_string(args, "outputPath");

    if (!audio_path_value || !video_path_value || !output_path_value) {
        return FL_METHOD_RESPONSE(fl_method_error_response_new("Missing parameters", nullptr, nullptr));
    }

    const gchar* audio_path = fl_value_get_string(audio_path_value);
    const gchar* video_path = fl_value_get_string(video_path_value);
    const gchar* output_path = fl_value_get_string(output_path_value);

    g_print("Linux C++ Received: %s, %s, %s\n", audio_path, video_path, output_path);

    gboolean bool_ret = merge_audio_video(video_path, audio_path, output_path);
    g_print("%s\n", bool_ret ? "true" : "false");

    g_autoptr(FlValue) response_map = fl_value_new_map();
    fl_value_set_string(response_map, "success", fl_value_new_bool(TRUE));
    fl_value_set_string(response_map, "message", fl_value_new_string("操作成功"));

    return FL_METHOD_RESPONSE(fl_method_success_response_new(response_map));
}

static void ffmpeg_hl_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(ffmpeg_hl_plugin_parent_class)->dispose(object);
}

static void ffmpeg_hl_plugin_class_init(FfmpegHlPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = ffmpeg_hl_plugin_dispose;
}

static void ffmpeg_hl_plugin_init(FfmpegHlPlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  FfmpegHlPlugin* plugin = FFMPEG_HL_PLUGIN(user_data);
  ffmpeg_hl_plugin_handle_method_call(plugin, method_call);
}

void ffmpeg_hl_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  FfmpegHlPlugin* plugin = FFMPEG_HL_PLUGIN(
      g_object_new(ffmpeg_hl_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "ffmpeg_hl",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
