package com.molihuan.commonmodule.tool

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.OpenableColumns
import androidx.core.content.FileProvider
import com.molihuan.commonmodule.CommonModule
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

object FileTool {
    //临时文件夹名称
    const val TEMP_DIR_NAME = "temps"

    //复制uri文件缓存文件夹名称
    const val COPY_URI_FILE_CACHE_DIR_NAME = "copyUriFiles"

    //删除单个文件
    @JvmStatic
    fun deleteFile(filePath: String): Boolean {
        val file = File(filePath)
        return file.delete()
    }

    @JvmStatic
    fun deleteFiles(filePaths: List<String>): Boolean {
        for (filePath in filePaths) {
            val file = File(filePath)
            if (!file.delete()) {
                return false
            }
        }
        return true
    }

    //删除指定路径下的所有文件包括文件夹
    @JvmStatic
    fun deleteAllFiles(filePath: String): Boolean {
        val file = File(filePath)
        if (!file.exists()) {
            return false
        }

        return try {
            if (file.isFile) {
                file.delete()
            } else {
                // 递归删除子文件和文件夹
                file.listFiles()?.forEach { child ->
                    deleteAllFiles(child.absolutePath)
                }
                // 删除空文件夹本身
                file.delete()
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    @JvmStatic
    fun shareFile(context: Context, filePath: String): Boolean {
        val file = File(filePath)

        if (!file.exists()) {
            return false
        }

        // 使用 FileProvider 获取 content:// Uri
        val uri = FileProvider.getUriForFile(
            context,
            "${context.packageName}.fileprovider",
            file
        )

        val shareIntent = Intent(Intent.ACTION_SEND).apply {
            type = "*/*" // 可以改为精确的 MIME，比如 "application/pdf"、"image/png"
            putExtra(Intent.EXTRA_STREAM, uri)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }

        context.startActivity(Intent.createChooser(shareIntent, "分享文件"))
        return true
    }

    /**
     * 特别注意,不能存储重要的文件,因为每次启动应用都会清空临时文件
     * 在内部缓存文件中创建一个temps文件夹,用来存储临时文件,方便随时删除,文件名随机
     */
    @JvmStatic
    @JvmOverloads
    fun createTempFile(
        context: Context = CommonModule.application,
        //文件名前缀
        filePrefix: String = "temp_",
        fileName: String = "${System.currentTimeMillis()}",
        //文件后缀名
        fileExtension: String = ""
    ): File {
        val cacheDir = context.cacheDir
        val tempDir = File(cacheDir, TEMP_DIR_NAME)
        if (!tempDir.exists()) {
            tempDir.mkdirs()
        }
        return File(tempDir, filePrefix + fileName + fileExtension)
    }

    /**
     *  删除所有的临时文件
     */
    @JvmStatic
    @JvmOverloads
    fun deleteTempFiles(
        context: Context = CommonModule.application
    ) {
        val cacheDir = context.cacheDir
        val tempDir = File(cacheDir, TEMP_DIR_NAME)
        if (!tempDir.exists()) {
            return
        }
        val files = tempDir.listFiles()
        if (files == null || files.isEmpty()) {
            return
        }
        for (file in files) {
            file.delete()
        }
    }


    @JvmStatic
    @JvmOverloads
    fun copyUriFileToCacheDir(
        uri: Uri,
        newFileName: String? = null,
        cacheDirName: String = COPY_URI_FILE_CACHE_DIR_NAME,
        context: Context = CommonModule.application
    ): File {
        var fileName = newFileName

        if (fileName == null) {
            // 1. 获取原始文件名
            context.contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                val nameIndex = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (cursor.moveToFirst() && nameIndex >= 0) {
                    fileName = cursor.getString(nameIndex)
                }
            }
        }

        // 2. 创建缓存子目录
        val dir = File(context.cacheDir, cacheDirName)
        if (!dir.exists()) {
            dir.mkdirs()
        }

        if (fileName == null) {
            fileName = "file_${System.currentTimeMillis()}"
        }

        // 3. 生成目标文件
        val file = File(dir, fileName)

        // 4. 复制内容
        context.contentResolver.openInputStream(uri)?.use { input ->
            FileOutputStream(file).use { output ->
                input.copyTo(output)
            }
        }

        return file
    }


    @JvmStatic
    @JvmOverloads
    fun getFileInfoByUri(
        uri: Uri,
        context: Context = CommonModule.application
    ): Triple<String?, Long?, String?> {
        var name: String? = null
        var size: Long? = null
        val type: String? = context.contentResolver.getType(uri) // MIME 类型

        val cursor = context.contentResolver.query(uri, null, null, null, null)
        cursor?.use {
            val nameIndex = it.getColumnIndex(OpenableColumns.DISPLAY_NAME)
            val sizeIndex = it.getColumnIndex(OpenableColumns.SIZE)
            if (it.moveToFirst()) {
                name = if (nameIndex >= 0) it.getString(nameIndex) else null
                size = if (sizeIndex >= 0) it.getLong(sizeIndex) else null
            }
        }
        return Triple(name, size, type)
    }

    /**
     * 生成时间命名
     * @param pre 前缀
     * @param suf 后缀
     * @return 时间命名
     */
    @JvmStatic
    @JvmOverloads
    fun generateTimeName(pre: String? = null, suf: String? = null): String {
        val now = Calendar.getInstance().time
        val formatter = SimpleDateFormat("yyyyMMdd_HH_mm", Locale.getDefault())
        val timePart = formatter.format(now)

        // 随机 4 位数字
        val randomPart = (1000..9999).random()

        return "${pre}${timePart}_$randomPart${suf}"
    }

    //修改文件名
    @JvmStatic
    fun rename(filePath: String, newFileName: String): String? {
        return try {
            val file = File(filePath)
            val newFile = File(file.parent, newFileName)
            file.renameTo(newFile)
            newFile.path
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    /**
     * 拆分文件名为 [name, ext]，其中 ext 包含 "."
     */
    @JvmStatic
    fun splitFileName(fileName: String): Pair<String, String> {
        val index = fileName.lastIndexOf('.')
        return if (index != -1) {
            val name = fileName.substring(0, index)
            val ext = fileName.substring(index)
            name to ext
        } else {
            fileName to ""
        }
    }


}