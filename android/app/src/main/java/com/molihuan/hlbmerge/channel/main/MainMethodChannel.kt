package com.molihuan.hlbmerge.channel.main

import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.os.Bundle
import androidx.core.app.ComponentActivity
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.XXPermissions
import com.hjq.permissions.permission.PermissionLists
import com.hjq.permissions.permission.base.IPermission
import com.molihuan.commonmodule.tool.ToastTool
import com.molihuan.hlbmerge.AndroidActivity
import com.molihuan.hlbmerge.NavRoute
import com.molihuan.hlbmerge.dao.flutter.FlutterSpData
import com.molihuan.hlbmerge.service.copy.BaseFileCopy
import com.molihuan.hlbmerge.service.copy.DocumentFileCopy
import com.molihuan.hlbmerge.service.copy.ShizukuFileCopy
import com.molihuan.hlbmerge.utils.FileUtils
import com.molihuan.hlbmerge.utils.ShizukuUtils
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import timber.log.Timber
import java.io.File
import java.lang.ref.WeakReference
import kotlin.concurrent.thread

@SuppressLint("StaticFieldLeak")
object MainMethodChannel : Application.ActivityLifecycleCallbacks {

    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context
    const val MAIN_CHANNEL_NAME = "com.molihuan.hlbmerge/mainChannel"

    //用一个弱引用来持有当前的 Activity，防止内存泄漏
    private var currentActivityRef: WeakReference<Activity>? = null
    private var currentActivity: Activity?
        // Getter: 每次读取时，都从弱引用中获取
        get() = currentActivityRef?.get()
        // Setter: 每次写入时，都创建一个新的弱引用
        set(value) {
            if (value == null) {
                currentActivityRef?.clear()
                currentActivityRef = null
            } else {
                currentActivityRef = WeakReference(value)
            }
        }

    // 提供一个初始化方法，在应用启动时调用
    fun register(flutterEngineMessenger: BinaryMessenger, context: Context) {
        this.applicationContext = context.applicationContext
        channel = MethodChannel(flutterEngineMessenger, MAIN_CHANNEL_NAME)
        channel.setMethodCallHandler(::methodCallHandler)
    }

    @JvmOverloads
    fun invokeMethod(
        method: String,
        arguments: Any? = null,
        callback: MethodChannel.Result? = null
    ) {
        channel.invokeMethod(method, arguments, callback)
    }

    // 处理 Flutter 方法调用
    fun methodCallHandler(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "startActivity" -> {
                startActivity(call, result)
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

            "copyCacheAudioVideoFile" -> {
                copyCacheAudioVideoFile(call, result)
            }

            "copyCacheStructureFile" -> {
                copyCacheStructureFile(call, result)
            }


            else -> {
                result.notImplemented()
            }
        }
    }

    //运行在携程中
    private fun runOnCoroutine(block: suspend () -> Unit) {
        currentActivity?.let {
            if (it is LifecycleOwner) {
                it.lifecycleScope.launch(Dispatchers.IO) {
                    block()
                }
            } else {
                throw IllegalArgumentException("currentActivity is not implement LifecycleOwner")
            }
        } ?: throw NullPointerException("currentActivity is null")
    }

    private fun copyCacheStructureFile(
        call: MethodCall,
        result: MethodChannel.Result
    ) {

        //判断是否有Shizuku权限
        val shizukuPermission = ShizukuUtils.isShizukuAvailableAndHasPermission()
        val fileCopy: BaseFileCopy? = if (shizukuPermission) {
            ShizukuFileCopy()
        } else {
            val inputCacheDirPath = FlutterSpData.getInputCacheDirPath()
            if (inputCacheDirPath == FlutterSpData.cacheCopyTempPath) {
                //说明是uri授权
                DocumentFileCopy()
            } else {
                null
            }
        }
        if (fileCopy == null) {
            return
        }

        val inputCachePackageName = FlutterSpData.getAndroidInputCachePackageName()

        val srcDir = "${FileUtils.androidDataPath}/${inputCachePackageName}/download"
        val targetDir = FlutterSpData.cacheCopyTempPath
        runOnCoroutine {
            //复制缓存整体结构,m4s,blv文件只做0拷贝
            fileCopy.zeroCopyFile(
                srcDir,
                targetDir,
                excludeRegex = ".*\\.(m4s|blv)$",
                completeCallback = {
                    val returnMap = mapOf<String, Any?>(
                        "code" to 0,
                        "msg" to "ok",
                        "data" to null,
                    )
                    result.success(returnMap)
                },
                errorCallback = {
                    val returnMap = mapOf<String, Any?>(
                        "code" to -1,
                        "msg" to "err",
                        "data" to it.message,
                    )
                    result.success(returnMap)
                })

        }
    }

