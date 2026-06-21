package com.molihuan.commonmodule.tool

import android.content.Context
import android.widget.Toast
import com.molihuan.commonmodule.CommonModule
import kotlinx.coroutines.DelicateCoroutinesApi
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

object ToastTool {
    //toast
    @OptIn(DelicateCoroutinesApi::class)
    @JvmStatic
    fun toast(
        msg: String,
        duration: Int = Toast.LENGTH_SHORT,
        context: Context = CommonModule.application
    ) {
        GlobalScope.launch(Dispatchers.Main) {
            Toast.makeText(context, msg, duration).show()
        }
    }
}