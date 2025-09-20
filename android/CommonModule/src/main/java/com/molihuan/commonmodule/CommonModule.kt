package com.molihuan.commonmodule

import android.app.Application
import com.molihuan.commonmodule.tool.FileTool

object CommonModule {
    lateinit var application: Application
        private set

    //初始化
    @JvmStatic
    fun init(application: Application, debug: Boolean = BuildConfig.DEBUG) {
        this.application = application
        if (!debug) {
            //线上模式
            //删除临时文件
            FileTool.deleteTempFiles()
        }
    }
}