package com.molihuan.hlbmerge.ui.screen.path.select

import androidx.activity.compose.LocalActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.ActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import com.molihuan.hlbmerge.NavRoute
import com.molihuan.hlbmerge.R
import com.molihuan.hlbmerge.channel.main.MainMethodChannel
import com.molihuan.hlbmerge.ui.components.BackCenterTopAppBar
import com.molihuan.hlbmerge.ui.screen.path.select.component.FolderChooserDialog
import com.molihuan.hlbmerge.ui.theme.AndroidTheme
import com.molihuan.hlbmerge.utils.ShizukuUtils
import rikka.shizuku.Shizuku
import timber.log.Timber


@Composable
fun PathSelectScreen(
    args: NavRoute.PathSelect.Args? = null,
    vm: PathSelectViewModel = viewModel()
) {
    val activity = LocalActivity.current
    val context = LocalContext.current
    val state by vm.uiState.collectAsState()

    val urlPermissionLauncher = rememberLauncherForActivityResult(
        // 使用预定义的协定，它接收 Intent 并返回 ActivityResult
        contract = ActivityResultContracts.StartActivityForResult(),
        // onResult 回调：在这里处理返回的结果
        onResult = { result: ActivityResult ->
            vm.onUrlPermissionResult(context = context, result = result)
        }
    )

    LaunchedEffect(Unit) {
        vm.init(context)
    }

    DisposableEffect(Unit) {
        // Shizuku请求权限监听
        val listener = Shizuku.OnRequestPermissionResultListener { requestCode, grantResult ->
            vm.onShizukuRequestPermissionResult(requestCode, grantResult)
        }
        Shizuku.addRequestPermissionResultListener(listener)

        onDispose {
            Shizuku.removeRequestPermissionResultListener(listener)
            Timber.d("PathSelectScreen销毁")
            MainMethodChannel.invokeMethod("onReturnFlutterPageFromNativePage", null)
        }
    }

    Scaffold(
        topBar = {
            BackCenterTopAppBar(title = "选择缓存", activity = activity)
        }
    ) { padding ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
        ) {
            when (state.functionState) {
                PathSelectFunctionState.NoReadWritePermission -> {
                    NoPermissionSection(grantPermission = {
                        vm.grantReadWritePermission(activity)
                    })
                }

                PathSelectFunctionState.HasReadWriteShizukuPermission -> {
                    HasReadWritePermissionSection(
                        hasShizukuPermission = true,
                        biliAppList = state.biliAppInfoList,
                        showPermissionTips = state.showPermissionTips,
                        readSwitchChange = { index, status ->
                            vm.changeBiliAppInfoCheck(
                                index,
                                check = status,
                                urlPermissionLauncher = urlPermissionLauncher
                            )
                        },
                        customInputPath = state.customInputPath,
                        changeCustomPathCheck = {
                            vm.changeCustomPathCheck(context = context, checked = it)
                        },
                        modifier = Modifier.verticalScroll(rememberScrollState())
                    )
                }

                else -> {
                    HasReadWritePermissionSection(
                        hasShizukuPermission = false,
                        grantShizukuPermission = {
                            ShizukuUtils.requestShizukuPermission()
                        },
                        showPermissionTips = state.showPermissionTips,
                        biliAppList = state.biliAppInfoList,
                        readSwitchChange = { index, status ->
                            vm.changeBiliAppInfoCheck(
                                index,
                                check = status,
                                urlPermissionLauncher = urlPermissionLauncher
                            )
                        },
                        customInputPath = state.customInputPath,
                        changeCustomPathCheck = {
                            vm.changeCustomPathCheck(context = context, checked = it)
                        },
                        modifier = Modifier.verticalScroll(rememberScrollState())
                    )
                }
            }
        }
    }

    //选择自定义输入路径对话框
    if (state.showSelectCustomInputDialog) {
        FolderChooserDialog(
            onDirPathSelected = {
                vm.onCustomInputDirPathSelected(context = context, path = it)
            },
            onDismiss = {
                vm.changeShowSelectCustomInputDialog(false)
            }
        )
    }

}


@Composable
private fun HasReadWritePermissionSection(
    biliAppList: List<BiliAppInfo> = listOf(
        BiliAppInfo(
            "哔哩哔哩",
            "tv.danmaku.bili",
            R.mipmap.ico_bilibili
        )
    ),
    readSwitchChange: (index: Int, status: Boolean) -> Unit = { _, _ -> },
    hasShizukuPermission: Boolean = false,
    grantShizukuPermission: () -> Unit = {},
    showPermissionTips: Boolean = true,
    //自定义输入路径
    customInputPath: String? = null,
    changeCustomPathCheck: (status: Boolean) -> Unit = {},
    modifier: Modifier = Modifier,
) {
    Box(modifier) {
        Column(
            modifier = Modifier
                .fillMaxSize()
        ) {
            if (showPermissionTips) {
                PermissionTipsSection(
                    hasShizukuPermission = hasShizukuPermission,
                    grantShizukuPermission = grantShizukuPermission
                )
            }

            Row(
                horizontalArrangement = Arrangement.SpaceBetween,
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 10.dp, vertical = 10.dp)
            ) {
                Text("Bilibili版本", fontSize = 16.sp, fontWeight = FontWeight.SemiBold)
                Text(
                    "是否读取",
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold,
                    modifier = Modifier.clickable {
                    })
            }

            //biliApp列表
            biliAppList.forEachIndexed { index, info ->
                AppInfoItem(info = info, switchCheckedChange = {
                    readSwitchChange(index, it)
                })
            }

            //自定义路径
            CustomInputPathSection(
                checked = !customInputPath.isNullOrBlank(),
                path = customInputPath,
                switchCheckedChange = {
                    changeCustomPathCheck(it)
                }
            )


        }
    }
}

