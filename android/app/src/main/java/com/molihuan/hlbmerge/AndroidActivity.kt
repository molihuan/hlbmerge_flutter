package com.molihuan.hlbmerge

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.BackHandler
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.tooling.preview.Preview
import androidx.navigation.NavController
import androidx.navigation.NavType
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import com.molihuan.hlbmerge.ui.screen.path.select.PathSelectScreen
import com.molihuan.hlbmerge.ui.theme.AndroidTheme
import dagger.hilt.android.AndroidEntryPoint
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import timber.log.Timber

@AndroidEntryPoint
class AndroidActivity : ComponentActivity() {

    //获取Intent中携带的参数
    private val initRoute: NavRoute by lazy {
        val route = intent.getStringExtra(ROUTE_KEY)
        if (route != null) {
            Json.decodeFromString<NavRoute>(route)
        } else {
            NavRoute.PathSelect(NavRoute.PathSelect.Args())
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            AndroidTheme {
                AppScreen(initRoute)
            }
        }
    }

    companion object {
        const val ROUTE_KEY = "route"
        fun go(context: Context, to: NavRoute = NavRoute.PathSelect(NavRoute.PathSelect.Args())) {
            context.startActivity(Intent(context, AndroidActivity::class.java).apply {
                putExtra(ROUTE_KEY, Json.encodeToString(to))
            })
        }
    }

}

// 创建LocalNavController,用于快速跳转
val LocalNavController = staticCompositionLocalOf<NavController?> { null }
@Composable
fun AppScreen(initRoute: NavRoute = NavRoute.PathSelect(NavRoute.PathSelect.Args())) {
    val navController = rememberNavController()
    CompositionLocalProvider(
        LocalNavController provides navController,
    ) {
        NavHost(
            navController,
            startDestination = initRoute.route,
        ) {
            composable(
                route = NavRoute.PathSelect.routeWithArgs,
                arguments = listOf(
                    navArgument(NavRoute.PathSelect.argsKey) {
                        type = NavType.StringType
                    },
                )
            ) {
                val argsJson =
                    it.arguments?.getString(NavRoute.PathSelect.argsKey)
                val args = argsJson?.let {
                    Json.decodeFromString<NavRoute.PathSelect.Args>(
                        Uri.decode(it)
                    )
                }
                PathSelectScreen(args = args)
            }

        }

    }
}

@Serializable
sealed class NavRoute(val route: String, val title: String? = null) {

    @Serializable
    data class PathSelect(val args: Args) :
        NavRoute("PathSelect/${Uri.encode(Json.encodeToString(args))}") {
        @Serializable
        data class Args(val from: NavRoute? = null)
        companion object {
            const val argsKey = "args"
            const val routeWithArgs = "PathSelect/{${argsKey}}"
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun AppScreenPreview() {
    AndroidTheme {
        AppScreen()
    }
}