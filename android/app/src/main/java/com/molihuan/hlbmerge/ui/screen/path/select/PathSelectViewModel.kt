package com.molihuan.hlbmerge.ui.screen.path.select

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.activity.compose.ManagedActivityResultLauncher
import androidx.activity.result.ActivityResult
import androidx.annotation.DrawableRes
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.XXPermissions
import com.hjq.permissions.permission.PermissionLists
import com.hjq.permissions.permission.base.IPermission
import com.molihuan.commonmodule.tool.AppTool
import com.molihuan.commonmodule.tool.ToastTool
import com.molihuan.hlbmerge.App
import com.molihuan.hlbmerge.R
import com.molihuan.hlbmerge.dao.FlutterSpData
import com.molihuan.hlbmerge.service.ShizukuFileCopy
import com.molihuan.hlbmerge.utils.FileUtils
import com.molihuan.hlbmerge.utils.UriUtils
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import rikka.shizuku.Shizuku
import timber.log.Timber
import javax.inject.Inject

@HiltViewModel
class PathSelectViewModel @Inject constructor() : ViewModel() {
    private val _uiState = MutableStateFlow(PathSelectUiState())
    val uiState = _uiState.asStateFlow()

    private val REQUEST_CODE_SHIZUKU_PERMISSION = 1112

    private val isAndroid11 = AppTool.isAndroid11()
    private val isAndroid14 = AppTool.isAndroid14()

    // 当前授权Uri权限时输入的缓存目录
    private var currGrantUriPermissionInfo: Pair<String, String>? = null

    fun init(context: Context) {
        test()
        val biliAppInfoList: List<BiliAppInfo> = listOf(
            BiliAppInfo(
                "哔哩哔哩",
                "tv.danmaku.bili",
                R.mipmap.ico_bilibili
            ),
            BiliAppInfo(
                "哔哩哔哩(概念版)",
                "com.bilibili.app.blue",
                R.mipmap.ico_bilibili_blue
            ),
            BiliAppInfo(
                "哔哩哔哩(谷歌版)",
                "com.bilibili.app.in",
                R.mipmap.ico_bilibili
            ),
            BiliAppInfo(
                "哔哩哔哩(HD)",
                "tv.danmaku.bilibilihd",
                R.mipmap.ico_bilibili
            ),
        ).map { item ->
            val androidInputCachePackageName = FlutterSpData.getAndroidInputCachePackageName()
            val isInstall = AppTool.isAppInstall(item.packageName)
            item.copy(
                check = isInstall && item.packageName == androidInputCachePackageName,
                isInstall = isInstall,
            )
        }

        val grantedPermission = XXPermissions.isGrantedPermission(
            context,
            PermissionLists.getManageExternalStoragePermission()
        )
        if (grantedPermission) {
            val shizukuAvailableAndHasPermission = isShizukuAvailableAndHasPermission()
            if (shizukuAvailableAndHasPermission) {
                //有读写权限且有Shizuku权限
                _uiState.update {
                    it.copy(
                        showPermissionTips = isAndroid11,
                        biliAppInfoList = biliAppInfoList,
                        functionState = PathSelectFunctionState.HasReadWriteShizukuPermission
                    )
                }
            } else {
                //有读写权限但无Shizuku权限
                _uiState.update {
                    it.copy(
                        showPermissionTips = isAndroid11,
                        biliAppInfoList = biliAppInfoList,
                        functionState = PathSelectFunctionState.HasReadWritePermission
                    )
                }
            }
        } else {
            //没有读写权限
            _uiState.update {
                it.copy(
                    biliAppInfoList = biliAppInfoList,
                    showPermissionTips = isAndroid11,
                    functionState = PathSelectFunctionState.NoReadWritePermission
                )
            }
        }
    }

    fun updateFunctionState(functionState: PathSelectFunctionState) {
        FlutterSpData.setAndroidParseCacheDataPermission(functionState)
        _uiState.update {
            it.copy(functionState = functionState)
        }
    }

