package com.molihuan.hlbmerge

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import timber.log.Timber


class MainActivity: FlutterActivity() {
    private lateinit var channel : MethodChannel
    private val channelName = "com.molihuan.hlbmerge/mainChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel.setMethodCallHandler(::methodCallHandler)
    }

    fun methodCallHandler(call: MethodCall,  result: MethodChannel.Result){
        when (call.method) {
            "startActivity" -> {
                // 获取 Flutter 传递的参数
                val to = call.argument<String>("to")
                Timber.d("startActivity: $to")
                AndroidActivity.go(this)
                val returnMap = mapOf<String, Any?>(
                    "code" to 0,
                    "msg" to "ok",
                    "data" to null,
                )
                result.success(returnMap)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
