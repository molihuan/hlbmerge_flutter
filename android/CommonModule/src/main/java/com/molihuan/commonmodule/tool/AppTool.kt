package com.molihuan.commonmodule.tool

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.ChecksSdkIntAtLeast
import com.molihuan.commonmodule.CommonModule

object AppTool {
    //获取app名称
    @JvmStatic
    @JvmOverloads
    fun getAppName(context: Context = CommonModule.application): String? {
        val applicationInfo = context.applicationInfo
        val stringId = applicationInfo.labelRes
        val name = context.getString(stringId)
        if (name.isBlank()) {
            return null
        }
        return name
    }

    //getVersionName
    @JvmStatic
    @JvmOverloads
    fun getVersionName(context: Context = CommonModule.application): String {
        return try {
            val packageManager = context.packageManager
            val packageName = context.packageName
            val packInfo = packageManager.getPackageInfo(packageName, 0)
            packInfo.versionName ?: ""
        } catch (e: Exception) {
            e.printStackTrace()
            ""
        }
    }

    //获取AndroidManifest.xml中meta-data的name为CHANNEL_NAME的值
    @JvmStatic
    fun getChannelName(
        context: Context = CommonModule.application,
        channelName: String = "CHANNEL_NAME"
    ): String? {
        return try {
            val applicationInfo = context.packageManager.getApplicationInfo(
                context.packageName,
                PackageManager.GET_META_DATA
            )
            applicationInfo.metaData.getString(channelName)
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    //判断用户Android版本是否大于等于Android 11
    @ChecksSdkIntAtLeast(api = Build.VERSION_CODES.R)
    @JvmStatic
    fun isAndroid11(): Boolean {
        return android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R
    }

    //判断用户Android版本是否大于等于Android 14
    @ChecksSdkIntAtLeast(api = Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    @JvmStatic
    fun isAndroid14(): Boolean {
        return android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.UPSIDE_DOWN_CAKE
    }

    //判断app是否安装
    @JvmStatic
    fun isAppInstall(packageName: String, context: Context = CommonModule.application): Boolean {
        return try {
            val packageManager = context.packageManager
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                packageManager.getPackageInfo(
                    packageName,
                    PackageManager.PackageInfoFlags.of(0)
                )
            } else {
                packageManager.getPackageInfo(packageName, 0)
            }
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }


}