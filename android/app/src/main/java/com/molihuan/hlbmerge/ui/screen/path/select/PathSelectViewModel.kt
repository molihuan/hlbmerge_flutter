package com.molihuan.hlbmerge.ui.screen.path.select

import android.app.Activity
import android.content.Context
import androidx.lifecycle.ViewModel
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.XXPermissions
import com.hjq.permissions.permission.PermissionLists
import com.hjq.permissions.permission.base.IPermission
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import javax.inject.Inject

@HiltViewModel
class PathSelectViewModel@Inject constructor() : ViewModel() {
    private val _uiState = MutableStateFlow(PathSelectUiState())
    val uiState = _uiState.asStateFlow()

    fun init(context: Context){
        val grantedPermission = XXPermissions.isGrantedPermission(
            context,
            PermissionLists.getManageExternalStoragePermission()
        )
        if (grantedPermission) {
            updateFunctionState(PathSelectFunctionState.HasPermission)
        } else {
            updateFunctionState(PathSelectFunctionState.NoPermission)
        }
    }

    fun updateFunctionState(functionState: PathSelectFunctionState) {
        _uiState.update {
            it.copy(functionState = functionState)
        }
    }

    fun grantReadWritePermission(activity: Activity?){
        if (activity == null) {
            return
        }
        XXPermissions.with(activity)
            .permission(PermissionLists.getManageExternalStoragePermission())
            // 设置不触发错误检测机制（局部设置）
            //.unchecked()
            .request(object : OnPermissionCallback {

                override fun onResult(grantedList: MutableList<IPermission>, deniedList: MutableList<IPermission>) {
                    val allGranted = deniedList.isEmpty()
                    if (!allGranted) {
                        // 判断请求失败的权限是否被用户勾选了不再询问的选项
                        val doNotAskAgain = XXPermissions.isDoNotAskAgainPermissions(activity, deniedList)
                        // 在这里处理权限请求失败的逻辑
                        return
                    }
                    // 在这里处理权限请求成功的逻辑
                    updateFunctionState(PathSelectFunctionState.HasPermission)
                }
            })
    }
}

data class PathSelectUiState(
    val functionState: PathSelectFunctionState = PathSelectFunctionState.NoPermission,
)

sealed class PathSelectFunctionState{
    //无权限
    object NoPermission: PathSelectFunctionState()
    //已授予权限
    object HasPermission: PathSelectFunctionState()
}