    //url权限回调结果
    fun onUrlPermissionResult(context: Context, result: ActivityResult) {
        when (result.resultCode) {
            Activity.RESULT_OK -> {
                // 从 result.data (这是一个 Intent) 中提取数据
                result.data?.let { data ->
                    val uri: Uri? = data.data
                    if (uri == null) {
                        return@let
                    }

                    val takeFlags: Int =
                        data.flags and (Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)

//                    @SuppressLint("WrongConstant")
                    context.contentResolver
                        .takePersistableUriPermission(
                            uri,
                            takeFlags
                        )
                    //
                    currGrantUriPermissionInfo?.let { permissionInfo ->
                        FlutterSpData.setInputCacheDirPath(permissionInfo.first)
                        FlutterSpData.setAndroidInputCachePackageName(permissionInfo.second)
                        FlutterSpData.setAndroidParseCacheDataPermission(PathSelectFunctionState.HasReadWritePermission)
                        val state = _uiState.value
                        val biliAppInfoList = state.biliAppInfoList.toMutableList().map {
                            if (it.packageName == permissionInfo.second) {
                                it.copy(check = true)
                            } else {
                                it.copy(check = false)
                            }
                        }
                        _uiState.update {
                            it.copy(biliAppInfoList = biliAppInfoList)
                        }
                    }
                }
            }
        }
    }


    //更新biliAppInfoCheck
    fun changeBiliAppInfoCheck(
        index: Int,
        check: Boolean,
        urlPermissionLauncher: ManagedActivityResultLauncher<Intent, ActivityResult>
    ) {

        //如果能进入这里肯定是有读写权限的
        val state = _uiState.value
        val appInfo = state.biliAppInfoList[index]

        val uriPath = "${FileUtils.androidDataPath}/${appInfo.packageName}/download"
//        val uriPath = "${FileUtils.androidDataPath}/${appInfo.packageName}/files"
        run {

            if (!check) {
                //ToastTool.toast("您已开启读取此项,无需再次开启")
                FlutterSpData.setInputCacheDirPath("")
                FlutterSpData.setAndroidInputCachePackageName("")
                FlutterSpData.setAndroidParseCacheDataPermission(PathSelectFunctionState.NoReadWritePermission)
                return@run
            }

            when (state.functionState) {
                PathSelectFunctionState.NoReadWritePermission -> {
                    ToastTool.toast("请先授予读写权限")
                    return
                }

                PathSelectFunctionState.HasReadWritePermission -> {
                    if (!isAndroid11) {
                        //小于安卓11直接设置Android/data路径即可,可用直接读写
                        FlutterSpData.setInputCacheDirPath(uriPath)
                        FlutterSpData.setAndroidInputCachePackageName(appInfo.packageName)
                        FlutterSpData.setAndroidParseCacheDataPermission(PathSelectFunctionState.HasReadWritePermission)
                        return@run
                    }

                    if (isAndroid14) {
                        //安卓14及以上必须使用Shizuku
                        ToastTool.toast("请先授予Shizuku权限")
                        return
                    }


                    //11~13授予Uri权限
                    val inputCacheDirPath = FlutterSpData.cacheCopyTempPath

                    val hasPermission =
                        grantUriPermission(path = uriPath, urlPermissionLauncher)
                    if (hasPermission) {
                        FlutterSpData.setInputCacheDirPath(inputCacheDirPath)
                        FlutterSpData.setAndroidInputCachePackageName(appInfo.packageName)
                        FlutterSpData.setAndroidParseCacheDataPermission(PathSelectFunctionState.HasReadWritePermission)
                    } else {
                        currGrantUriPermissionInfo = Pair(inputCacheDirPath, appInfo.packageName)
                        return
                    }
                }

                PathSelectFunctionState.HasReadWriteShizukuPermission -> {
                    Timber.d("Shizuku模式check")
                    FlutterSpData.setInputCacheDirPath(FlutterSpData.cacheCopyTempPath)
                    FlutterSpData.setAndroidInputCachePackageName(appInfo.packageName)
                    FlutterSpData.setAndroidParseCacheDataPermission(PathSelectFunctionState.HasReadWriteShizukuPermission)
                }

                else -> {}

            }
        }

        val biliAppInfoList = state.biliAppInfoList.toMutableList().map {
            if (it.packageName == appInfo.packageName) {
                it.copy(check = check)
            } else {
                it.copy(check = false)
            }
        }
        _uiState.update {
            it.copy(biliAppInfoList = biliAppInfoList)
        }
    }

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

