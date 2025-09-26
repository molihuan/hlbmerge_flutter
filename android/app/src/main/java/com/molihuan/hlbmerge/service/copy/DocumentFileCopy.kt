package com.molihuan.hlbmerge.service.copy

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import com.molihuan.hlbmerge.App
import com.molihuan.hlbmerge.utils.UriUtils
import timber.log.Timber
import java.io.File
import java.io.FileOutputStream

class DocumentFileCopy : BaseFileCopy {
    private val context by lazy { App.Companion.instance }

    override suspend fun copyFile(
        src: String,
        dest: String,
        includeRegex: String?,
        excludeRegex: String?,
        progressCallback: ((current: Long, total: Long) -> Unit)?,
        completeCallback: (() -> Unit)?,
        errorCallback: ((e: Exception) -> Unit)?
    ) {
        val includePattern = includeRegex?.let { Regex(it) }
        val excludePattern = excludeRegex?.let { Regex(it) }
        copyDocumentDir(context, src, dest, includePattern, excludePattern, false)
    }

    override suspend fun zeroCopyFile(
        src: String,
        dest: String,
        includeRegex: String?,
        excludeRegex: String?,
        progressCallback: ((current: Long, total: Long) -> Unit)?,
        completeCallback: (() -> Unit)?,
        errorCallback: ((e: Exception) -> Unit)?
    ) {
        val includePattern = includeRegex?.let { Regex(it) }
        val excludePattern = excludeRegex?.let { Regex(it) }
        copyDocumentDir(context, src, dest, includePattern, excludePattern, true)
    }

    private fun copyDocumentDir(
        context: Context,
        srcDirPath: String,
        destDirPath: String,
        include: Regex?,
        exclude: Regex?,
        //是否是zeroCopy
        isZeroCopy: Boolean = false
    ) {
        val hasUriPermissionPair = UriUtils.hasUriPermission(context = context, path = srcDirPath)
        val existsPermission = hasUriPermissionPair.first
        val uri = hasUriPermissionPair.second
        if (existsPermission == null) {
            Timber.d("未授权,无法copyDocumentDir")
            return
        }
        val targetUri = Uri.parse(
            existsPermission + uri.toString()
                .replaceFirst(UriUtils.URI_PERMISSION_REQUEST_COMPLETE_PREFIX, "")
        )

        val pickedDir = DocumentFile.fromTreeUri(context, targetUri)
        if (pickedDir == null) {
            Timber.d("pickedDir为null,无法copyDocumentDir")
            return
        }

        val documentFiles = pickedDir.listFiles()
        documentFiles.forEach {
            val name = it.name
            //源文件路径
            val srcFilePath = srcDirPath + File.separator + name
            //目标文件路径
            val destFilePath = destDirPath + File.separator + name

            if (it.isDirectory) {
                copyDocumentDir(context, srcFilePath, destFilePath, include, exclude, isZeroCopy)
            } else {
                if (isZeroCopy) {
                    zeroCopyDocumentFile(context, it.uri, name, destFilePath, include, exclude)
                } else {
                    copyDocumentFile(context, it.uri, name, destFilePath, include, exclude)
                }
            }
        }
    }

    private fun copyDocumentFile(
        context: Context,
        uri: Uri,
        srcFileName: String?,
        destFilePath: String,
        include: Regex?,
        exclude: Regex?,
    ) {

        //进行过滤
        if (srcFileName != null) {
            if (exclude != null && exclude.matches(srcFileName)) {
                return
            }
            if (include != null && !include.matches(srcFileName)) {
                return
            }
        }


        context.contentResolver.openInputStream(uri)?.use { inputStream ->

            val dest = File(destFilePath)
            if (dest.exists()){
                dest.delete()
            }

            FileOutputStream(destFilePath).use { outputStream ->
                val buffer = ByteArray(8192)
                var bytesRead: Int
                while (inputStream.read(buffer).also { bytesRead = it } != -1) {
                    outputStream.write(buffer, 0, bytesRead)
                }
            }
        }
    }

    private fun zeroCopyDocumentFile(
        context: Context,
        uri: Uri,
        srcFileName: String?,
        destFilePath: String,
        include: Regex?,
        exclude: Regex?,
    ) {
        val shouldZeroCopy = if (srcFileName == null){
            false
        }else{
            (include != null && include.matches(srcFileName)) ||
                    (exclude != null && exclude.matches(srcFileName))
        }
        val dest = File(destFilePath)
        // 确保目标目录存在
        if (dest.parentFile?.exists() == false) {
            dest.parentFile?.mkdirs()
        }

        if (dest.exists()){
            dest.delete()
        }

        if (shouldZeroCopy) {
            // 符合条件的文件进行零数据拷贝（只创建空文件）
            dest.createNewFile()
        } else {
            context.contentResolver.openInputStream(uri)?.use { inputStream ->
                FileOutputStream(dest).use { outputStream ->
                    val buffer = ByteArray(8192)
                    var bytesRead: Int
                    while (inputStream.read(buffer).also { bytesRead = it } != -1) {
                        outputStream.write(buffer, 0, bytesRead)
                    }
                }
            }
        }
    }
}