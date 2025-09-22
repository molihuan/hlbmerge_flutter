package com.molihuan.hlbmerge

import android.app.Application
import com.molihuan.commonmodule.CommonModule
import com.molihuan.hlbmerge.dao.FlutterSpData
import com.molihuan.hlbmerge.log.LogUtils
import dagger.hilt.android.HiltAndroidApp

@HiltAndroidApp
class App: Application() {
    override fun onCreate() {
        super.onCreate()
        instance = this
        prepareInit()
        realInit()
    }
    /**
     * 预初始化
     * 不需要同意隐私的
     */
    private fun prepareInit() {
        LogUtils.init()
        CommonModule.init(this)
        // flutter sp 数据存储
        FlutterSpData.init(this)
    }

    /**
     * 真正初始化
     * 初始化需要同意隐私的
     */
    private fun realInit() {
    }

    companion object {
        @JvmStatic
        lateinit var instance: App
            private set
    }
}