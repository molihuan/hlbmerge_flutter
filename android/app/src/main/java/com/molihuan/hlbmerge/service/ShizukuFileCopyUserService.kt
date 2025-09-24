package com.molihuan.hlbmerge.service

import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
//被绑定的进程会在Shizuku权限下运行
class ShizukuFileCopyUserService : IShizukuFileCopy.Stub() {
    override fun copy(src: String?, dest: String?, includeRegex: String?, excludeRegex: String?) {
        if (src == null || dest == null) return
        val includePattern = includeRegex?.let { Regex(it) }
        val excludePattern = excludeRegex?.let { Regex(it) }

        val srcFile = File(src)
        val destFile = File(dest)
        copyRecursively(srcFile, destFile, includePattern, excludePattern)
    }

    private fun copyRecursively(src: File, dest: File, include: Regex?, exclude: Regex?) {
        // 文件过滤
        if (src.isFile) {
            val name = src.name
            if (exclude != null && exclude.matches(name)) return
            if (include != null && !include.matches(name)) return
        }

        if (src.isDirectory) {
            if (!dest.exists()) dest.mkdirs()
            src.listFiles()?.forEach { child ->
                copyRecursively(child, File(dest, child.name), include, exclude)
            }
        } else {
            FileInputStream(src).use { input ->
                FileOutputStream(dest).use { output ->
                    input.copyTo(output)
                }
            }
        }
    }
}