//自定义路径
@Composable
private fun CustomInputPathSection(
    //是否启用
    checked: Boolean = false,
    //自定义路径
    path: String? = "Android/data",
    switchCheckedChange: (status: Boolean) -> Unit = {},
    modifier: Modifier = Modifier
) {
    Box(modifier) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier
                .padding(5.dp)
                .clip(RoundedCornerShape(5.dp))
                .fillMaxWidth()
                .background(Color.Blue.copy(alpha = if (checked) 0.1f else 0.05f))
                .padding(10.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.alpha(if (checked) 1f else 0.4f)
            ) {

                Column(
                    verticalArrangement = Arrangement.SpaceAround,
                    modifier = Modifier
                        .padding(start = 10.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "自定义路径:",
                            fontSize = 15.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                    }

                    if (!path.isNullOrBlank()) {
                        Text(
                            text = path,
                            fontSize = 12.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                    }
                }
            }

            Switch(checked = checked, onCheckedChange = {
                switchCheckedChange(it)
            })

        }
    }
}


@Composable
private fun AppInfoItem(
    info: BiliAppInfo = BiliAppInfo(
        "哔哩哔哩",
        "tv.danmaku.bili",
        R.mipmap.ico_bilibili
    ),
    switchCheckedChange: (status: Boolean) -> Unit = {},
    modifier: Modifier = Modifier
) {
    Box(modifier) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween,
            modifier = Modifier
                .alpha(if (info.isInstall) 1f else 0.5f)
                .padding(5.dp)
                .clip(RoundedCornerShape(5.dp))
                .fillMaxWidth()
                .background(Color.Blue.copy(alpha = 0.1f))
                .padding(10.dp)
        ) {
            Row(
                verticalAlignment = Alignment.CenterVertically,
            ) {

                info.icon?.let {
                    Image(
                        painter = painterResource(id = info.icon),
                        contentDescription = null,
                        modifier = Modifier.size(50.dp)
                    )
                }

                Column(
                    verticalArrangement = Arrangement.SpaceAround,
                    modifier = Modifier
                        .padding(start = 10.dp)
                ) {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = info.name,
                            fontSize = 15.sp,
                            fontWeight = FontWeight.SemiBold
                        )
                        if (!info.isInstall) {
                            Text(
                                text = "未安装",
                                fontSize = 15.sp,
                                color = Color.Red,
                                modifier = Modifier.padding(start = 10.dp)
                            )
                        }
                    }
                    Text(text = info.packageName, fontSize = 12.sp)
                }
            }

            if (info.isInstall) {
                Switch(checked = info.check, onCheckedChange = {
                    switchCheckedChange(it)
                })
            } else {
                Switch(checked = false, onCheckedChange = null)
            }

        }
    }
}

@Composable
private fun NoPermissionSection(
    grantPermission: () -> Unit = {}
) {
    Box(modifier = Modifier.fillMaxSize()) {
        Button(onClick = grantPermission, modifier = Modifier.align(Alignment.Center)) {
            Text(text = "授予读写权限")
        }
    }
}

//权限tips部分
@Composable
private fun PermissionTipsSection(
    //是否有Shizuku授权
    hasShizukuPermission: Boolean = false,
    //申请Shizuku授权
    grantShizukuPermission: () -> Unit = {},
    modifier: Modifier = Modifier
) {
    Box(modifier) {
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            modifier = modifier
                .padding(vertical = 10.dp, horizontal = 5.dp)
                .fillMaxWidth()
                .clip(RoundedCornerShape(8.dp))
                .background(Color.Gray.copy(alpha = 0.1f))
                .padding(vertical = 15.dp, horizontal = 15.dp)
        ) {
            Text(text = "提示:由于安卓高版本系统限制,安卓11及以上需要通过以下任意一种方法授予权限才可读取缓存文件:")
            Text("1、通过DocumentUri授权,点击下方对应Bilibili版本后的读取开关即可开始授权(本地必须要有缓存文件),适用于安卓11~安卓13,如果无法授权请使用其他方式。")
            Text("2、使用文件管理器将B站本地缓存文件移动出Android/data目录,然后选择\"自定义路径\"，弹窗中选择你移动出来的文件路径即可。")
            Text(
                "3、通过Shizuku授权,适用于安卓11及以上系统,点击下方按钮即可开始授权,授权后打开对应Bilibili版本读取开关即可(注意:使用Shizuku授权方式导出缓存文件的方式极其不稳定,很有可能失败,建议将Shizuku软件以小窗的形式保持在前台运行,这样的成功率高)。",
                modifier = Modifier.padding(bottom = 8.dp)
            )
            if (hasShizukuPermission) {
                Text(
                    "Shizuku已授权",
                    color = Color.Green.copy(green = 0.5f),
                    fontWeight = FontWeight.SemiBold
                )
            } else {
                Button(onClick = grantShizukuPermission) { Text("Shizuku授权") }
            }
        }
    }
}

@Preview
@Composable
private fun PathSelectScreenPreview() {
    AndroidTheme {
        PathSelectScreen()
    }
}