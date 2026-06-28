import org.gradle.kotlin.dsl.implementation
import java.util.Properties

plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.compose)
    alias(libs.plugins.ksp)
    alias(libs.plugins.kotlin.serialization)
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}


// 获取签名配置
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("keystore.properties")
val ableReleaseSigning = keystorePropertiesFile.exists()
if (ableReleaseSigning) {
    keystorePropertiesFile.inputStream().use { input ->
        keystoreProperties.load(input)
    }
}

android {
    namespace = "com.molihuan.hlbmerge"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.molihuan.hlbmerge"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

    }

    val releaseSigningName = "release"

    signingConfigs {
        create(releaseSigningName) {
            if (ableReleaseSigning) {
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    val releaseSigningConfig = if (ableReleaseSigning) {
        signingConfigs.getByName(releaseSigningName)
    } else {
        signingConfigs.getByName("debug")
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = releaseSigningConfig

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        release {
            // Signing with the debug keys for now, so `flutter run --release` works.
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = releaseSigningConfig

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    buildFeatures {
        compose = true
        aidl = true
        buildConfig = true
    }

    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    dependencies {
        // composeBom
        val composeBom = platform(libs.androidx.compose.bom)
        implementation(composeBom)
        testImplementation(composeBom)
        androidTestImplementation(composeBom)
        // 通用模块
        implementation(project(":CommonModule"))
        // 序列化
        implementation(libs.kotlinx.serialization.json)
        // 图片加载
        implementation(libs.coil.compose)
        implementation(libs.coil.network.okhttp)
        // 设备兼容框架：https://github.com/getActivity/DeviceCompat
        implementation(libs.devicecompat)
        // 权限请求框架：https://github.com/getActivity/XXPermissions
        implementation(libs.xxpermissions)
        //图标库 https://mvnrepository.com/artifact/androidx.compose.material/material-icons-extended
        implementation("androidx.compose.material:material-icons-extended:1.7.8")
        // https://mvnrepository.com/artifact/androidx.documentfile/documentfile
        implementation(libs.androidx.documentfile)
        //shizuku
        implementation(libs.shizuku.api)
        implementation(libs.shizuku.provider)

        //mmkv
        implementation("com.tencent:mmkv:2.4.0")

        //基础UI
        implementation(libs.androidx.core.ktx)
        implementation(libs.androidx.lifecycle.runtime.ktx)
        implementation(libs.androidx.activity.compose)
        implementation(libs.androidx.ui)
        implementation(libs.androidx.ui.graphics)
        implementation(libs.androidx.ui.tooling.preview)
        implementation(libs.androidx.material3)

        // compose约束布局
        implementation(libs.androidx.constraintlayout.compose)
        // compose导航
        implementation(libs.androidx.navigation3.runtime)
        implementation(libs.androidx.navigation3.ui)
        implementation(libs.androidx.lifecycle.viewmodel.navigation3)

        //测试相关
        testImplementation(libs.junit)
        androidTestImplementation(libs.androidx.junit)
        androidTestImplementation(libs.androidx.espresso.core)
        androidTestImplementation(libs.androidx.ui.test.junit4)
        debugImplementation(libs.androidx.ui.tooling)
        debugImplementation(libs.androidx.ui.test.manifest)

    }
}

flutter {
    source = "../.."
}
