package com.molihuan.hlbmerge

import android.app.Application
import com.molihuan.commonmodule.CommonModule
import com.molihuan.hlbmerge.channel.main.MainMethodChannel
import com.molihuan.hlbmerge.dao.flutter.FlutterSpData
import com.molihuan.hlbmerge.log.LogUtils
import dagger.hilt.android.HiltAndroidApp
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

@HiltAndroidApp
class App: Application() {
    override fun onCreate() {
        super.onCreate()
        instance = this
        //缓存flutter引擎
        cacheFlutterEngine()
        prepareInit()
        realInit()
    }

    private fun cacheFlutterEngine() {
        // 1. 实例化一个 FlutterEngine
        val flutterEngine = FlutterEngine(this)

        // 2. 预热 Flutter 引擎，执行 Dart 入口点
        // 这可以加快 Flutter 页面的首次打开速度
        flutterEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )

        // 3. 将 FlutterEngine 缓存起来，给它一个唯一的 ID
        FlutterEngineCache
            .getInstance()
            .put(packageName, flutterEngine)

        //注册监听
        MainMethodChannel.register(flutterEngine.dartExecutor.binaryMessenger, this)
        registerActivityLifecycleCallbacks(MainMethodChannel)
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