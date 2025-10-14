# 注意 ! ! !

- 此软件存放的目录不能有空格或特殊字符
- 读取缓存视频的目录不能有空格或特殊字符
- 输出目录不能有空格或特殊字符
- 视频名称或标题不能有特殊字符(虽然做了兼容处理,但可能无法兼顾到所有的特殊字符)

## Android教程

1. Android 10及以下直接授予"文件读取权限"后选择选择需要读取的bilibili版本即可使用

2. Android 11~13除了授予"文件读取权限"之外，还需下方三种任意一种方可使用:

   - 通过DocumentUri授权,点击对应Bilibili版本后的读取开关即可开始授权(本地必须要有缓存文件),适用于Android 11~13,如果无法授权请使用其他方法。

   - 通过Shizuku授权,适用于Android 11及以上系统,点击"Shizuku授权"按钮即可开始授权,授权后打开对应bilibili版本读取开关即可
     ### 特别注意:使用Shizuku授权方式导出缓存文件的方式极其不稳定,很有可能失败,可以多尝试几次,我的建议是将Shizuku软件以小窗的形式保持在前台运行,这样的成功率高。
     > 关于Shizuku:
     > 
     > Shizuku官网:[https://shizuku.rikka.app/](https://shizuku.rikka.app/)
     > 
     > Shizuku开源地址:[https://github.com/RikkaApps/Shizuku](https://github.com/RikkaApps/Shizuku)

   - 使用其他的文件管理器将:bilibili本地缓存文件移动出Android/data目录,然后在"选择缓存"页面选择"自定义路径"，弹窗中选择你移动出来的文件路径即可

     > 关于bilibili本地缓存文件位置提示:
     >
     > 国内bilibili版本的缓存文件一般在:/storage/emulated/0/Android/data/tv.danmaku.bili/download/目录下,其他版本视具体情况而定。

3. Android14及以上,仅可使用Shizuku授权使用,详情请参考上面Android 11~13第二条

## 鸿蒙教程
待补充

## Windows教程

1. 选择选择缓存文件夹并加载后还是空白请检查"缓存类型"是否选择正确,选择错误是无法解析的。

2. 选择选择缓存文件夹并加载后还是空白请检查缓存目录格式是否与下列标准格式大致相同，如果完全不同请调整:

   - Windows缓存文件目录标准格式参考:

   ```sh
   .
   ├── 55444073	//一个标准的缓存文件结构
   │   ├── 55444073_p1-1-30032.m4s
   │   ├── 55444073_p1-1-30216.m4s
   │   ├── dm1
   │   ├── dm2
   │   ├── group.jpg
   │   ├── image.jpg
   │   ├── .playurl
   │   ├── .videoInfo
   │   ├── videoInfo.json
   │   └── view
   └── 55444088
       ├── 55444088_p1-1-30032.m4s
       ├── 55444088_p1-1-30216.m4s
       ├── dm1
       ├── dm2
       ├── group.jpg
       ├── image.jpg
       ├── .playurl
       ├── .videoInfo
       ├── videoInfo.json
       └── view
   ```

   - Android缓存文件目录标准格式参考:

   ```sh
   .
   ├── 115001356452955		//一个标准的缓存文件结构(只包含一个视频)
   │   └── c_31596087333
   │       ├── 80
   │       │   ├── audio.m4s
   │       │   ├── index.json
   │       │   └── video.m4s
   │       ├── danmaku.xml
   │       └── entry.json
   ├── 546538653		//一个标准视频合集的缓存文件结构(里面包含两个视频p1和p2)
   │   ├── c_367013145
   │   │   ├── 80
   │   │   │   ├── audio.m4s
   │   │   │   ├── index.json
   │   │   │   └── video.m4s
   │   │   ├── cover.jpg
   │   │   ├── danmaku.pb
   │   │   ├── danmaku.xml
   │   │   └── entry.json
   │   └── c_367033592
   │       ├── 80
   │       │   ├── audio.m4s
   │       │   ├── index.json
   │       │   └── video.m4s
   │       ├── cover.jpg
   │       ├── danmaku.pb
   │       ├── danmaku.xml
   │       └── entry.json
   └── 810872		//一个标准的缓存文件结构(只包含一个视频)
       └── c_1176840
           ├── 64
           │   ├── audio.m4s
           │   ├── index.json
           │   └── video.m4s
           ├── cover.jpg
           ├── danmaku.pb
           ├── danmaku.xml
           └── entry.json
   ```
   

## Linux教程

与Windows同理

## Mac教程

与Windows同理