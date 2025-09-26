package com.molihuan.hlbmerge.service;

interface IShizukuFileCopy {
    /**
     * @param src    源目录/文件路径
     * @param dest   目标目录/文件路径
     * @param includeRegex   包含的正则 (可为 null)
     * @param excludeRegex   排除的正则 (可为 null)
     */
    void copy(String src, String dest, String includeRegex, String excludeRegex);
    /**
     * 全部拷贝,指定规则的文件进行0数据拷贝
     * @param src    源目录/文件路径
     * @param dest   目标目录/文件路径
     * @param includeRegex   包含的正则 (可为 null)
     * @param excludeRegex   排除的正则 (可为 null)
     */
    void zeroCopy(String src, String dest, String includeRegex, String excludeRegex);
}