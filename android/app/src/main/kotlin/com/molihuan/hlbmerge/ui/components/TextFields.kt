package com.molihuan.hlbmerge.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.calculateEndPadding
import androidx.compose.foundation.layout.calculateStartPadding
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntSize
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstrainScope
import androidx.constraintlayout.compose.ConstraintLayout

enum class ComTextFieldViewShowType {
    //有焦点时显示
    FocusShow,

    //无焦点时显示
    UnFocusShow,

    //有焦点时、无焦点时都显示
    ShowWhetherOrNotFocus
}

@Composable
fun ComTextField(
    value: String,
    onValueChange: (String) -> Unit,
    //有焦点边框颜色
    focusBorderColor: Color = Color.Blue,
    //无焦点边框颜色
    unfocusBorderColor: Color = Color.Transparent,
    //边框宽度
    borderWidth: Dp = 0.5.dp,
    //边框圆角
    borderShape: Shape = RoundedCornerShape(2.dp),
    textFieldPadding: PaddingValues = PaddingValues(0.dp),
    textStyle: TextStyle = TextStyle(
        fontSize = 16.sp
    ),
    textFieldModifier: Modifier = Modifier,
    modifier: Modifier = Modifier,
    placeholder: @Composable (() -> Unit) = {
        //Text(text = "请输入")
    },
    //总是显示placeholder
    alwaysShowPlaceholder: Boolean = false,
    suffixView: @Composable (() -> Unit) = {},
    suffixViewShowType: ComTextFieldViewShowType = ComTextFieldViewShowType.FocusShow,
    suffixViewConstraint: ConstrainScope.() -> Unit = {
        centerVerticallyTo(parent)
        end.linkTo(parent.end)
    },
    prefixView: @Composable (() -> Unit) = {},
    prefixViewShowType: ComTextFieldViewShowType = ComTextFieldViewShowType.ShowWhetherOrNotFocus,
    prefixViewConstraint: ConstrainScope.() -> Unit = {
        centerVerticallyTo(parent)
        start.linkTo(parent.start)
    },
) {
    var isFocused by remember { mutableStateOf(false) }

//    val borderColor = if (isFocused) focusBorderColor else unfocusBorderColor
    val borderColor by remember {
        derivedStateOf {
            if (isFocused) focusBorderColor else unfocusBorderColor
        }
    }

    var textFieldHeight by remember {
        mutableStateOf(0)
    }

    var suffixViewSize by remember { mutableStateOf(IntSize.Zero) }

    val showSuffixView by remember {
        derivedStateOf {
            when (suffixViewShowType) {
                ComTextFieldViewShowType.FocusShow -> {
                    isFocused
                }

                ComTextFieldViewShowType.UnFocusShow -> {
                    !isFocused
                }

                ComTextFieldViewShowType.ShowWhetherOrNotFocus -> {
                    true
                }
            }
        }
    }

    var prefixViewSize by remember { mutableStateOf(IntSize.Zero) }
    val showPrefixView by remember {
        derivedStateOf {
            when (prefixViewShowType) {
                ComTextFieldViewShowType.FocusShow -> {
                    isFocused
                }

                ComTextFieldViewShowType.UnFocusShow -> {
                    !isFocused
                }

                ComTextFieldViewShowType.ShowWhetherOrNotFocus -> {
                    true
                }
            }
        }
    }

    val density = LocalDensity.current
    val direction = LocalLayoutDirection.current

    ConstraintLayout(modifier = modifier) {
        val (refTextField, refSuffixView, refPrefixView) = createRefs()

        BasicTextField(
            value = value,
            onValueChange = onValueChange,
            textStyle = textStyle,
            modifier = Modifier
                .border(width = borderWidth, color = borderColor, shape = borderShape)
                .padding(textFieldPadding.let {
                    val tempPadding = if (suffixViewSize.width > 0 || prefixViewSize.width > 0) {
                        PaddingValues(
                            start = it.calculateStartPadding(direction) + with(density) {
                                prefixViewSize.width.toDp()
                            },
                            end = it.calculateEndPadding(direction) + with(density) {
                                suffixViewSize.width.toDp()
                            },
                            top = it.calculateTopPadding(),
                            bottom = it.calculateBottomPadding()
                        )
                    } else {
                        null
                    }
                    tempPadding ?: it
                })
                .onGloballyPositioned {
                    textFieldHeight = it.size.height
                }
                .onFocusChanged { focusState ->
                    isFocused = focusState.isFocused
                }
                .constrainAs(refTextField) {

                }
                .then(textFieldModifier)
        )

        if (showPrefixView) {
            Box(
                modifier = Modifier
                    .wrapContentSize()
                    .onGloballyPositioned {
                        prefixViewSize = it.size
                    }
                    .constrainAs(refPrefixView) {
                        prefixViewConstraint()
                    }
            ) {
                prefixView()
            }
        } else {
            prefixViewSize = IntSize.Zero
        }

        if (showSuffixView) {
            Box(
                contentAlignment = Alignment.Center,
                modifier = Modifier
                    .wrapContentSize()
                    .onGloballyPositioned {
                        suffixViewSize = it.size
                    }
                    .height(with(density) { (textFieldHeight - 2).toDp() })
                    .constrainAs(refSuffixView) {
                        suffixViewConstraint()
                    }
            ) {
                suffixView()
            }
        } else {
            suffixViewSize = IntSize.Zero
        }

        if ((isFocused || alwaysShowPlaceholder) &&
            value.isEmpty()
        ) {

            Box(
                modifier = Modifier
                    .padding(textFieldPadding.let {
                        val tempPadding =
                            if (suffixViewSize.width > 0 || prefixViewSize.width > 0) {
                                PaddingValues(
                                    start = it.calculateStartPadding(direction) + with(density) {
                                        prefixViewSize.width.toDp()
                                    },
                                    end = it.calculateEndPadding(direction) + with(density) {
                                        suffixViewSize.width.toDp()
                                    },
                                    top = it.calculateTopPadding(),
                                    bottom = it.calculateBottomPadding()
                                )
                            } else {
                                null
                            }
                        tempPadding ?: it
                    })
            ) {
                placeholder()
            }

        }


    }
}

@Composable
@Preview
private fun TextFieldPreview() {
    Column(modifier = Modifier.background(Color.White)) {
        ComTextField(value = "", onValueChange = {})
    }
}