package com.molihuan.hlbmerge.service.copy

interface BaseFileCopy {
    suspend fun copyFile(
        src: String,
        dest: String,
        includeRegex: String? = null,
        excludeRegex: String? = null,
        //进度回调
        progressCallback: ((current: Long, total: Long) -> Unit)? = null,
        //完成回调
        completeCallback: (() -> Unit)? = null,
        //错误回调
        errorCallback: ((e: Exception) -> Unit)? = null
    )
    suspend fun zeroCopyFile(
        src: String,
        dest: String,
        includeRegex: String? = null,
        excludeRegex: String? = null,
        //进度回调
        progressCallback: ((current: Long, total: Long) -> Unit)? = null,
        //完成回调
        completeCallback: (() -> Unit)? = null,
        //错误回调
        errorCallback: ((e: Exception) -> Unit)? = null
    )
}