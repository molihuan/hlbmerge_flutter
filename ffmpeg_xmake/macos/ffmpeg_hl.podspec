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

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'

  # If your plugin requires a privacy manifest, for example if it collects user
  # data, update the PrivacyInfo.xcprivacy file to describe your plugin's
  # privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'ffmpeg_hl_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

    s.script_phase = {
      :name => 'Debug Paths',
      :script => <<-SCRIPT
        pwd
        echo "SRCROOT=$SRCROOT"
        echo "PODS_TARGET_SRCROOT=$PODS_TARGET_SRCROOT"
      SCRIPT
    }

  s.dependency 'FlutterMacOS'

  s.vendored_libraries = 'libs/*.dylib'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = {
   'DEFINES_MODULE' => 'YES',
   'HEADER_SEARCH_PATHS' => [
       '"${PODS_TARGET_SRCROOT}/../src/xmake/include"'
   ].join(' ')
  }
  s.swift_version = '5.0'
end
