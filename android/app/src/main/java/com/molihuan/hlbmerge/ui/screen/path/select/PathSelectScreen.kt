package com.molihuan.hlbmerge.ui.screen.path.select

import androidx.activity.compose.LocalActivity
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.viewmodel.compose.viewModel
import com.molihuan.hlbmerge.NavRoute
import com.molihuan.hlbmerge.ui.components.BackCenterTopAppBar
import com.molihuan.hlbmerge.ui.theme.AndroidTheme

@Composable
fun PathSelectScreen(
    args: NavRoute.PathSelect.Args? = null,
    vm: PathSelectViewModel = viewModel()
) {
    val activity = LocalActivity.current
    val context = LocalContext.current
    val state by vm.uiState.collectAsState()

    vm.init(context)

    Scaffold(
        topBar = {
            BackCenterTopAppBar(title = "选择缓存路径", activity = activity)
        }
    ) { padding ->
        when (state.functionState) {
            PathSelectFunctionState.HasPermission -> {
                Column(
                    modifier = Modifier
                        .padding(padding)
                        .fillMaxSize()
                ) {

                }
            }

            PathSelectFunctionState.NoPermission -> {
                NoPermissionSection(grantPermission = {
                    vm.grantReadWritePermission(activity)
                })
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

@Preview(showBackground = true)
@Composable
private fun PathSelectScreenPreview() {
    AndroidTheme {
        PathSelectScreen()
    }
}