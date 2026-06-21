package com.molihuan.hlbmerge.utils

import android.content.pm.PackageManager
import com.molihuan.commonmodule.tool.AppTool
import com.molihuan.commonmodule.tool.ToastTool
import rikka.shizuku.Shizuku
import timber.log.Timber

object ShizukuUtils {
    //请求权限的请求码
    const val REQUEST_CODE_SHIZUKU_PERMISSION = 1112
    //判断Shizuku可用性
    fun isShizukuAvailable(): Pair<Boolean, String> {
        val isInstall = AppTool.isAppInstall("moe.shizuku.privileged.api")
        if (!isInstall) {
            return Pair(false, "请先安装Shizuku")
        }

        if (!Shizuku.pingBinder()) {
            Timber.d("Shizuku服务异常")
            return Pair(false, "请检查Shizuku服务是否启动,异常:pingBinder is false")
        }

        //判断Shizuku版本是否满足要求
        if (Shizuku.isPreV11() || Shizuku.getVersion() < 10) {
            return Pair(false, "Shizuku版本太低,请升级Shizuku版本")
        }

        return Pair(true, "")
    }

    //判断是否有Shizuku权限
    fun hasShizukuPermission(): Boolean {
        if (Shizuku.checkSelfPermission() != PackageManager.PERMISSION_GRANTED) {
            return false
        }
        return true
    }

    // 是否可用并且有权限
    fun isShizukuAvailableAndHasPermission(): Boolean {
        val shizukuAvailablePair = isShizukuAvailable()
        if (!shizukuAvailablePair.first) {
            return false
        }
        if (!hasShizukuPermission()) {
            return false
        }
        return true
    }

    // 请求 Shizuku 权限
    fun requestShizukuPermission() {
        val shizukuAvailablePair = isShizukuAvailable()
        if (!shizukuAvailablePair.first) {
            ToastTool.toast(shizukuAvailablePair.second)
            return
        }
        if (hasShizukuPermission()) {
            Timber.d("Shizuku权限已获取")
            return
        }
        Shizuku.requestPermission(REQUEST_CODE_SHIZUKU_PERMISSION)
    }
}