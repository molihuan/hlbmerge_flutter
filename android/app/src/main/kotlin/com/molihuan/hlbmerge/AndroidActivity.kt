package com.molihuan.hlbmerge

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import com.molihuan.hlbmerge.ui.screen.app.AppScreen
import com.molihuan.hlbmerge.ui.screen.app.NavRoute
import com.molihuan.hlbmerge.ui.theme.AndroidTheme
import kotlinx.serialization.json.Json

class AndroidActivity : ComponentActivity() {

    //获取Intent中携带的参数
    private val initRoute: NavRoute by lazy {
        val route = intent.getStringExtra(ROUTE_KEY)
        if (route != null) {
            Json.decodeFromString<NavRoute>(route)
        } else {
            NavRoute.PathSelect()
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
        fun go(context: Context, to: NavRoute = NavRoute.PathSelect()) {
            context.startActivity(Intent(context, AndroidActivity::class.java).apply {
                putExtra(ROUTE_KEY, Json.encodeToString(to))
            })
        }
    }

}