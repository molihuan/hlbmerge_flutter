package com.molihuan.hlbmerge.pigeon.impl

import NativeApis
import NativePageParams
import TupleBool
import TupleStr
import android.app.Activity
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.XXPermissions
import com.hjq.permissions.permission.PermissionLists
import com.hjq.permissions.permission.base.IPermission
import com.molihuan.commonmodule.tool.FileTool
import com.molihuan.commonmodule.tool.ToastTool
import com.molihuan.hlbmerge.AndroidActivity
import com.molihuan.hlbmerge.repository.SettingsRepository
import com.molihuan.hlbmerge.service.copy.BaseFileCopy
import com.molihuan.hlbmerge.service.copy.DocumentFileCopy
import com.molihuan.hlbmerge.service.copy.ShizukuFileCopy
import com.molihuan.hlbmerge.utils.FileUtils
import com.molihuan.hlbmerge.utils.ShizukuUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import timber.log.Timber
import java.io.File


class NativeApisImpl(
    private val activity: Activity,
    private val coroutineScope: CoroutineScope
) :
    NativeApis {
    override fun goNativePage(router: String, params: NativePageParams?): TupleBool {
        AndroidActivity.go(activity)
        return TupleBool.success()
    }

    override fun hasReadWritePermission(): TupleBool {
        val grantedPermission = XXPermissions.isGrantedPermission(
            activity,
            PermissionLists.getManageExternalStoragePermission()
        )
        return if (grantedPermission) {
            TupleBool.success()
        } else {
            TupleBool.fail("没有读写权限")
        }
    }

    override fun grantReadWritePermission(callback: (Result<TupleBool>) -> Unit) {
        XXPermissions.with(activity)
            .permission(PermissionLists.getManageExternalStoragePermission())
            // 设置不触发错误检测机制（局部设置）
            //.unchecked()
            .request(object : OnPermissionCallback {
                override fun onPermissionResult(
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
                        callback.invoke(Result.success(TupleBool.fail("没有读写权限")))
                        return
                    }
                    // 在这里处理权限请求成功的逻辑
                    callback.invoke(Result.success(TupleBool.success()))

                }
            })
    }

    override fun getExternalStorageRootPath(): TupleStr {
        val path = FileUtils.externalStorageRootPath
        return if (path.isNotEmpty()) {
            TupleStr.success(path)
        } else {
            TupleStr.fail("获取存储根目录失败")
        }
    }

    override fun getDefaultOutputDirPath(): TupleStr {
        try {
            // 这是获取公共下载目录的标准方法
            val finalPath = SettingsRepository.getDefaultOutputDirPath()
            return TupleStr.success(finalPath)
        } catch (e: Exception) {
            e.printStackTrace()
        }

        return TupleStr.fail("获取默认输出目录失败")
    }

    override fun copyCacheAudioVideoFile(
        sufPathParam: String,
        callback: (Result<TupleBool>) -> Unit
    ) {
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
            val inputCacheDirPath = SettingsRepository.getInputCacheDirPath()
            if (inputCacheDirPath == SettingsRepository.cacheCopyTempPath) {
                //说明是uri授权
                DocumentFileCopy()
            } else {
                null
            }
        }
        if (fileCopy == null) {
            callback.invoke(Result.success(TupleBool.success()))
            return
        }

        val inputCachePackageName = SettingsRepository.getAndroidInputCachePackageName()

        val srcDir = "${FileUtils.androidDataPath}/${inputCachePackageName}/download${sufPath}"
        val targetDir = SettingsRepository.cacheCopyTempPath + sufPath
        Timber.d("copyCacheAudioVideoFile: $srcDir $targetDir")

        coroutineScope.launch(Dispatchers.IO) {
            //只复制m4s,blv文件
            fileCopy.copyFile(
                srcDir,
                targetDir,
                includeRegex = ".*\\.(m4s|blv)$",
                completeCallback = {
                    callback.invoke(Result.success(TupleBool.success()))
                },
                errorCallback = {
                    callback.invoke(Result.success(TupleBool.fail(it.message ?: "未知错误")))
                })
        }
    }

    override fun copyCacheStructureFile(callback: (Result<TupleBool>) -> Unit) {
        //判断是否有Shizuku权限
        val shizukuPermission = ShizukuUtils.isShizukuAvailableAndHasPermission()
        val fileCopy: BaseFileCopy? = if (shizukuPermission) {
            ShizukuFileCopy()
        } else {
            val inputCacheDirPath = SettingsRepository.getInputCacheDirPath()
            if (inputCacheDirPath == SettingsRepository.cacheCopyTempPath) {
                //说明是uri授权
                DocumentFileCopy()
            } else {
                null
            }
        }
        if (fileCopy == null) {
            callback.invoke(Result.success(TupleBool.success()))
            return
        }

        val inputCachePackageName = SettingsRepository.getAndroidInputCachePackageName()
        if (inputCachePackageName.isNullOrBlank()) {
            callback.invoke(Result.success(TupleBool.fail("请选择缓存来源app")))
            return
        }

        val srcDir = "${FileUtils.androidDataPath}/${inputCachePackageName}/download"
        val targetDir = SettingsRepository.cacheCopyTempPath
        coroutineScope.launch(Dispatchers.IO) {
            //先删除拷贝缓存临时目录
            FileTool.deleteAllFiles(SettingsRepository.cacheCopyTempPath)
            //复制缓存整体结构,m4s,blv文件只做0拷贝
            fileCopy.zeroCopyFile(
                srcDir,
                targetDir,
                excludeRegex = ".*\\.(m4s|blv)$",
                completeCallback = {
                    callback.invoke(Result.success(TupleBool.success()))
                },
                errorCallback = {
                    callback.invoke(Result.success(TupleBool.fail(it.message ?: "未知错误")))
                })

        }
    }

    override fun notifyExportComplete(callback: (Result<TupleBool>) -> Unit) {
        //获取输出路径
        val outputDirPath = SettingsRepository.getOutputDirPath()
        FileUtils.refreshDirMediaStore(activity, outputDirPath)
        callback.invoke(Result.success(TupleBool.success()))
    }

}


fun TupleBool.Companion.success(msg: String = ""): TupleBool {
    return TupleBool(0, msg, true)
}

fun TupleBool.Companion.fail(msg: String, code: Long = -1): TupleBool {
    return TupleBool(code, msg, false)
}

fun TupleStr.Companion.success(data: String, msg: String = ""): TupleStr {
    return TupleStr(0, msg, data)
}

fun TupleStr.Companion.fail(msg: String, code: Long = -1): TupleStr {
    return TupleStr(code, msg, null)
}
