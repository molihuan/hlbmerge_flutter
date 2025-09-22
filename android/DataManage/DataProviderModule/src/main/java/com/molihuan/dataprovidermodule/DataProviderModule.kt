package com.molihuan.dataprovidermodule

import android.app.Application
import com.molihuan.datastoremodule.DataStoreModule

object DataProviderModule {
    lateinit var app: Application
        private set

    @JvmStatic
    fun init(app: Application) {
        this.app = app
        DataStoreModule.init(app)
    }
}