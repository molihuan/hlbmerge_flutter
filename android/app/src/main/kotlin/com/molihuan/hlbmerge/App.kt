package com.molihuan.hlbmerge

import android.app.Application
import com.molihuan.commonmodule.CommonModule
import com.molihuan.hlbmerge.log.LogUtils
import com.molihuan.hlbmerge.repository.SettingsRepository
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class App : Application() {
    override fun onCreate() {
        super.onCreate()
        context = this
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
    }

    /**
     * 预初始化
     * 不需要同意隐私的
     */
    private fun prepareInit() {
        LogUtils.init()
        CommonModule.init(this)
        SettingsRepository.init(this)
    }

    /**
     * 真正初始化
     * 初始化需要同意隐私的
     */
    private fun realInit() {
    }

    companion object {
        @JvmStatic
        lateinit var context: Application
            private set

        @JvmStatic
        fun getFlutterEngine(): FlutterEngine? {
            return FlutterEngineCache.getInstance().get(context.packageName)
        }
    }
}