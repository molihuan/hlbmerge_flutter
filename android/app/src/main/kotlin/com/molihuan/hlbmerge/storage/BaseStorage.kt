package com.molihuan.hlbmerge.storage

import android.content.Context

interface BaseStorage {
    //初始化
    fun init(context: Context)

    //保存数据
    fun <T> saveValue(key: String, value: T)

    //加载数据
    fun <T> loadValue(key: String, defaultValue: T): T

    fun removeAll()

    fun remove(key: String)
}