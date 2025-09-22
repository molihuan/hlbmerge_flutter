package com.molihuan.hlbmerge.dao

import android.app.Application
import com.molihuan.hlbmerge.utils.FlutterSpUtils

object FlutterSpData {
    /**
     * SharedPreferences 文件的名称
     */
    private const val PREFS_NAME = "FlutterSharedPreferences"

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


}