package com.molihuan.datastoremodule

import android.app.Application

object DataStoreModule {
    lateinit var app: Application
        private set

    @JvmStatic
    fun init(app: Application) {
        this.app = app
    }
}