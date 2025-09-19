package com.molihuan.hlbmerge

import android.app.Application
import com.molihuan.hlbmerge.log.LogUtils

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