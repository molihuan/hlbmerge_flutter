

<p align="center">
<img src="https://s2.loli.net/2022/12/14/WoYwfehDNHbMzIZ.png" alt="Banner" />
</p>
<h1 align="center">HLB站缓存合并</h1>

[![license: Apache-2.0 (shields.io)](https://img.shields.io/badge/license-Apache--2.0-brightgreen)](https://github.com/molihuan/mlhfileselectorlib/blob/master/LICENSE)[![Star](https://img.shields.io/github/stars/molihuan/hlbmerge_flutter.svg)](https://github.com/molihuan/hlbmerge_flutter)[![bilibili: 玲莫利 (shields.io)](https://img.shields.io/badge/bilibili-玲莫利-orange)](https://space.bilibili.com/454222981)[![CSDN: molihuan (shields.io)](https://img.shields.io/badge/CSDN-molihuan-blue)](https://blog.csdn.net/molihuan)

<h3 align="center">提供Bilibili缓存视频合并的工具</h3>
<p align="center">将Bilibili缓存文件合并导出为MP4，支持Android、windows(10以上)、linux、mac、ios，支持B站Android客户端缓存，支持B站Windows客户端缓存</p>
<p align="center">Combine and export Bilibili cache files as MP4, support Android, Windows, Linux, Mac, iOS, support Bilibili Android client cache, support Bilibili Windows client cache</p>

## 说明

此软件是为了帮助网友合并哔哩哔哩缓存视频，将bilibili缓存视频合并导出为mp4，支持Android、windows、linux、mac、ios，你可以将它理解为一个专用的格式工厂，并不涉及破解相关内容，仅仅用于学习技术交流，严禁用于商业用途，如有侵权请联系我删库，由此给你带来困惑和不便我深感抱歉。

## 特性

- [x] 合并(导出)B站缓存(有声音视频，仅音频)
- [x] 支持B站Android客户端缓存(国内版、概念版、谷歌版、HD版)
- [x] 支持B站Windows客户端缓存
- [x] 支持第三方B站客户端(bilimiao)

## 前言

#### 在开始之前可以给项目一个Star吗？非常感谢，你的支持是我唯一的动力。欢迎Star和Issues!

#### 我们需要你的Pr

#### 项目地址：
##### [Github地址](https://github.com/molihuan/hlbmerge_flutter)
##### [Gitcode地址](https://gitcode.com/bigmolihuan/hlbmerge_flutter)

# 注意 ! ! !

- 此软件存放的目录不能有空格或特殊字符
- 读取缓存视频的目录不能有空格或特殊字符
- 输出目录不能有空格或特殊字符
- 视频名称或标题不能有特殊字符(虽然做了兼容处理,但可能无法兼顾到所有的特殊字符)
- 它不依赖网络这个不确定的因素，它只依赖本地缓存文件，只要本地有缓存文件，那么它就可以工作(即使视频已经下架)，需要和官方APP（手机版/电脑版均可）配合使用，官方APP进行缓存，它操作缓存文件进行合并导出mp4

## 下载链接：[跳转](https://gitcode.com/bigmolihuan/hlbmerge_flutter/releases) 

> 为了照顾国内网友,现在releases安装包仅在国内镜像仓库上传,望理解。

Linux版本：使用ubuntu-22.04.2-amd64打包，你的系统版本低不保证可用，如有问题请下载源码自行打包

Mac版本：使用macOS ventura 13.4.1版本打包，你的系统版本低不保证可用，如有问题请下载源码自行打包

Windows：使用Win 10打包，你的系统版本低不保证可用，如有问题请下载源码自行打包

## 截图

| 平台截图                                                                                                           |
|----------------------------------------------------------------------------------------------------------------|
| Android                                                                                                        |
| [![preview-android-01.jpg](https://i.postimg.cc/6qBFDvvJ/preview-android-01.jpg)](https://postimg.cc/47F8cnPB) |
| Windows                                                                                                        |
| [![preview-windows-01.png](https://i.postimg.cc/qqpW933H/preview-windows-01.png)](https://postimg.cc/k6hjSDsT) |
| Linux                                                                                                          |
| [![preview-linux-01.png](https://i.postimg.cc/fTvZ8M1V/preview-linux-01.png)](https://postimg.cc/fJk6LQzs)     |
| ohos                                                                                                           |
| 待补充                                                                                                            |
| Mac                                                                                                            |
| [![preview-mac-01.png](https://i.postimg.cc/kGYs9cnf/preview-mac-01.png)](https://postimg.cc/BPDHB2PK)    |
| ios                                                                                                            |
| 待补充                                                                                                            |


## 使用教程：[跳转](https://github.com/molihuan/hlbmerge_flutter/blob/master/res/tutorial/README.md) 

## 问题反馈

##### 因为有你软件才更加完善

请使用模板反馈问题，这样可以帮助开发者快速定位和解决问题，谢谢配合，爱你萌萌哒~^o^~

##### 反馈模板:

类别：(必填，0、优化建议。1、打开软件就闪退。2、无论什么视频合并都失败或闪退。3、合并个别视频失败或闪退。4、主页空白无法加载哔哩哔哩缓存视频。5、其他问题)

设备信息：(必填)

描述：(必填，越详细越好)

怎样触发bug：(选填)

视频链接：(选填，如果视频已经下架则把本地缓存文件打包压缩发我邮箱)

## 源码编译事项
目前使用的是的鸿蒙flutter3.27.4

常用命令:
```sh
# 创建项目
# flutter create --org com.molihuan --platforms=android,ios,web,windows,macos,linux,ohos hlbmerge

# windows打包
flutter build windows

# macOS打包
flutter build macos

# Linux打包(release有问题,暂时没找到原因,希望有linux大佬指点一下)
flutter build linux --debug

# Android release 包
flutter build apk --release

# Android分割 ABI 构建，减小 apk 大小
flutter build apk --release --split-per-abi
# 生成图标
flutter pub run flutter_launcher_icons

```
Windows ffmpeg配置,cmake构建时会自动下载ffmpeg,但是没有做文件完整性校验,请保持网络通畅,如果构建失败请尝试flutter clean后重新构建
```sh
ffmpeg version 4.3.1 Copyright (c) 2000-2020 the FFmpeg developers
  built with gcc 10.2.1 (GCC) 20200726
  configuration: --disable-static --enable-shared --enable-gpl --enable-version3 --enable-sdl2 --enable-fontconfig --enable-gnutls --enable-iconv --enable-libass --enable-libdav1d --enable-libbluray --enable-libfreetype --enable-libmp3lame --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libopus --enable-libshine --enable-libsnappy --enable-libsoxr --enable-libsrt --enable-libtheora --enable-libtwolame --enable-libvpx --enable-libwavpack --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libzimg --enable-lzma --enable-zlib --enable-gmp --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvo-amrwbenc --enable-libmysofa --enable-libspeex --enable-libxvid --enable-libaom --enable-libgsm --enable-librav1e --disable-w32threads --enable-libmfx --enable-ffnvcodec --enable-cuda-llvm --enable-cuvid --enable-d3d11va --enable-nvenc --enable-nvdec --enable-dxva2 --enable-avisynth --enable-libopenmpt --enable-amf
  libavutil      56. 51.100 / 56. 51.100
  libavcodec     58. 91.100 / 58. 91.100
  libavformat    58. 45.100 / 58. 45.100
  libavdevice    58. 10.100 / 58. 10.100
  libavfilter     7. 85.100 /  7. 85.100
  libswscale      5.  7.100 /  5.  7.100
  libswresample   3.  7.100 /  3.  7.100
  libpostproc    55.  7.100 / 55.  7.100
Hyper fast Audio and Video encoder
usage: ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}
```
Linux ffmpeg配置,cmake构建时会自动下载ffmpeg,但是没有做文件完整性校验,请保持网络通畅,如果构建失败请尝试flutter clean后重新构建
```sh
ffmpeg version 4.3.1 Copyright (c) 2000-2020 the FFmpeg developers
  built with gcc 9.3.0 (crosstool-NG 1.24.0.133_b0863d8_dirty)
  configuration: --prefix=/home/moli/.vmr/versions/ffmpeg_versions/ffmpeg-4.3.1 --cc=/home/conda/feedstock_root/build_artifacts/ffmpeg_1609680890771/_build_env/bin/x86_64-conda-linux-gnu-cc --disable-doc --disable-openssl --enable-avresample --enable-gnutls --enable-gpl --enable-hardcoded-tables --enable-libfreetype --enable-libopenh264 --enable-libx264 --enable-pic --enable-pthreads --enable-shared --enable-static --enable-version3 --enable-zlib --enable-libmp3lame --pkg-config=/home/conda/feedstock_root/build_artifacts/ffmpeg_1609680890771/_build_env/bin/pkg-config
  libavutil      56. 51.100 / 56. 51.100
  libavcodec     58. 91.100 / 58. 91.100
  libavformat    58. 45.100 / 58. 45.100
  libavdevice    58. 10.100 / 58. 10.100
  libavfilter     7. 85.100 /  7. 85.100
  libavresample   4.  0.  0 /  4.  0.  0
  libswscale      5.  7.100 /  5.  7.100
  libswresample   3.  7.100 /  3.  7.100
  libpostproc    55.  7.100 / 55.  7.100
Hyper fast Audio and Video encoder
```

## 特别鸣谢

- https://gitee.com/l2063610646/bilibili-convert
- https://www.bilibili.com/video/BV1gv4y1M7yn/
- https://github.com/sk3llo/ffmpeg_kit_flutter
- https://github.com/RikkaApps/Shizuku
- https://github.com/10miaomiao/bili-down-out
- https://zhuanlan.zhihu.com/p/704594199

教程或开源项目以及其依赖项目。

## [LICENSE](./LICENSE)

```
Copyright [2025] molihuan

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
