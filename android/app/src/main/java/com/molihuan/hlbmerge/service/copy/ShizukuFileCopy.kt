package com.molihuan.hlbmerge.service.copy

import android.content.ComponentName
import android.content.ServiceConnection
import android.os.IBinder
import com.molihuan.hlbmerge.BuildConfig
import com.molihuan.hlbmerge.service.IShizukuFileCopy
import com.molihuan.hlbmerge.service.IShizukuFileCopyCallback
import kotlinx.coroutines.TimeoutCancellationException
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.withTimeout
import rikka.shizuku.Shizuku

class ShizukuFileCopy : BaseFileCopy {

    private var mChannel = Channel<IShizukuFileCopy>()
    private var fileCopyService: IShizukuFileCopy? = null

    private val userServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(
            name: ComponentName?,
            binder: IBinder?
        ) {
            if (binder != null && binder.pingBinder()) {
                val service = IShizukuFileCopy.Stub.asInterface(binder)
                fileCopyService = service
                mChannel.trySend(service)
            }
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            fileCopyService = null
        }

    }

    private val userServiceArgs = Shizuku
        //被绑定的进程会在Shizuku权限下运行
        .UserServiceArgs(
            ComponentName(
                BuildConfig.APPLICATION_ID,
                ShizukuFileCopyUserService::class.java.name
            )
        )
        .daemon(false)
        .processNameSuffix(ShizukuFileCopy::class.java.simpleName)
        .debuggable(BuildConfig.DEBUG)
        .version(BuildConfig.VERSION_CODE)

    private fun bindService() {
        try {
            Shizuku.bindUserService(userServiceArgs, userServiceConnection)
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

    @Throws(TimeoutCancellationException::class)
    suspend fun getService(): IShizukuFileCopy {
        fileCopyService?.let { return it }
        bindService()
        return withTimeout(8000) {
            mChannel.receive()
        }
    }

    //解绑
    fun unbindService() {
        try {
            fileCopyService = null
            Shizuku.unbindUserService(userServiceArgs, userServiceConnection, true)
        } catch (e: Throwable) {
            e.printStackTrace()
        }
    }

    override suspend fun copyFile(
        src: String,
        dest: String,
        includeRegex: String?,
        excludeRegex: String?,
        progressCallback: ((current: Long, total: Long) -> Unit)?,
        completeCallback: (() -> Unit)?,
        errorCallback: ((e: Exception) -> Unit)?
    ) {
        runCatching {
            val service = getService()
            service.copy(
                src,
                dest,
                includeRegex,
                excludeRegex,
                object : IShizukuFileCopyCallback.Stub() {
                    override fun onProgress(current: Long, total: Long) {
                        progressCallback?.invoke(current, total)
                    }

                    override fun onComplete() {
                        completeCallback?.invoke()
                    }

                    override fun onError(message: String?) {
                        errorCallback?.invoke(Exception(message))
                    }
                })
        }.onFailure {
            errorCallback?.invoke(Exception(it.message))
        }
    }

    override suspend fun zeroCopyFile(
        src: String,
        dest: String,
        includeRegex: String?,
        excludeRegex: String?,
        progressCallback: ((current: Long, total: Long) -> Unit)?,
        completeCallback: (() -> Unit)?,
        errorCallback: ((e: Exception) -> Unit)?
    ) {
        runCatching {
            val service = getService()
            service.zeroCopy(
                src,
                dest,
                includeRegex,
                excludeRegex,
                object : IShizukuFileCopyCallback.Stub() {
                    override fun onProgress(current: Long, total: Long) {
                        progressCallback?.invoke(current, total)
                    }

                    override fun onComplete() {
                        completeCallback?.invoke()
                    }

                    override fun onError(message: String?) {
                        errorCallback?.invoke(Exception(message))
                    }
                })
        }.onFailure {
            errorCallback?.invoke(Exception(it.message))
        }
    }
}