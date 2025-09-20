package com.molihuan.commonmodule.tool

import android.content.Context
import android.widget.Toast
import com.molihuan.commonmodule.CommonModule

object ToastTool {
    //toast
    @JvmStatic
    fun toast(
        msg: String,
        duration: Int = Toast.LENGTH_SHORT,
        context: Context = CommonModule.application
    ) {
        Toast.makeText(context, msg, duration).show()
    }
}