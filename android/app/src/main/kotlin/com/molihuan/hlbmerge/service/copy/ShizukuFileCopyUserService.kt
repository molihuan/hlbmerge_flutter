package com.molihuan.hlbmerge.service.copy

import com.molihuan.hlbmerge.service.IShizukuFileCopy
import com.molihuan.hlbmerge.service.IShizukuFileCopyCallback
import timber.log.Timber
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.util.concurrent.Executors

//被绑定的进程会在Shizuku权限下运行
class ShizukuFileCopyUserService : IShizukuFileCopy.Stub() {

    private val executor = Executors.newSingleThreadExecutor()
    override fun copy(
        src: String?,
        dest: String?,
        includeRegex: String?,
        excludeRegex: String?,
        cb: IShizukuFileCopyCallback?
    ) {
        if (src == null || dest == null) return
        val includePattern = includeRegex?.let { Regex(it) }
        val excludePattern = excludeRegex?.let { Regex(it) }
        Timber.d("ShizukuFileCopyUserService: copy $src to $dest")

        executor.execute {
            try {
                val srcFile = File(src)
                val destFile = File(dest)
                copy(srcFile, destFile, includePattern, excludePattern)
                cb?.onComplete()
            } catch (e: Exception) {
                cb?.onError(e.message ?: "unknown error")
            }
        }
    }

    private fun copy(src: File, dest: File, include: Regex?, exclude: Regex?) {
        // 文件过滤
        if (src.isFile) {
            val name = src.name
            if (exclude != null && exclude.matches(name)) return
            if (include != null && !include.matches(name)) return
        }

        if (src.isDirectory) {
            if (!dest.exists()) dest.mkdirs()
            src.listFiles()?.forEach { child ->
                copy(child, File(dest, child.name), include, exclude)
            }
        } else {
            if (dest.exists()) {
                dest.delete()
            }
            FileInputStream(src).use { input ->
                FileOutputStream(dest).use { output ->
                    input.copyTo(output)
                }
            }
        }
    }

    /**
     * 全部拷贝,指定规则的文件进行0数据拷贝
     * @param src    源目录/文件路径
     * @param dest   目标目录/文件路径
     * @param includeRegex   包含的正则 (可为 null)
     * @param excludeRegex   排除的正则 (可为 null)
     */
    override fun zeroCopy(
        src: String?,
        dest: String?,
        includeRegex: String?,
        excludeRegex: String?,
        cb: IShizukuFileCopyCallback?
    ) {
        if (src == null || dest == null) return
        val includePattern = includeRegex?.let { Regex(it) }
        val excludePattern = excludeRegex?.let { Regex(it) }

        executor.execute {
            try {
                val srcFile = File(src)
                val destFile = File(dest)
                zeroCopy(srcFile, destFile, includePattern, excludePattern)
                cb?.onComplete()
            } catch (e: Exception) {
                cb?.onError(e.message ?: "unknown error")
            }
        }

    }

    private fun zeroCopy(src: File, dest: File, include: Regex?, exclude: Regex?) {
        // 正常遍历所有文件和目录
        if (src.isDirectory) {
            if (!dest.exists()) dest.mkdirs()
            src.listFiles()?.forEach { child ->
                zeroCopy(child, File(dest, child.name), include, exclude)
            }
        } else {
            // 对所有文件先检查是否符合零拷贝条件
            val name = src.name
            val shouldZeroCopy = (include != null && include.matches(name)) ||
                    (exclude != null && exclude.matches(name))

            // 确保目标目录存在
            if (dest.parentFile?.exists() == false) {
                dest.parentFile?.mkdirs()
            }
            //先清理
            if (dest.exists()) {
                dest.delete()
            }

            if (shouldZeroCopy) {
                // 符合条件的文件进行零数据拷贝（只创建空文件）
                dest.createNewFile()
            } else {
                // 不符合条件的文件正常拷贝
                FileInputStream(src).use { input ->
                    FileOutputStream(dest).use { output ->
                        input.copyTo(output)
                    }
                }
            }
        }
    }


}