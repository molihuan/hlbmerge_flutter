package com.molihuan.hlbmerge.ui.screen.app

import androidx.navigation3.runtime.NavKey
import kotlinx.serialization.Serializable

@Serializable
sealed class NavRoute(
    val routeName: String? = null
) : NavKey {
    @Serializable
    data class PathSelect(
        val from: NavRoute? = null
    ) : NavRoute(routeName = "PathSelect")

}