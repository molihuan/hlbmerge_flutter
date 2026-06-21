add_rules("mode.debug", "mode.release")

local oh_sdk="C:/Users/moli/soft/devecostudio/sdk/default/openharmony/native"
--local oh_sdk="D:/sofe/devecostudio/sdk/default/openharmony/native"

-- 添加本地仓库
add_repositories("myrepo project_repo")
-- 本地仓库中的ffmpeg
local ffmpegPackage = "ffmpeg_all"
local ffmpegPackageVersion = "7.1"

add_requires(ffmpegPackage .. " " .. ffmpegPackageVersion,{
    optional = true,
    system = false,
    override = true,
    configs = {
        shared = false,
        gpl = false,
        ffmpeg = false
    }
})

target("ffmpeg_core")
    if is_plat("iphoneos") then
        -- 启用自动合并策略,把依赖自动打包合并入当前生成的库中
        set_policy("build.merge_archive", true)
        set_kind("shared")
    elseif is_plat("wasm") then
        set_policy("build.merge_archive", true)
        set_kind("binary")
        -- 必须指定名称,否则找不到
        set_filename("ffmpeg_core.js")
        add_ldflags(
            "--no-entry",
            -- 允许内存扩展
            "-sALLOW_MEMORY_GROWTH",
            -- 支持文件系统
            "-sFORCE_FILESYSTEM",
            --ES Module
            "-sMODULARIZE=1",
            "-sEXPORT_NAME='ffmpeg_core'",
            --"-sEXPORT_ES6=1",
            "-sWASM_BIGINT",
            "-sENVIRONMENT=web,worker",
            "-sEXPORTED_FUNCTIONS=['_malloc','_free','_run_merge_audio_video','_run_merge_videos','_get_ffmpeg_version']",
            "-sEXPORTED_RUNTIME_METHODS=['HEAPU8','ccall','cwrap','FS','UTF8ToString','stringToUTF8','lengthBytesUTF8']",
             {force = true}
        )
    else
        set_kind("shared")
    end

    -- 添加soname
    if is_plat("linux") then
        add_shflags("-Wl,-soname,ffmpeg_core.so")
    end

    -- 添加库,只链接需要的
    add_packages(ffmpegPackage,{links = {"avformat","avcodec","avutil"}})

    if is_plat("wasm") then
        add_includedirs(
        "include",
        "../"
        )
        -- 添加源文件
        add_files("src/*.cpp","src/*.c","../*.c")
    else
        add_includedirs(
        "include"
        )
        -- 添加源文件
        add_files("src/*.cpp","src/*.c")
    end

    -- 强制将目标文件输出到 build/架构名下，从而去掉 release 目录
    set_targetdir("build/$(plat)/$(arch)")