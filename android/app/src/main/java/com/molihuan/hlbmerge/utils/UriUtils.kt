package com.molihuan.hlbmerge.utils

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Environment
import android.provider.DocumentsContract
import androidx.documentfile.provider.DocumentFile
import com.molihuan.hlbmerge.App
import timber.log.Timber
import java.io.File


object UriUtils {

    const val URI_PERMISSION_REQUEST_CODE: Int = 54111

    //uri请求权限构建前缀
    const val URI_PERMISSION_REQUEST_PREFIX: String = "com.android.externalstorage.documents"

    //uri请求权限构建完整前缀
    const val URI_PERMISSION_REQUEST_COMPLETE_PREFIX: String =
        "content://com.android.externalstorage.documents"

    //uri请求权限构建后缀主要特殊符号
    const val URI_PERMISSION_REQUEST_SUFFIX_SPECIAL_SYMBOL: String = "primary:"
    const val URI_PERMISSION_REQUEST_DOCUMENT_PRIMARY: String = "documents/document/primary"
    const val URI_PERMISSION_REQUEST_TREE_PRIMARY: String = "documents/tree/primary"

    //uri路径分割符
    const val URI_SEPARATOR: String = "%2F"



    @JvmStatic
    fun grantUriPermission(activity: Activity, path: String) {
        val uri = path2Uri(path)
        grantUriPermission(activity = activity, uri = uri)
    }

    /**
     * 跳转请求权限SAF页面 注意Android 13对 Android/data目录进行了更加严格的限制已经无法获取其权限了 但是可以获取其子目录权限，我们可以对其子目录进行权限申请，从而达到操作Android/data目录的目的 其子目录可以通过Android/data+本机安装软件包名来获得 如获取谷歌浏览器包名:com.android.chrome 拼接:Android/data/com.android.chrome 我们只要申请这个目录的uri权限即可操作这个目录 最终跳转的uir字符串为:content://com.android.externalstorage.documents/document/primary%3AAndroid%2Fdata%2Fcom.android.chrome 存储的uir字符串为:content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fdata%2Fcom.android.chrome
     * 如果你需要在Activity的onActivityResult(int requestCode, int resultCode, Intent data)中保存则使用带有Activity的方法 fragment反之
     * Params:
     * uri – 完整的请求Uri
     */
    @JvmStatic
    fun grantUriPermission(activity: Activity, uri: Uri) {
        val intent = getGrantUriPermissionIntent(uri)
        activity.startActivityForResult(intent, URI_PERMISSION_REQUEST_CODE)
    }

    fun getGrantUriPermissionIntent(path: String): Intent{
        val uri = path2Uri(path)
        return getGrantUriPermissionIntent(uri)
    }
    //获取跳转请求权限SAF页面的intent
    fun getGrantUriPermissionIntent(uri: Uri): Intent{
        Timber.d("跳转请求权限SAF页面的uri是:$uri")

        val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE).apply {
            setFlags(
                (Intent.FLAG_GRANT_READ_URI_PERMISSION
                        or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                        or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION
                        or Intent.FLAG_GRANT_PREFIX_URI_PERMISSION)
            )

            putExtra("android.provider.extra.SHOW_ADVANCED", true)
            putExtra("android.content.extra.SHOW_ADVANCED", true)
            putExtra(DocumentsContract.EXTRA_INITIAL_URI, uri)
        }
        return intent
    }
    //判断是否有权限
    @JvmStatic
    fun hasUriPermission(context: Context, path: String): Pair<String?,Uri> {
        val uri = path2Uri(path)
        Timber.d("请求权限的原始uri是:$uri")
        //请求权限的原始uri是:content://com.android.externalstorage.documents/document/primary%3AAndroid%2Fdata
        //获取需要授权uri的字符串，还不能匹配，还需要进行处理
        val reqUri = uri.toString().replaceFirst(
            URI_PERMISSION_REQUEST_DOCUMENT_PRIMARY,
            URI_PERMISSION_REQUEST_TREE_PRIMARY
        )
        Timber.d("请求权限处理后的uri(为了进行判断是否已经授权)是:$reqUri")
        //获取已授权并已存储的uri列表
        val uriPermissions = context.contentResolver.persistedUriPermissions
        Timber.d("已授权并已存储的uri列表是:$uriPermissions")
        //已经授权的uri集合是:[UriPermission {uri=content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fdata, modeFlags=3, persistedTime=1669980673302}]

        //遍历并判断请求的uri字符串是否已经被授权
        for (uriP in uriPermissions) {
            val tempUri = uriP.uri.toString()
            //如果父目录已经授权就返回已经授权
            if (reqUri.matches(("$tempUri$URI_SEPARATOR.*").toRegex()) ||
                (reqUri == tempUri && (uriP.isReadPermission || uriP.isWritePermission))
            ) {
                Timber.d("${reqUri}已经授权")
                return Pair( tempUri,uri)
            }
        }
        Timber.d("${reqUri}未授权")

        return Pair(null,uri)
    }

    // 路径转uri
    fun path2Uri(path: String, tree: Boolean = false): Uri {
        /**
         * DocumentsContract.buildTreeDocumentUri():
         * content://com.android.externalstorage.documents/tree/primary%3AAndroid%2Fdata
         * DocumentsContract.buildDocumentUri():
         * content://com.android.externalstorage.documents/document/primary%3AAndroid%2Fdata
         */

        val documentId: String = buildString {
            append(URI_PERMISSION_REQUEST_SUFFIX_SPECIAL_SYMBOL)
            append(
                path.replaceFirst(
                    Environment.getExternalStorageDirectory().absolutePath + File.separator,
                    ""
                )
            )
        }

        return if (tree) {
            DocumentsContract.buildTreeDocumentUri(URI_PERMISSION_REQUEST_PREFIX, documentId)
        } else {
            DocumentsContract.buildDocumentUri(URI_PERMISSION_REQUEST_PREFIX, documentId)
        }
    }
}