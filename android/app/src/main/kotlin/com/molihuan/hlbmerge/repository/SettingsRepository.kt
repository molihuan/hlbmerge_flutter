package com.molihuan.hlbmerge.repository

import android.app.Application
import com.molihuan.hlbmerge.storage.LocalStorage
import com.molihuan.hlbmerge.storage.impl.mmkv.MMKVStorage
import com.molihuan.hlbmerge.ui.screen.path.select.PathSelectFunctionState
import com.molihuan.hlbmerge.utils.FileUtils
import java.io.File

object SettingsRepository {

    private val storage: LocalStorage by lazy {
        MMKVStorage
    }

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
        storage.init(context)
    }

    private const val KEY_INPUT_CACHE_DIR_PATH = "inputCacheDirPath"

    //设置inputCacheDirPath
    @JvmStatic
    fun setInputCacheDirPath(inputCacheDirPath: String) {
        storage.saveValue(KEY_INPUT_CACHE_DIR_PATH, inputCacheDirPath)
    }

    //获取inputCacheDirPath
    @JvmStatic
    fun getInputCacheDirPath(): String? {
        val value = storage.loadValue<String>(KEY_INPUT_CACHE_DIR_PATH, "")
        if (value.isBlank()) {
            return null
        }
        return value
    }

    //获取默认的输出路径
    @JvmStatic
    fun getDefaultOutputDirPath(): String {
        val finalPath = appRootPathInDownload + File.separator + "outputDir"
        return finalPath
    }

    private const val KEY_OUTPUT_DIR_PATH = "outputDirPath"

    //获取输入路径
    @JvmStatic
    fun getOutputDirPath(): String {
        val value = storage.loadValue(KEY_OUTPUT_DIR_PATH, "")
        if (value.isBlank()){
            return getDefaultOutputDirPath()
        }

        return value
    }

    private const val KEY_ANDROID_INPUT_CACHE_PACKAGE_NAME = "androidInputCachePackageName"

    //安卓读取InputCache packageName
    @JvmStatic
    fun setAndroidInputCachePackageName(packageName: String) {
        storage.saveValue(KEY_ANDROID_INPUT_CACHE_PACKAGE_NAME, packageName)
    }

    @JvmStatic
    fun getAndroidInputCachePackageName(): String? {
        val value = storage.loadValue(KEY_ANDROID_INPUT_CACHE_PACKAGE_NAME, "")
        if (value.isBlank()){
            return  null
        }
        return value
    }

    //安卓解析缓存数据权限 parseCacheDataPermission
    private const val KEY_ANDROID_PARSE_CACHE_DATA_PERMISSION =
        "androidParseCacheDataPermission"

    @JvmStatic
    fun setAndroidParseCacheDataPermission(type: PathSelectFunctionState) {
        storage.saveValue(KEY_ANDROID_PARSE_CACHE_DATA_PERMISSION, type.title)
    }

    @JvmStatic
    fun getAndroidParseCacheDataPermission(): PathSelectFunctionState {
        val type = storage.loadValue(KEY_ANDROID_PARSE_CACHE_DATA_PERMISSION, "")
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