#xmake f -y -c -p iphoneos -a arm64 -vD
#
#xmake -vD

# 两次构建需要清理删除后才行,否则有缓存会覆盖

xmake f -y -c -p iphoneos --appledev=simulator -a arm64 -vD

xmake -vD

#marge

#xcodebuild -create-xcframework \
#    -library build/iphoneos/iphoneos/libffmpeg_core.a \
#    -headers include \
#    -library build/iphoneos/iphonesimulator/libffmpeg_core.a \
#    -headers include \
#    -output build/iphoneos/ffmpeg_core.xcframework


##copy
#mkdir -p ../../ios/libs
#
#cp -r build/iphoneos/ffmpeg_core.xcframework ../../ios/libs/