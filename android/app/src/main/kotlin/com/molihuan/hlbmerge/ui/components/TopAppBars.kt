package com.molihuan.hlbmerge.ui.components

import android.app.Activity
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.RowScope
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBackIosNew
import androidx.compose.material3.CenterAlignedTopAppBar
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBarDefaults
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.navigation.NavController
import com.molihuan.hlbmerge.LocalNavController

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BackCenterTopAppBar(
    title: String = "",
    activity: Activity? = null,
    navController: NavController? = LocalNavController.current,
    onClick: () -> Unit = {
        if (activity == null) {
            navController?.popBackStack()
        } else {
            activity.finish()
        }
    }
) {
    CenterAlignedTopAppBar(
        title = {
            Text(text = title, fontSize = 17.sp, fontWeight = FontWeight.SemiBold)
        },
        navigationIcon = {
            IconButton(onClick = onClick) {
                Icon(
                    imageVector = Icons.Default.ArrowBackIosNew,
                    contentDescription = "Back"
                )
            }
        },
        expandedHeight = 60.dp,
        colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
            containerColor = Color.White
        )
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun BackCenterTitle(
    title: String = "标题",
    activity: Activity? = null,
    navController: NavController? = LocalNavController.current,
    onClick: () -> Unit = {
        if (activity == null) {
            navController?.popBackStack()
        } else {
            activity.finish()
        }
    }
) {
    ConstraintLayout(
        modifier = Modifier
            .fillMaxWidth()
            .background(Color.White)
            .height(60.dp),
    ) {
        val (icoRef, titleRef) = createRefs()
        IconButton(onClick = onClick, modifier = Modifier.constrainAs(icoRef) {
            centerVerticallyTo(parent)
        }) {
            Icon(
                imageVector = Icons.Default.ArrowBackIosNew,
                contentDescription = "Back"
            )
        }

        Text(
            text = title,
            fontSize = 17.sp,
            fontWeight = FontWeight.SemiBold,
            modifier = Modifier.constrainAs(titleRef) {
                centerTo(parent)
            }
        )

    }

}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CenterTopAppBar(
    title: String = "标题",
    fontSize: TextUnit = 17.sp,
    actions: @Composable (RowScope.() -> Unit) = {}
) {
    CenterAlignedTopAppBar(
        title = {
            Text(text = title, fontSize = fontSize, fontWeight = FontWeight.SemiBold)
        },
        expandedHeight = 60.dp,
        actions = actions,
        colors = TopAppBarDefaults.centerAlignedTopAppBarColors(
            containerColor = Color.White
        )
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun CenterTitle(
    title: String = "标题",
) {
    ConstraintLayout(
        modifier = Modifier
            .fillMaxWidth()
            .background(Color.White)
            .height(60.dp),
    ) {
        val (titleRef) = createRefs()

        Text(
            text = title,
            fontSize = 17.sp,
            fontWeight = FontWeight.SemiBold,
            modifier = Modifier.constrainAs(titleRef) {
                centerTo(parent)
            }
        )

    }
}

@Preview
@OptIn(ExperimentalMaterial3Api::class)
@Composable
private fun Previews() {
    Column {
        BackCenterTopAppBar()
        BackCenterTitle()
        CenterTopAppBar()
        CenterTitle()
    }
}

