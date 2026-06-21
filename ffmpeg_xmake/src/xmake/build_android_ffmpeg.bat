
@REM xmake clean -a

set arch=arm64-v8a

xmake f -y -c -p android -vD --ndk=C:/Users/moli/AppData/Local/Android/Sdk/ndk/28.2.13676358 -a %arch%

xmake -vD

xmake project -k cmakelists -a outputdir build/android/%arch%

@REM
xmake project -k compile_commands
