
(function() {
  // 备份原生的 ffmpeg_core 构造函数
  const originalFfmpegCore = window.ffmpeg_core;
  if (typeof originalFfmpegCore !== 'function') {
      console.error("未找到全局的 ffmpeg_core 函数，请确保 ffmpeg_core.js 在此脚本之前加载！");
      return;
  }

  // 劫持,必须要劫持,否则会导致有多个wasm,导致数据不一致
  window.ffmpeg_core = async function (moduleArg = {}) {
      console.log("[拦截器] 探测到 ffmpeg_core 调用请求");

      // 如果是第一次调用，真正执行初始化，并保存实例
      if (!window.shared_ffmpeg) {
          console.log("[拦截器] 正在进行首次初始化...", moduleArg);

          // 使用调用者（比如 universal_ffi）传入的参数进行初始化
          window.shared_ffmpeg = await originalFfmpegCore(moduleArg);

          console.log("[拦截器] 唯一实例初始化成功并已锁定:", window.shared_ffmpeg);
      } else {
          console.log("[拦截器] 直接返回已存在的唯一实例（避免了二次初始化）");
      }

      return window.shared_ffmpeg;
  };

  // 安全获取共享实例
  // 控制台打印文件夹  window.shared_ffmpeg.FS.readdir('/');
  async function getModule() {
      if (!window.shared_ffmpeg) {
          console.log("[VFS 警告] 实例尚未初始化，正在主动触发...");
          await window.ffmpeg_core(); // 触发上面重写后的初始化
      }
      return window.shared_ffmpeg;
  }

  // 写入文件至 VFS
  window.wasmWriteFile = async function(path, u8Array) {
      const Module = await getModule();
      if (Module && Module.FS) {
          Module.FS.writeFile(path, u8Array);
          const size = Module.FS.stat(path).size;
          console.log(`[VFS 成功] 写入文件: ${path}, 大小: ${size} 字节`);
          return true;
      } else {
          console.error("[VFS 错误] 写入失败：WASM 模块未就绪");
          return false;
      }
  };

  // 从 VFS 读取文件
  window.wasmReadFile = async function(path) {
      const Module = await getModule();
      if (Module && Module.FS) {
          return Module.FS.readFile(path);
      }
  };

  //删除 VFS 里的文件
  window.wasmUnlink = async function(path) {
      const Module = await getModule();
      if (Module && Module.FS) {
          Module.FS.unlink(path);
      }
  };

    // 直接在 JS 侧读取 VFS 视频并弹出浏览器下载
    window.wasmDownloadFile = async function(vfsPath, downloadName) {
        const Module = await getModule();
        if (Module && Module.FS) {
            try {
                // 从 VFS 读取合并好的二进制数据
                const resultBytes = Module.FS.readFile(vfsPath);

                // 转化为浏览器原生 Blob，设置多媒体类型为视频
                const blob = new Blob([resultBytes], { type: 'video/mp4' });
                const url = URL.createObjectURL(blob);

                // 创建隐藏的 a 标签触发浏览器下载
                const a = document.createElement('a');
                a.href = url;
                // 自动提取纯文件名,防止传入带斜杠的路径
                a.download = downloadName.substring(downloadName.lastIndexOf('/') + 1) || downloadName;

                document.body.appendChild(a);
                a.click();
                a.remove();

                // 释放临时的 URL 内存
                URL.revokeObjectURL(url);
                console.log(`[JS 下载] 成功下载文件: ${vfsPath} -> ${downloadName}`);
            } catch (e) {
                console.error("[JS 下载] 读取或弹出下载失败:", e);
            }
        } else {
            console.error("[JS 下载] 下载失败：WASM 模块未就绪");
        }
    };


})();