    // Shizuku权限回调
    fun onShizukuRequestPermissionResult(requestCode: Int, grantResult: Int) {
        if (requestCode == REQUEST_CODE_SHIZUKU_PERMISSION) {
            if (grantResult != PackageManager.PERMISSION_GRANTED) {
                return
            }
            FlutterSpData.setInputCacheDirPath(FlutterSpData.cacheCopyTempPath)
            _uiState.update { it.copy(functionState = PathSelectFunctionState.HasReadWriteShizukuPermission) }
        }
    }

    //测试
    fun test() {
        val srcDir = "/storage/emulated/0/Android/data/tv.danmaku.bili/download"
        val targetDir = "/storage/emulated/0/Download/HLB站缓存视频合并/cacheCopyTempDir"
        viewModelScope.launch(Dispatchers.IO) {
            ShizukuFileCopy().copyFile(srcDir, targetDir)
//            ShizukuFileCopy().copyFile(srcDir, targetDir, excludeRegex = ".*\\.m4s")
        }
    }

    // 授予Uri权限,如果运行时有权限会直接返回true,运行时没有权限会返回 false,并且会自动请求权限，后续的结果请在回调中处理。
    fun grantUriPermission(
        path: String,
        urlPermissionLauncher: ManagedActivityResultLauncher<Intent, ActivityResult>
    ): Boolean {
        val uriPair = UriUtils.hasUriPermission(App.instance, path)
        val uriStr = uriPair.first
        if (uriStr == null) {
            val intent = UriUtils.getGrantUriPermissionIntent(uriPair.second)
            urlPermissionLauncher.launch(intent)
            return false
        }
        return true
    }

    fun grantReadWritePermission(activity: Activity?) {
        if (activity == null) {
            return
        }
        XXPermissions.with(activity)
            .permission(PermissionLists.getManageExternalStoragePermission())
            // 设置不触发错误检测机制（局部设置）
            //.unchecked()
            .request(object : OnPermissionCallback {

                override fun onResult(
                    grantedList: MutableList<IPermission>,
                    deniedList: MutableList<IPermission>
                ) {
                    val allGranted = deniedList.isEmpty()
                    if (!allGranted) {
                        // 判断请求失败的权限是否被用户勾选了不再询问的选项
                        val doNotAskAgain =
                            XXPermissions.isDoNotAskAgainPermissions(activity, deniedList)
                        // 在这里处理权限请求失败的逻辑
                        return
                    }
                    // 在这里处理权限请求成功的逻辑
                    updateFunctionState(PathSelectFunctionState.HasReadWritePermission)
                }
            })
    }
}

data class PathSelectUiState(
    val functionState: PathSelectFunctionState = PathSelectFunctionState.NoReadWritePermission,
    val biliAppInfoList: List<BiliAppInfo> = listOf(
        BiliAppInfo(
            "哔哩哔哩",
            "tv.danmaku.bili",
            R.mipmap.ico_bilibili
        )
    ),
    val shizukuPermissionStatus: Int = PackageManager.PERMISSION_DENIED,
    val showPermissionTips: Boolean = true,
)

sealed class PathSelectFunctionState(val title: String) {
    //无读写权限
    object NoReadWritePermission : PathSelectFunctionState("NoPermission")

    //有读写授予权限
    object HasReadWritePermission : PathSelectFunctionState("ReadWritePermission")

    //有读写授予权限，并且有uri权限
    object HasReadWriteUriPermission : PathSelectFunctionState("ReadWriteUriPermission")


    //有读写授予权限，并且有shizuku权限
    object HasReadWriteShizukuPermission : PathSelectFunctionState("ReadWriteShizukuPermission")
}

data class BiliAppInfo(
    val name: String,
    val packageName: String,
    @DrawableRes
    val icon: Int,
    val isInstall: Boolean = false,
    val check: Boolean = false,
)