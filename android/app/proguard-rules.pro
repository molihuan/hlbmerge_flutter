# 保持com.antonkarpenko.ffmpegkit整个包不被混淆
-keep class com.antonkarpenko.ffmpegkit.** { *; }

# 保持所有 native 方法
-keepclasseswithmembernames class * {
    native <methods>;
}

# 避免删除带注解的类
-keepattributes *Annotation*
# 避免Shizuku的服务接口不被混淆
-keepclassmembers class com.molihuan.hlbmerge.service.copy.ShizukuFileCopyUserService {
    public <init>(...);
}
