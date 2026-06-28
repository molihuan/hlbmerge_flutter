package com.molihuan.hlbmerge.ui.screen.app

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.lifecycle.viewmodel.navigation3.rememberViewModelStoreNavEntryDecorator
import androidx.navigation3.runtime.NavBackStack
import androidx.navigation3.runtime.NavEntry
import androidx.navigation3.runtime.NavKey
import androidx.navigation3.runtime.rememberNavBackStack
import androidx.navigation3.runtime.rememberSaveableStateHolderNavEntryDecorator
import androidx.navigation3.ui.NavDisplay
import com.molihuan.hlbmerge.ui.screen.path.select.PathSelectScreen
import com.molihuan.hlbmerge.ui.theme.AndroidTheme

// 创建 LocalNavBackStack,方便跳转
val LocalNavBackStack = staticCompositionLocalOf<NavBackStack<NavKey>?> { null }

@Composable
fun AppScreen(
    startDestination: NavRoute,
) {
    val backStack = rememberNavBackStack(startDestination)
    CompositionLocalProvider(
        LocalNavBackStack provides backStack
    ) {
        NavDisplay(
            backStack = backStack,
            onBack = { backStack.removeLastOrNull() },
            entryDecorators = listOf(
                rememberSaveableStateHolderNavEntryDecorator(),
                rememberViewModelStoreNavEntryDecorator(),
            ),
            entryProvider = { key ->
                when (key) {
                    is NavRoute.PathSelect -> {
                        NavEntry(key) {
                            PathSelectScreen()
                        }
                    }

                    else -> {
                        NavEntry(key) {
                            Box(Modifier.fillMaxSize()) {
                                Text("路由错误", modifier = Modifier.align(Alignment.Center))
                            }
                        }
                    }
                }

            }
        )
    }
}

@Preview(showBackground = true)
@Composable
private fun AppScreenPreview() {
    AndroidTheme {
        AppScreen(startDestination = NavRoute.PathSelect())
    }
}