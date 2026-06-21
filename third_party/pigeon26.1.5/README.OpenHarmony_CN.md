
<p align="center">
  <h1 align="center"> <code>pigeon</code> </h1>
</p>

本项目基于 [pigeon@26.1.5](https://pub.dev/packages/pigeon/versions/26.1.5) 开发。

## 1. 安装与使用

### 1.1 安装方式

进入到工程目录并在 pubspec.yaml 中添加以下依赖：

<!-- tabs:start -->

#### pubspec.yaml

```yaml

dependencies:
  pigeon:
    git: 
      url: "https://gitcode.com/openharmony-sig/flutter_packages.git"
      path: "packages/pigeon"
      ref: "br_pigeon-v26.1.5_ohos"

```

执行命令

```bash
flutter pub get
```

<!-- tabs:end -->

### 1.2 使用案例

使用案例详见 [example](./example)

## 2. 约束与限制

### 2.1 兼容性

在以下版本中已测试通过

1. Flutter version 3.35.8-ohos-0.0.1-canary1; SDK: 6.0.0.47 (API Version 20 Release); IDE: DevEco Studio: 6.0.0.858; ROM: 6.0.0.125 SP8;

## 3. API

> [!TIP] "Pigeon"是一个代码生成工具，通过终端执行命令调用，不涉及API

## 4. 注解

> [!TIP] "ohos Support"列为 yes 表示 ohos 平台支持该注解；no 则表示不支持；partially 表示部分支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果。

| Name                | Description                                                                                                            | Type       | ohos Support |
|---------------------|-------------------------------------------------------------------------------------------------------|-------------|-------------------|
| @HostApi()           |   使用 @HostApi() 注解定义接口，这些接口由原生平台实现，供 Flutter 调用                                                                       | annotation | yes               |
| @FlutterApi()   |  使用 @FlutterApi() 注解定义接口，这些接口由 Flutter 实现，供原生平台调用                                                             | annotation | yes               |

## 5. 命令

> [!TIP] "ohos Support"列为 yes 表示 ohos 平台支持该命令；no 则表示不支持；partially 表示部分支持。使用方法跨平台一致，效果对标 iOS 或 Android 的效果。

使用：`flutter pub run pigeon --input <pigeon path> --dart_out<dart path> [option]*`
> 
| Command                       | Description                   | ohos Support |
|-------------------------------|-------------------------------|--------------|
| --input <pigeon path>         | 指定输入的 Dart 文件路径，该文件中定义了通信接口   | yes          |
| --dart_out <dart path>        | 指定生成的 Dart 文件的输出路径            | yes          |
| --objc_header_out <iOS头文件路径>  | 指定生成的 iOS 头文件(".h")路径         | yes          |
| --objc_source_out <iOS实现文件路径> | 指定生成的 iOS 源文件(".m")路径         | yes          |
| --java_out <Android Java文件路径> | 指定生成的 Android Java 文件路径       | yes          |
| --java_package <Android包名>    | 指定生成的 Android Java 文件包名       | yes          |
| --arkts_out <ArkTS文件路径>       | 指定生成的鸿蒙 ArkTS 文件路径            |     yes      |
| --kotlin_out <Kotlin输出文件路径>   | 指定生成的 Android Kotlin 文件路径     |     yes      |
| --swift_out <Swift输出文件路径>     | 指定生成的 macOS swift 文件路径        |     yes      |
| --cpp_header_out <C++头文件路径>   | 指定生成的 Windows 头文件(".h")文件路径   |     yes      |
| --cpp_source_out <C++实现文件路径>  | 指定生成的 Windows 源文件(".cpp")文件路径 |     yes      |

## 6. 遗留问题

## 7. 其他

## 8. 开源协议

本项目基于 [BSD-3-Clause](https://gitcode.com/openharmony-tpc/flutter_packages/blob/br_pigeon-v25.3.2_ohos/packages/pigeon/LICENSE) ，请自由地享受和参与开源。



> 模板版本: v0.0.1