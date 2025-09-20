package com.molihuan.hlbmerge

import android.R.attr.path
import android.os.Environment
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.XXPermissions
import com.hjq.permissions.permission.PermissionLists
import com.hjq.permissions.permission.base.IPermission
import com.molihuan.commonmodule.tool.ToastTool
import com.molihuan.hlbmerge.ui.screen.path.select.PathSelectFunctionState
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import timber.log.Timber
import java.io.File


class MainActivity : FlutterActivity() {
    private lateinit var channel: MethodChannel
    private val channelName = "com.molihuan.hlbmerge/mainChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
        channel.setMethodCallHandler(::methodCallHandler)
    }

    fun methodCallHandler(call: MethodCall, result: MethodChannel.Result) {
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

            "hasReadWritePermission" -> {
                hasReadWritePermission(call, result)
            }

            "grantReadWritePermission" -> {
                grantReadWritePermission(call, result)
            }

            "getExternalStorageRootPath" -> {
                getExternalStorageRootPath(call, result)
            }

            "getDefaultOutputDirPath" -> {
                getDefaultOutputDirPath(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getDefaultOutputDirPath(
        call: MethodCall,
        result: MethodChannel.Result
    ) {

        try {
            // 这是获取公共下载目录的标准方法
            val downloadDir: File =
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)

            if (!downloadDir.exists()) {
                downloadDir.mkdirs() // 如果目录不存在，尝试创建它
            }
            val downloadPath = downloadDir.absolutePath

            val finalPath =
                downloadPath + File.separator + "HLB站缓存视频合并" + File.separator + "outputDir"

            val returnMap = mapOf<String, Any?>(
                "code" to 0,
                "msg" to "ok",
                "data" to mapOf<String, Any?>(
                    "path" to finalPath,
                ),
            )
            result.success(returnMap)

        } catch (e: Exception) {
            e.printStackTrace()
        }

        val returnMap = mapOf<String, Any?>(
            "code" to 0,
            "msg" to "ok",
            "data" to mapOf<String, Any?>(
                "path" to null,
            ),
        )
        result.success(returnMap)

    }

    private fun getExternalStorageRootPath(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val path = Environment.getExternalStorageDirectory().absolutePath
        if (path.isBlank()) {
            val returnMap = mapOf<String, Any?>(
                "code" to 0,
                "msg" to "ok",
                "data" to mapOf<String, Any?>(
                    "path" to null,
                ),
            )
            result.success(returnMap)
            return
        }
        val returnMap = mapOf<String, Any?>(
            "code" to 0,
            "msg" to "ok",
            "data" to mapOf<String, Any?>(
                "path" to path,
            ),
        )
        result.success(returnMap)
    }

    fun hasReadWritePermission(call: MethodCall, result: MethodChannel.Result) {
        val grantedPermission = XXPermissions.isGrantedPermission(
            context,
            PermissionLists.getManageExternalStoragePermission()
        )
        val returnMap = mapOf<String, Any?>(
            "code" to 0,
            "msg" to "ok",
            "data" to mapOf<String, Any?>(
                "hasPermission" to grantedPermission,
            ),
        )
        result.success(returnMap)
    }

    fun grantReadWritePermission(call: MethodCall, result: MethodChannel.Result) {
        XXPermissions.with(activity)
            .permission(PermissionLists.getManageExternalStoragePermission())
            // 设置不触发错误检测机制（局部设置）
            //.unchecked()
            .request(object : OnPermissionCallback {
                override fun onResult(
                    grantedList: MutableList<IPermission>,
                    deniedList: MutableList<IPermission>
                ) {
                    val allGranted = deniedList.isEmpty()
                    if (!allGranted) {
                        // 判断请求失败的权限是否被用户勾选了不再询问的选项
                        val doNotAskAgain =
                            XXPermissions.isDoNotAskAgainPermissions(activity, deniedList)
                        // 在这里处理权限请求失败的逻辑
                        if (doNotAskAgain) {
                            ToastTool.toast("申请读写权限被永久拒绝,请手动授权权限")
                            XXPermissions.startPermissionActivity(activity)
                            return
                        }
                        val returnMap = mapOf<String, Any?>(
                            "code" to 0,
                            "msg" to "ok",
                            "data" to mapOf<String, Any?>(
                                "grantPermission" to false,
                            ),
                        )
                        result.success(returnMap)
                        return
                    }
                    // 在这里处理权限请求成功的逻辑
                    val returnMap = mapOf<String, Any?>(
                        "code" to 0,
                        "msg" to "ok",
                        "data" to mapOf<String, Any?>(
                            "grantPermission" to true,
                        ),
                    )
                    result.success(returnMap)

                }
            })
    }


}
