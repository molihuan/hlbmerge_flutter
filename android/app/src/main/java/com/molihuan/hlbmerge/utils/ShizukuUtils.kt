package com.molihuan.hlbmerge.utils

import android.content.ComponentName
import android.content.ServiceConnection
import android.os.Binder
import android.os.IBinder
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import rikka.shizuku.Shizuku
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import kotlin.jvm.java

/**
 * Shizuku 通用工具类。
 * 使用 UserService 方案来执行需要高权限的文件操作。
 */
object ShizukuUtils {

    private const val TAG = "ShizukuUtils"

    private var service: ShizukuShellService? = null

    sealed class FileFilter {
        data class ExcludeByExtension(
            val extensions: List<String>,
            val caseSensitive: Boolean = false
        ) : FileFilter()
    }

    suspend fun copy(sourcePath: String, destPath: String, filter: FileFilter? = null): ShizukuResult {
        val fullSourcePath = sourcePath.trimEnd('/')
        val fullDestPath = destPath.trimEnd('/')

        if (!exists(fullSourcePath)) {
            return ShizukuResult(
                exitCode = -1,
                stdout = emptyList(),
                stderr = listOf("Source path does not exist: $fullSourcePath")
            )
        }

        val mkdirResult = mkdir(fullDestPath)
        if (!mkdirResult.isSuccess) return mkdirResult

        val sourceParent = File(fullSourcePath).parent ?: "/"
        val sourceName = File(fullSourcePath).name
        val filterArgs = buildFindFilterArgs(filter)

        val command = "cd '$sourceParent' && find '$sourceName' $filterArgs | cpio -pdmv '$fullDestPath'"
        return execute(command)
    }

    suspend fun exists(path: String): Boolean {
        val result = execute("ls -d '$path'")
        return result.isSuccess
    }

    suspend fun mkdir(path: String): ShizukuResult {
        return execute("mkdir -p '$path'")
    }

    suspend fun delete(path: String): ShizukuResult {
        return execute("rm -rf '$path'")
    }

    private fun buildFindFilterArgs(filter: FileFilter?): String {
        return when (filter) {
            is FileFilter.ExcludeByExtension -> {
                if (filter.extensions.isEmpty()) "" else {
                    val nameOption = if (filter.caseSensitive) "-name" else "-iname"
                    filter.extensions.joinToString(" ") { "! $nameOption \"*.$it\"" }
                }
            }
            null -> ""
        }
    }

    /**
     * 执行命令，通过 ShizukuShellService。
     */
    suspend fun execute(command: String): ShizukuResult {
        if (!isShizukuAvailable()) {
            return ShizukuResult(-1, emptyList(), listOf("Shizuku service is not available."))
        }

        if (service == null) {
            val bound = bindService()
            if (!bound) {
                return ShizukuResult(-1, emptyList(), listOf("Failed to bind Shizuku service."))
            }
        }

        return withContext(Dispatchers.IO) {
            service?.runCommand(command)
                ?: ShizukuResult(-1, emptyList(), listOf("Service is null"))
        }
    }

    private fun isShizukuAvailable(): Boolean {
        return try {
            Shizuku.checkSelfPermission() == 0 && !Shizuku.isPreV11()
        } catch (e: Exception) {
            false
        }
    }

    private fun bindService(): Boolean {
        return try {
            val args = Shizuku.UserServiceArgs(
                ComponentName("com.molihuan.hlbmerge", ShizukuShellService::class.java.name)
            ).daemon(false).processNameSuffix("shell")

            Shizuku.bindUserService(args, object : ServiceConnection {
                override fun onServiceConnected(name: ComponentName?, binder: IBinder?) {
                    service = binder as? ShizukuShellService
                    Log.d(TAG, "Shizuku service connected")
                }

                override fun onServiceDisconnected(name: ComponentName?) {
                    service = null
                    Log.d(TAG, "Shizuku service disconnected")
                }
            })
            true
        } catch (e: Exception) {
            Log.e(TAG, "bindService failed", e)
            false
        }
    }

    data class ShizukuResult(
        val exitCode: Int,
        val stdout: List<String>,
        val stderr: List<String>
    ) {
        val isSuccess: Boolean get() = exitCode == 0
    }
}

/**
 * Shizuku 用户服务，负责执行 Shell 命令。
 * 会在 ShizukuUtils 中被绑定并调用。
 */
class ShizukuShellService : Binder() {

    fun runCommand(command: String): ShizukuUtils.ShizukuResult {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("sh", "-c", command))
            val stdout = BufferedReader(InputStreamReader(process.inputStream)).readLines()
            val stderr = BufferedReader(InputStreamReader(process.errorStream)).readLines()
            val exitCode = process.waitFor()

            ShizukuUtils.ShizukuResult(exitCode, stdout, stderr)
        } catch (e: Exception) {
            ShizukuUtils.ShizukuResult(-1, emptyList(), listOf(e.message ?: "Unknown error"))
        }
    }
}
