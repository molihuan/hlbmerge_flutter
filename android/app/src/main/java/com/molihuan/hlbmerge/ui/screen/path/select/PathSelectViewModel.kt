package com.molihuan.hlbmerge.ui.screen.path.select

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
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

    val isAndroid11 = AppTool.isAndroid11()
    val isAndroid14 = AppTool.isAndroid14()

    fun init(context: Context) {
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
            val isInstall = AppTool.isAppInstall(item.packageName)
            item.copy(
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
                _uiState.update {
                    it.copy(
                        showPermissionTips = isAndroid11,
                        biliAppInfoList = biliAppInfoList,
                        functionState = PathSelectFunctionState.HasReadWriteShizukuPermission
                    )
                }
            } else {
                _uiState.update {
                    it.copy(
                        showPermissionTips = isAndroid11,
                        biliAppInfoList = biliAppInfoList,
                        functionState = PathSelectFunctionState.HasReadWritePermission
                    )
                }
            }
        } else {
            _uiState.update {
                it.copy(
                    biliAppInfoList = biliAppInfoList,
                    functionState = PathSelectFunctionState.NoReadWritePermission
                )
            }
        }
    }

    fun updateFunctionState(functionState: PathSelectFunctionState) {
        _uiState.update {
            it.copy(functionState = functionState)
        }
    }

    //更新biliAppInfoList
    fun changeBiliAppInfoCheck(
        index: Int,
        check: Boolean,
        urlPermissionLauncher: ManagedActivityResultLauncher<Intent, ActivityResult>
    ) {
        val state = _uiState.value

        val appInfo = state.biliAppInfoList[index]

        run {
            when (state.functionState) {
                PathSelectFunctionState.NoReadWritePermission -> {
                    ToastTool.toast("请先授予读写权限")
                    return
                }

                PathSelectFunctionState.HasReadWritePermission -> {
                    if (!isAndroid11) {
                        //小于安卓11直接设置Android/data路径即可,可用直接读写
                        return@run
                    }

                    if (isAndroid14) {
                        //安卓14及以上必须使用Shizuku
                        ToastTool.toast("请先授予Shizuku权限")
                        return
                    }
                    val uriPath = "/storage/emulated/0/Android/data/${appInfo.packageName}/download"

                    grantUriPermission(path = uriPath, urlPermissionLauncher)
                }

                PathSelectFunctionState.HasReadWriteUriPermission -> {
                    Timber.d("Uri模式check")
                }

                PathSelectFunctionState.HasReadWriteShizukuPermission -> {
                    Timber.d("Shizuku模式check")
                }

            }
        }

        val biliAppInfoList = state.biliAppInfoList.toMutableList()
        biliAppInfoList[index] = biliAppInfoList[index].copy(check = check)
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
            viewModelScope.launch(Dispatchers.IO) {
                FlutterSpData.setInputCacheDirPath("/storage/emulated/0/Download/HLB站缓存视频合并/download")
            }
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
            _uiState.update { it.copy(functionState = PathSelectFunctionState.HasReadWriteShizukuPermission) }
        }
    }

    fun grantUriPermission(
        path: String,
        urlPermissionLauncher: ManagedActivityResultLauncher<Intent, ActivityResult>
    ) {
        val uriPair = UriUtils.hasUriPermission(App.instance, path)
        val uriStr = uriPair.first
        if (uriStr == null) {
            val intent = UriUtils.getGrantUriPermissionIntent(uriPair.second)
            urlPermissionLauncher.launch(intent)
        }
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

sealed class PathSelectFunctionState {
    //无读写权限
    object NoReadWritePermission : PathSelectFunctionState()

    //有读写授予权限
    object HasReadWritePermission : PathSelectFunctionState()

    //有读写授予权限，并且有uri权限
    object HasReadWriteUriPermission : PathSelectFunctionState()

    //有读写授予权限，并且有shizuku权限
    object HasReadWriteShizukuPermission : PathSelectFunctionState()
}

data class BiliAppInfo(
    val name: String,
    val packageName: String,
    @DrawableRes
    val icon: Int,
    val isInstall: Boolean = false,
    val check: Boolean = false,
)