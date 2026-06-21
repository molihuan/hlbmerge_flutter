allprojects {
    val isGitHubCI = System.getenv("GITHUB_CI") != null
    repositories {
        if (!isGitHubCI) {
            println("not GITHUB_CI env")
            maven { url = uri("https://maven.aliyun.com/repository/public")}
            maven { url = uri("https://maven.aliyun.com/repository/google")}
            maven { url = uri("https://maven.aliyun.com/repository/central")}
            maven { url = uri("https://jitpack.io") }
            maven { url = uri("https://repo.huaweicloud.com/repository/maven") }
        }
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
