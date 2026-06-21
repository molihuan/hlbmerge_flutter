
<p align="center">
  <h1 align="center"> <code>pigeon</code> </h1>
</p>

This project is based on [pigeon@26.1.5](https://pub.dev/packages/pigeon/versions/26.1.5) 

## 1. Installation and Usage

### 1.1 Installation

Go to the project directory and add the following dependencies in pubspec.yaml

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

Execute Command

```bash
flutter pub get
```

<!-- tabs:end -->

### 1.2 Usage

For use cases [example](./example)

## 2. Constraints

### 2.1 Compatibility

This document is verified based on the following versions:

1. Flutter version 3.35.8-ohos-0.0.1-canary1; SDK: 6.0.0.47 (API Version 20 Release); IDE: DevEco Studio: 6.0.0.858; ROM: 6.0.0.125 SP8;

## 3. API

> [!TIP] "Pigeon" is a code generation tool that is invoked by executing commands in the terminal and does not involve any API.

## 4. Annotation

> [!TIP] If the value of **ohos Support** is **yes**, it means that the ohos platform supports this annotation; **no** means the opposite; **partially** means some capabilities of this annotation are supported. The usage method is the same on different platforms and the effect is the same as that of iOS or Android.

| Name                | Description                                                                                                                | Type       | ohos Support |
|---------------------|----------------------------------------------------------------------------------------------------------------------------|-------------|-------------------|
| @HostApi()            | Defines interfaces using the @HostApi() annotation, which are implemented by the native platform and called by Flutter     | annotation | yes               |
| @FlutterApi()   | Defines interfaces using the @FlutterApi() annotation, which are implemented by Flutter and called by the native platform  | annotation | yes               |

## 5. Command

> [!TIP] If the value of **ohos Support** is **yes**, it means that the ohos platform supports this command; **no** means the opposite; **partially** means some capabilities of this command are supported. The usage method is the same on different platforms and the effect is the same as that of iOS or Android.

Usage：`flutter pub run pigeon --input <pigeon path> --dart_out<dart path> [option]*`
>
| Command                             | Description                                                                  | ohos Support |
|-------------------------------------|------------------------------------------------------------------------------|--------------|
| --input <pigeon path>               | Specifies the path to the Dart file that defines the communication interface | yes          |
| --dart_out <dart path>              | Specifies the output path for the generated Dart file                        | yes          |
| --objc_header_out <iOS header file path> | Specifies the output path for the generated iOS header(".h") file              | yes          |
| --objc_source_out <iOS implementation file path> | Specifies the output path for the generated iOS source(".m") file              | yes          |
| --java_out <Android Java file path>       | Specifies the output path for the generated Android Java file                | yes          |
| --java_package <Android package name>          | Specifies the package name for the generated Android Java file               | yes          |
| --arkts_out <ArkTS file path>               | Specifies the output path for the generated ohos ArkTS file                  |     yes      |
| --kotlin_out <Kotlin file path>         | Specifies the output path for the generated Android Kotlin file              |     yes      |
| --swift_out <Swift file path>           | Specifies the output path for the generated macOS Swift file                 |     yes      |
| --cpp_header_out <C++ header file path>         | Specifies the output path for the generated Windows C++ header(".h") file      |     yes      |
| --cpp_source_out <C++ implementation file path>        | Specifies the output path for the generated Windows C++ classes(".cpp") file   |     yes      |

## 6. Known Issues

## 7. **Others**

## 8. **License**

This project is licensed under [BSD-3-Clause](https://gitcode.com/openharmony-tpc/flutter_packages/blob/br_pigeon-v25.3.2_ohos/packages/pigeon/LICENSE).



> Template version: v0.0.1