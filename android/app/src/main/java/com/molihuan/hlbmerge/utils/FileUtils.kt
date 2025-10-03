package com.molihuan.hlbmerge.utils

import android.content.ContentValues
import android.content.Context
import android.media.MediaScannerConnection
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import com.molihuan.commonmodule.tool.AppTool
import timber.log.Timber
import java.io.File

object FileUtils {
    private const val TAG = "FileUtils"
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

    /**
     * 刷新单个文件到 MediaStore
     */
    fun refreshFileMediaStore(context: Context, file: File) {
        if (!file.exists() || !file.isFile) {
            Timber.tag(TAG).w("refreshFileMediaStore: 文件不存在 -> ${file.absolutePath}")
            return
        }

        val mimeType = getMimeType(file)

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            // Android 9 及以下用 scanFile
            MediaScannerConnection.scanFile(
                context,
                arrayOf(file.absolutePath),
                arrayOf(mimeType),
            ) { path, uri ->
                Timber.tag(TAG).d("scanFile完成: $path -> $uri")
            }
        } else {
            // Android 10 及以上：插入 MediaStore
            try {
                val values = ContentValues().apply {
                    put(MediaStore.MediaColumns.DATA, file.absolutePath) // 已弃用，但兼容性好
                    put(MediaStore.MediaColumns.DISPLAY_NAME, file.name)
                    put(MediaStore.MediaColumns.SIZE, file.length())
                    put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                    put(MediaStore.MediaColumns.DATE_ADDED, System.currentTimeMillis() / 1000)
                    put(MediaStore.MediaColumns.DATE_MODIFIED, file.lastModified() / 1000)
                }

                val uri: Uri = when {
                    mimeType.startsWith("video") -> MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                    mimeType.startsWith("audio") -> MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
                    mimeType.startsWith("image") -> MediaStore.Images.Media.EXTERNAL_CONTENT_URI
                    else -> MediaStore.Downloads.EXTERNAL_CONTENT_URI
                }

                context.contentResolver.insert(uri, values)
                Timber.tag(TAG).d("插入 MediaStore 成功 -> ${file.absolutePath}")
            } catch (e: Exception) {
                Timber.tag(TAG).e("插入 MediaStore 失败: ${e.message}")
                // 兜底用 scanFile
                MediaScannerConnection.scanFile(
                    context,
                    arrayOf(file.absolutePath),
                    arrayOf(mimeType),
                ) { path, uri2 ->
                    Timber.tag(TAG).d("兜底 scanFile: $path -> $uri2")
                }
            }
        }
    }

    fun refreshDirMediaStore(context: Context, dirPath: String) {
        refreshDirMediaStore(context, File(dirPath))
    }

    /**
     * 递归刷新目录下所有文件
     */
    fun refreshDirMediaStore(context: Context, dir: File) {
        if (!dir.exists() || !dir.isDirectory) {
            Timber.tag(TAG).w("refreshDirMediaStore: 目录不存在 -> ${dir.absolutePath}")
            return
        }
        dir.walkTopDown().forEach { file ->
            if (file.isFile) {
                refreshFileMediaStore(context, file)
            }
        }
    }

    /**
     * 简单 MIME 类型推断
     */
    private fun getMimeType(file: File): String {
        val name = file.name.lowercase()
        return when {
            name.endsWith(".mp4") -> "video/mp4"
            name.endsWith(".mkv") -> "video/x-matroska"
            name.endsWith(".avi") -> "video/x-msvideo"
            name.endsWith(".mp3") -> "audio/mpeg"
            name.endsWith(".aac") -> "audio/aac"
            name.endsWith(".wav") -> "audio/wav"
            name.endsWith(".flac") -> "audio/flac"
            name.endsWith(".jpg") || name.endsWith(".jpeg") -> "image/jpeg"
            name.endsWith(".png") -> "image/png"
            name.endsWith(".gif") -> "image/gif"
            else -> "application/octet-stream"
        }
    }


}