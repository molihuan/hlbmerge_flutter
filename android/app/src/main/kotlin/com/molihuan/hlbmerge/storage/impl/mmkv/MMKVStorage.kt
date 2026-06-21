package com.molihuan.hlbmerge.storage.impl.mmkv

import android.content.Context
import android.os.Parcelable
import com.molihuan.hlbmerge.storage.LocalStorage
import com.tencent.mmkv.MMKV
import timber.log.Timber

object MMKVStorage: LocalStorage {

    private val mmkv get() = MMKV.defaultMMKV()
    override fun init(context: Context) {
        val rootDir = MMKV.initialize(context)
        Timber.d("mmkv android init root dir: $rootDir")
    }

    override fun <T> saveValue(key: String, value: T) {

        when (value) {
            is Boolean -> mmkv.encode(key, value)
            is Int -> mmkv.encode(key, value)
            is Long -> mmkv.encode(key, value)
            is Float -> mmkv.encode(key, value)
            is Double -> mmkv.encode(key, value)
            is String? -> mmkv.encode(key, value)
            is Set<*> -> mmkv.encode(key, value as Set<String>)
            is ByteArray? -> mmkv.encode(key, value)
            is Parcelable? -> mmkv.encode(key, value)
            else -> throw IllegalArgumentException("不支持的类型: $value")
        }
    }

    override fun <T> loadValue(key: String, defaultValue: T): T {
        val result: Any? = when (defaultValue) {
            is Boolean -> mmkv.getBoolean(key, defaultValue)
            is Int -> mmkv.getInt(key, defaultValue)
            is Long -> mmkv.getLong(key, defaultValue)
            is Float -> mmkv.getFloat(key, defaultValue)
            is Double -> mmkv.getLong(key, defaultValue.toLong()).toDouble()
            is String -> mmkv.getString(key, defaultValue)
            is Set<*> -> mmkv.getStringSet(key, defaultValue as Set<String>)
            is ByteArray -> mmkv.getBytes(key, defaultValue)
            is Parcelable -> mmkv.decodeParcelable(key, defaultValue.javaClass)
            else -> throw IllegalArgumentException("不支持的类型: $defaultValue")
        }
        return result as T
    }

    override fun removeAll() {
        mmkv.clearAll()
    }

    override fun remove(key: String) {
        mmkv.removeValueForKey(key)
    }
}