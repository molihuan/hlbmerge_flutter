xmake f -y -c -p macosx -a arm64 -vD

xmake -vD

xmake f -y -c -p macosx -a x86_64 -vD

xmake -vD

#marge

lipo -create -output build/macosx/libffmpeg_core.dylib build/macosx/arm64/libffmpeg_core.dylib build/macosx/x86_64/libffmpeg_core.dylib

#copy
mkdir -p ../../macos/libs

cp build/macosx/libffmpeg_core.dylib ../../macos/libs/