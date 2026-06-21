#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ffmpeg_hl.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ffmpeg_hl'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'


  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 x86_64',
    'HEADER_SEARCH_PATHS' => [
           '"${PODS_TARGET_SRCROOT}/../src/xmake/include"'
    ].join(' '),
    # 添加库搜索路径
    'LIBRARY_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/libs',
    # 链接库
    'OTHER_LDFLAGS' => '-lffmpeg_core'
  }

  # 针对宿主 App (Runner) Target
  s.user_target_xcconfig = {
    # 主程序编译模拟器时同样排除 x86_64
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386 x86_64',
    # 添加库搜索路径
    'LIBRARY_SEARCH_PATHS' => '$(PODS_ROOT)/../.symlinks/plugins/ffmpeg_hl/ios/libs',
    # 链接库
    'OTHER_LDFLAGS' => '-lffmpeg_core'
  }

  # 最后别忘记了dylib需要签名,中主程序中配置


  s.swift_version = '5.0'
end
