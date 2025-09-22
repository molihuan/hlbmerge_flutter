package com.molihuan.hlbmerge.utils

import android.os.Environment

object FileUtils {
    val externalStorageRootPath = Environment.getExternalStorageDirectory().absolutePath

    //Android/data目录
    val androidDataPath = "$externalStorageRootPath/Android/data"

    //Android/obb目录
    val androidObbPath = "$externalStorageRootPath/Android/obb"
    val externalStorageDownloadsPath =
        Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).absolutePath


}