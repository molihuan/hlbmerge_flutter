package com.molihuan.hlbmerge.ui.components

import androidx.compose.foundation.layout.width
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.TextUnit

@Composable
fun FixedCharWidthText(
    text: String,
    fontSize: TextUnit,
    charCount: Int = 4,
    modifier: Modifier = Modifier,
    textAlign: TextAlign = TextAlign.Center
) {
    val density = LocalDensity.current
    // 计算指定字符数对应的宽度
    val widthInDp = with(density) { fontSize.toDp() * charCount }

    Text(
        text = text,
        fontSize = fontSize,
        textAlign = textAlign,
        modifier = modifier.width(widthInDp)
    )
}