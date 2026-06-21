package com.molihuan.hlbmerge

import NativeApis
import android.content.Context
import androidx.lifecycle.coroutineScope
import com.molihuan.hlbmerge.pigeon.impl.NativeApisImpl
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity : FlutterActivity() {
    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        // 从 FlutterEngineCache 中,通过我们之前定义的 ID 来获取引擎实例
        return App.getFlutterEngine()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        /// 配置 NativeApis
        NativeApis.setUp(
            flutterEngine.dartExecutor.binaryMessenger,
            NativeApisImpl(this, lifecycle.coroutineScope)
        )
    }
}
