package com.molihuan.hlbmerge.dao.flutter

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit

object FlutterSpUtils {


    private var sharedPreferences: SharedPreferences? = null

    /**
     * [必须] 在 Application 的 onCreate 方法中调用此方法进行初始化。
     *
     * @param context 建议传入 ApplicationContext，以防止内存泄漏。
     */
    fun init(context: Application, name: String) {
        sharedPreferences = context.getSharedPreferences(name, Context.MODE_PRIVATE)
    }

    /**
     * 获取 SharedPreferences 实例，如果未初始化则抛出异常。
     */
    private val prefs: SharedPreferences
        get() = sharedPreferences ?: throw IllegalStateException(
            "PrefUtils must be initialized in your Application class's onCreate method."
        )

    /**
     * 保存字符串
     * @param key 键
     * @param value 值
     */
    fun putString(key: String, value: String?) {
        prefs.edit { putString(key, value) }
    }

    /**
     * 读取字符串
     * @param key 键
     * @param defaultValue 默认值，默认为 null
     * @return 键对应的值，如果不存在则返回默认值
     */
    fun getString(key: String, defaultValue: String? = null): String? {
        return prefs.getString(key, defaultValue)
    }

    /**
     * 保存整型
     */
    fun putInt(key: String, value: Int) {
        prefs.edit { putInt(key, value) }
    }

    /**
     * 读取整型
     */
    fun getInt(key: String, defaultValue: Int = 0): Int {
        return prefs.getInt(key, defaultValue)
    }

    /**
     * 保存布尔值
     */
    fun putBoolean(key: String, value: Boolean) {
        prefs.edit { putBoolean(key, value) }
    }

    /**
     * 读取布尔值
     */
    fun getBoolean(key: String, defaultValue: Boolean = false): Boolean {
        return prefs.getBoolean(key, defaultValue)
    }

    /**
     * 保存长整型
     */
    fun putLong(key: String, value: Long) {
        prefs.edit { putLong(key, value) }
    }

    /**
     * 读取长整型
     */
    fun getLong(key: String, defaultValue: Long = 0L): Long {
        return prefs.getLong(key, defaultValue)
    }

    /**
     * 保存浮点型
     */
    fun putFloat(key: String, value: Float) {
        prefs.edit { putFloat(key, value) }
    }

    /**
     * 读取浮点型
     */
    fun getFloat(key: String, defaultValue: Float = 0f): Float {
        return prefs.getFloat(key, defaultValue)
    }

    /**
     * 移除指定的键值对
     * @param key 要移除的键
     */
    fun remove(key: String) {
        prefs.edit { remove(key) }
    }

    /**
     * 清除所有数据
     */
    fun clear() {
        prefs.edit { clear() }
    }

    /**
     * 检查是否包含指定的键
     * @param key 要检查的键
     * @return 如果存在则返回 true，否则返回 false
     */
    fun contains(key: String): Boolean {
        return prefs.contains(key)
    }
}