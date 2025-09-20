package com.molihuan.commonmodule.tool

import android.content.Context
import android.content.pm.PackageManager
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



}