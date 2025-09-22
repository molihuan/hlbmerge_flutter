package com.molihuan.datastoremodule

import android.content.Context
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.floatPreferencesKey
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.longPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.core.stringSetPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.map
import kotlinx.serialization.json.Json

object PreferencesDataStoreUtil {
    private const val DATASTORE_NAME = "app_preferences"
    private val Context.dataStore by preferencesDataStore(name = DATASTORE_NAME)

    // ---------------- 写入 ----------------
    @JvmStatic
    @JvmOverloads
    suspend fun putBoolean(
        key: String, value: Boolean,
        context: Context = DataStoreModule.app
    ) {
        context.dataStore.edit { it[booleanPreferencesKey(key)] = value }
    }

    @JvmStatic
    @JvmOverloads
    suspend fun putInt(
        key: String, value: Int,
        context: Context = DataStoreModule.app
    ) {
        context.dataStore.edit { it[intPreferencesKey(key)] = value }
    }

    @JvmStatic
    @JvmOverloads
    suspend fun putLong(
        key: String, value: Long,
        context: Context = DataStoreModule.app
    ) {
        context.dataStore.edit { it[longPreferencesKey(key)] = value }
    }

    @JvmStatic
    @JvmOverloads
    suspend fun putFloat(
        key: String, value: Float,
        context: Context = DataStoreModule.app
    ) {
        context.dataStore.edit { it[floatPreferencesKey(key)] = value }
    }

    @JvmStatic
    @JvmOverloads
    suspend fun putDouble(
        key: String, value: Double,
        context: Context = DataStoreModule.app
    ) {
        context.dataStore.edit { it[stringPreferencesKey(key)] = value.toString() }
    }

    @JvmStatic
    @JvmOverloads
    suspend fun putString(
        key: String, value: String,
        context: Context = DataStoreModule.app
    ) {
        context.dataStore.edit { it[stringPreferencesKey(key)] = value }
    }

    @JvmStatic
    @JvmOverloads
    // 写入 List<String>（JSON 序列化）
    suspend fun putStringListByJson(
        key: String,
        list: List<String>,
        context: Context = DataStoreModule.app
    ) {
        val json = Json.encodeToString(list)
        context.dataStore.edit { it[stringPreferencesKey(key)] = json }
    }

    @JvmStatic
    @JvmOverloads
    // 写入
    suspend fun putStringList(
        key: String, list: List<String>,
        context: Context = DataStoreModule.app
    ) {
        val dataKey = stringSetPreferencesKey(key)
        context.dataStore.edit { it[dataKey] = list.toSet() }
    }

    @JvmStatic
    @JvmOverloads
    // ---------------- 读取 ----------------
    fun getBoolean(
        key: String,
        default: Boolean = false,
        context: Context = DataStoreModule.app
    ): Flow<Boolean> {
        return context.dataStore.data.map { it[booleanPreferencesKey(key)] ?: default }
    }

    @JvmStatic
    @JvmOverloads
    fun getInt(
        key: String, default: Int = 0,
        context: Context = DataStoreModule.app
    ): Flow<Int> {
        return context.dataStore.data.map { it[intPreferencesKey(key)] ?: default }
    }

    @JvmStatic
    @JvmOverloads
    fun getLong(
        key: String,
        default: Long = 0L,
        context: Context = DataStoreModule.app
    ): Flow<Long> {
        return context.dataStore.data.map { it[longPreferencesKey(key)] ?: default }
    }

    @JvmStatic
    @JvmOverloads
    fun getFloat(
        key: String,
        default: Float = 0f,
        context: Context = DataStoreModule.app
    ): Flow<Float> {
        return context.dataStore.data.map { it[floatPreferencesKey(key)] ?: default }
    }

    @JvmStatic
    @JvmOverloads
    fun getDouble(
        key: String,
        default: Double = 0.0,
        context: Context = DataStoreModule.app
    ): Flow<Double> {
        return context.dataStore.data.map {
            it[stringPreferencesKey(key)]?.toDoubleOrNull() ?: default
        }
    }

    @JvmStatic
    @JvmOverloads
    fun getString(
        key: String,
        default: String = "",
        context: Context = DataStoreModule.app
    ): Flow<String> {
        return context.dataStore.data.map { it[stringPreferencesKey(key)] ?: default }
    }

    @JvmStatic
    @JvmOverloads
    // 读取 List<String>（JSON 反序列化）
    fun getStringListByJson(
        key: String,
        context: Context = DataStoreModule.app
    ): Flow<List<String>> {
        return context.dataStore.data.map {
            it[stringPreferencesKey(key)]?.let { json ->
                try {
                    Json.decodeFromString<List<String>>(json)
                } catch (e: Exception) {
                    emptyList()
                }
            } ?: emptyList()
        }
    }

    @JvmStatic
    @JvmOverloads
    // 读取
    fun getStringList(
        key: String,
        context: Context = DataStoreModule.app
    ): Flow<List<String>> {
        val dataKey = stringSetPreferencesKey(key)
        return context.dataStore.data.map { it[dataKey]?.toList() ?: emptyList() }
    }

    @JvmStatic
    @JvmOverloads
    // ---------------- 其他操作 ----------------
    suspend fun remove(
        key: String,
        context: Context = DataStoreModule.app
    ) {
        context.dataStore.edit { it.remove(stringPreferencesKey(key)) }
    }

    @JvmStatic
    @JvmOverloads
    suspend fun clear(context: Context = DataStoreModule.app) {
        context.dataStore.edit { it.clear() }
    }
}