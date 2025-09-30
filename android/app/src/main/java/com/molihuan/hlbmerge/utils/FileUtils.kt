package com.molihuan.hlbmerge.utils

import android.os.Environment
import com.molihuan.commonmodule.tool.AppTool
import java.io.File

object FileUtils {
    val externalStorageRootPath = Environment.getExternalStorageDirectory().absolutePath

    //Android/data目录
    val androidDataPath = "$externalStorageRootPath/Android/data"
    //Android/data漏洞目录
    val androidDataVulnerabilityPath = "$externalStorageRootPath/Android/\u200bdata"

    //Android/obb目录
    val androidObbPath = "$externalStorageRootPath/Android/obb"
    val externalStorageDownloadsPath =
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).absolutePath

    //判断Android/data是否有读权限
    fun canAccessAndroidData(): Boolean {
        if (AppTool.isAndroid11()) {
            return File(androidDataVulnerabilityPath).canRead()
        } else {
            return File(androidDataPath).canRead()
        }
    }


}