    private fun copyCacheAudioVideoFile(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        // 获取 Flutter 传递的参数
        val sufPathParam = call.argument<String>("sufPath")
        if (sufPathParam.isNullOrBlank()) {
            return
        }
        val sufPath = if (sufPathParam.startsWith(File.separator)) {
            sufPathParam
        } else {
            File.separator + sufPathParam
        }
        //判断是否有Shizuku权限
        val shizukuPermission = ShizukuUtils.isShizukuAvailableAndHasPermission()
        val fileCopy: BaseFileCopy? = if (shizukuPermission) {
            ShizukuFileCopy()
        } else {
            val inputCacheDirPath = FlutterSpData.getInputCacheDirPath()
            if (inputCacheDirPath == FlutterSpData.cacheCopyTempPath) {
                //说明是uri授权
                DocumentFileCopy()
            } else {
                null
            }
        }
        if (fileCopy == null) {
            return
        }

        val inputCachePackageName = FlutterSpData.getAndroidInputCachePackageName()

        val srcDir = "${FileUtils.androidDataPath}/${inputCachePackageName}/download${sufPath}"
        val targetDir = FlutterSpData.cacheCopyTempPath + sufPath
        Timber.d("copyCacheAudioVideoFile: $srcDir $targetDir")
        runOnCoroutine {
            //只复制m4s,blv文件
            fileCopy.copyFile(
                srcDir,
                targetDir,
                includeRegex = ".*\\.(m4s|blv)$",
                completeCallback = {
                    val returnMap = mapOf<String, Any?>(
                        "code" to 0,
                        "msg" to "ok",
                        "data" to null,
                    )
                    result.success(returnMap)
                },
                errorCallback = {
                    val returnMap = mapOf<String, Any?>(
                        "code" to -1,
                        "msg" to "err",
                        "data" to it.message,
                    )
                    result.success(returnMap)
                })
        }
    }


    private fun startActivity(call: MethodCall, result: MethodChannel.Result) {
        // 获取 Flutter 传递的参数
        val to = call.argument<String>("to")
        Timber.d("startActivity: $to")
        when (to) {
            "AndroidActivity/PathSelectScreen" -> {
                currentActivity?.let {
                    AndroidActivity.go(it, NavRoute.PathSelect(NavRoute.PathSelect.Args()))
                }
            }
        }
        val returnMap = mapOf<String, Any?>(
            "code" to 0,
            "msg" to "ok",
            "data" to null,
        )
        result.success(returnMap)
    }

    private fun getDefaultOutputDirPath(
        call: MethodCall,
        result: MethodChannel.Result
    ) {

        try {
            // 这是获取公共下载目录的标准方法
            val finalPath = FlutterSpData.getDefaultOutputDirPath()
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
        val path = FileUtils.externalStorageRootPath
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

    private fun hasReadWritePermission(call: MethodCall, result: MethodChannel.Result) {
        val context = currentActivity ?: return
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

    private fun grantReadWritePermission(call: MethodCall, result: MethodChannel.Result) {
        val activity = currentActivity ?: return
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


    override fun onActivityDestroyed(activity: Activity) {
        if (currentActivity == activity) {
            currentActivity = null // 确保销毁时也清除引用
        }
    }

    override fun onActivityPaused(activity: Activity) {
        if (currentActivity == activity) {
            currentActivity = null // 当 Activity 离开前台时，清除引用
        }
    }

    override fun onActivityResumed(activity: Activity) {
        currentActivity = activity
    }

    override fun onActivityCreated(
        activity: Activity,
        savedInstanceState: Bundle?
    ) {
    }

    override fun onActivitySaveInstanceState(
        activity: Activity,
        outState: Bundle
    ) {
    }

    override fun onActivityStarted(activity: Activity) {}

    override fun onActivityStopped(activity: Activity) {}

}