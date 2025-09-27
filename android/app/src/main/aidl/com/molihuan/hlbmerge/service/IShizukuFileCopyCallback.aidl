package com.molihuan.hlbmerge.service;

interface IShizukuFileCopyCallback {
    void onProgress(long current, long total);
    void onComplete();
    void onError(String message);
}