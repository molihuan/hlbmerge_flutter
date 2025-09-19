package com.molihuan.hlbmerge.log

import com.molihuan.hlbmerge.BuildConfig
import timber.log.Timber

object LogUtils {
    @JvmStatic
    fun init(debug: Boolean = BuildConfig.DEBUG) {
        //初始化日志打印框架
        if (debug) {
            Timber.plant(TimberDebugTree());
        } else {
            Timber.plant(TimberReleaseTree());
        }
    }
}

class TimberDebugTree : Timber.DebugTree() {

    override fun createStackElementTag(element: StackTraceElement): String? {
        val rawTag = super.createStackElementTag(element)
        //添加 打印文件名、行号、线程名
//        return "$rawTag (${element.fileName}:${element.lineNumber})[${Thread.currentThread().name}]"
        return "$rawTag (${element.fileName}:${element.lineNumber})"
    }
}

class TimberReleaseTree : Timber.Tree() {
    override fun log(priority: Int, tag: String?, message: String, t: Throwable?) {
        // TODO: 发送日志到服务器或其他的
    }
}