package com.molihuan.hlbmerge.service;

interface IShizukuFileCopy {
    /**
     * @param src    源目录/文件路径
     * @param dest   目标目录/文件路径
     * @param includeRegex   包含的正则 (可为 null)
     * @param excludeRegex   排除的正则 (可为 null)
     */
    void copy(String src, String dest, String includeRegex, String excludeRegex);
}