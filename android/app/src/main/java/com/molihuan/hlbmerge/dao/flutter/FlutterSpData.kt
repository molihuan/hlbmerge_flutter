package com.molihuan.hlbmerge.dao.flutter

import android.app.Application
import com.molihuan.hlbmerge.ui.screen.path.select.PathSelectFunctionState
import com.molihuan.hlbmerge.utils.FileUtils
import java.io.File

object FlutterSpData {
    /**
     * SharedPreferences 文件的名称
     */
    private const val PREFS_NAME = "FlutterSharedPreferences"

    // 公共目录Downloads下的app根目录
    val appRootPathInDownload = buildString {
        append(FileUtils.externalStorageDownloadsPath)
        append(File.separator)
        append("HLB站缓存视频合并")
    }

    //缓存拷贝Temp目录
    val cacheCopyTempPath = buildString {
        append(appRootPathInDownload)
        append(File.separator)
        append("cacheCopyTempDir")
    }

    @JvmStatic
    fun init(context: Application) {
        FlutterSpUtils.init(context, name = PREFS_NAME)
    }

    private const val KEY_INPUT_CACHE_DIR_PATH = "flutter.inputCacheDirPath"

    //设置inputCacheDirPath
    @JvmStatic
    fun setInputCacheDirPath(inputCacheDirPath: String) {
        FlutterSpUtils.putString(KEY_INPUT_CACHE_DIR_PATH, inputCacheDirPath)
    }

    //获取inputCacheDirPath
    @JvmStatic
    fun getInputCacheDirPath(): String? {
        return FlutterSpUtils.getString(KEY_INPUT_CACHE_DIR_PATH)
    }

    //获取默认的输出路径
    @JvmStatic
    fun getDefaultOutputDirPath(): String {
        val finalPath = appRootPathInDownload + File.separator + "outputDir"
        return finalPath
    }

    private const val KEY_OUTPUT_DIR_PATH = "flutter.outputDirPath"
    //获取输入路径
    @JvmStatic
    fun getOutputDirPath(): String {
        return FlutterSpUtils.getString(KEY_OUTPUT_DIR_PATH) ?: getDefaultOutputDirPath()
    }

    private const val KEY_ANDROID_INPUT_CACHE_PACKAGE_NAME = "flutter.androidInputCachePackageName"

    //安卓读取InputCache packageName
    @JvmStatic
    fun setAndroidInputCachePackageName(packageName: String) {
        FlutterSpUtils.putString(KEY_ANDROID_INPUT_CACHE_PACKAGE_NAME, packageName)
    }

    @JvmStatic
    fun getAndroidInputCachePackageName(): String? {
        return FlutterSpUtils.getString(KEY_ANDROID_INPUT_CACHE_PACKAGE_NAME)
    }

    //安卓解析缓存数据权限 parseCacheDataPermission
    private const val KEY_ANDROID_PARSE_CACHE_DATA_PERMISSION =
        "flutter.androidParseCacheDataPermission"

    @JvmStatic
    fun setAndroidParseCacheDataPermission(type: PathSelectFunctionState) {
        FlutterSpUtils.putString(KEY_ANDROID_PARSE_CACHE_DATA_PERMISSION, type.title)
    }

    @JvmStatic
    fun getAndroidParseCacheDataPermission(): PathSelectFunctionState {
        val type = FlutterSpUtils.getString(KEY_ANDROID_PARSE_CACHE_DATA_PERMISSION)
        return when (type) {
            PathSelectFunctionState.HasReadWritePermission.title -> {
                PathSelectFunctionState.HasReadWritePermission
            }

            PathSelectFunctionState.HasReadWriteUriPermission.title -> {
                PathSelectFunctionState.HasReadWriteUriPermission
            }

            PathSelectFunctionState.HasReadWriteShizukuPermission.title -> {
                PathSelectFunctionState.HasReadWriteShizukuPermission
            }

            else -> {
                PathSelectFunctionState.NoReadWritePermission
            }
        }
    }


}