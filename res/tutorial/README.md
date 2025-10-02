## Android教程

1. Android 10及以下直接授予"文件读取权限"后选择选择需要读取的bilibili版本即可使用

2. Android 11~13除了授予"文件读取权限"之外，还需下方三种任意一种方可使用:

   - 通过DocumentUri授权,点击对应Bilibili版本后的读取开关即可开始授权(本地必须要有缓存文件),适用于Android 11~13,如果无法授权请使用其他方法。

   - 通过Shizuku授权,适用于Android 11及以上系统,点击"Shizuku授权"按钮即可开始授权,授权后打开对应bilibili版本读取开关即可

   - 使用其他的文件管理器将:bilibili本地缓存文件移动出Android/data目录,然后在"选择缓存"页面选择"自定义路径"，弹窗中选择你移动出来的文件路径即可

     > 关于bilibili本地缓存文件位置提示:
     >
     > 国内bilibili版本的缓存文件一般在:/storage/emulated/0/Android/data/tv.danmaku.bili/download/目录下,其他版本视具体情况而定。

3. Android14及以上,仅可使用Shizuku授权使用,详情请参考上面Android 11~13第二条