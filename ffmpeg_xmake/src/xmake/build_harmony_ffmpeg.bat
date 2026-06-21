
@REM xmake clean -a

set OH_SDK=C:/Users/moli/soft/devecostudio/sdk/default/openharmony/native
@REM set OH_SDK=D:/sofe/devecostudio/sdk/default/openharmony/native

set arch=arm64-v8a

xmake f -y -c -p harmony -vD --toolchain=hdk -a %arch% --sdk=%OH_SDK% --bin=%OH_SDK%/llvm/bin


xmake -vD

xmake project -k cmakelists -a outputdir build/harmony/%arch%
@REM
xmake project -k compile_commands
