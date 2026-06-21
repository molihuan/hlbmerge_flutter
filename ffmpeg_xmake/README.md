
## 编译环境:

- xmake 3.0.9
- flutter 3.35.7


#### xmake 编译脚本在src/xmake下

重新编译ffmpeg:打开src/xmake/.xmake/windows/x64/cache/package找到installdir字段的路径,将对应路径从磁盘中删除

#### Windows 编译注意事项
1. 安装msys2

2. 启动 C:\msys64\mingw64.exe

```shell
# 更新包索引
pacman -Sy

# 安装常用工具链
pacman -S mingw-w64-x86_64-toolchain

# 安装 mingw64 版 iconv ,进行编码修改的时候需要用到,否则会编译失败
pacman -S mingw-w64-x86_64-iconv

# 最后看编译日志,如果缺什么环境就补什么环境
```

#### Mac 编译注意事项

1. 如果修改了macos/ffmpeg_hl.podspec则需要删除下面两个并重新编译
```shell
example/macos/Pods
example/macos/Podfile.lock
```





```shell
flutter run -d web-server

# 常用命令
# 查看常用工具链
xmake show -l toolchains

# 更新仓库
xmake repo --update

# 查看ffmpeg包信息
xmake require --info "ffmpeg_all 7.1"

# xmake packages 路径
# C:/Users/moli/AppData/Local/.xmake/packages

# 生成 CMakeLists.txt
xmake project -k cmakelists -a outputdir build/android/

# 生成 compile_commands.json
xmake project -k compile_commands

# windows编译ffmpeg命令
xmake f -y -p windows -vD

# android编译ffmpeg命令
xmake f -y -p android -vD --ndk=C:/Users/moli/AppData/Local/Android/Sdk/ndk/28.2.13676358 -a arm64-v8a

# 鸿蒙编译ffmpeg命令
# xmake f -c -y -p harmony -vD -a arm64-v8a --sdk=D:/sofe/devecostudio/sdk/default/openharmony/native --bin=D:/sofe/devecostudio/sdk/default/openharmony/native/llvm/bin
xmake f -c -y -p harmony -vD -a arm64-v8a --sdk=C:/Users/moli/soft/devecostudio/sdk/default/openharmony/native --bin=C:/Users/moli/soft/devecostudio/sdk/default/openharmony/native/llvm/bin



# Android分割 ABI 构建，减小 apk 大小
flutter build apk --release --split-per-abi

```






### 调试 C/C++

#### Windows(Clion + MSVC 或直接Visual Studio)
1. Visual Studio

- 用Visual Studio直接打开example/build/windows/x64下的*.sln文件,即可开始调试

2.  Clion + MSVC

- 使用Clion打开example/windows,会自动索引cmake文件,在配置中工具链选择Visual Studio
- 打开设置->Build,Execution->工具链,将Visual Studio设置为默认(第一位)
- 打开example/windows/CMakeLists.txt将/wd"4100"改成/wd4100,编译。
- 最后将example/build/windows/x64/runner/Debug下面运行需要的data、*.dll复制到编译后的exe目录,补足运行环境即可开始调试
在example/windows/flutter/ephemeral/.plugin_symlinks/ffmpeg_hl/src下打断点即可
- 有时候断点打上无效,可以清理cmake构建后重试