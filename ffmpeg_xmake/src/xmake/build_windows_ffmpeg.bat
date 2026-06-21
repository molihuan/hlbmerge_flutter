
@REM xmake clean -a

set mingwSdk=C:/msys64/mingw64

set arch=x64

@REM mingw compile
@REM set platform=mingw

@REM windows(msvc) compile
set platform=windows


@REM msvc compile
xmake f -y -c -p %platform% -a %arch% --sdk=%mingwSdk% -vD


xmake -vD

xmake project -k cmakelists -a outputdir build/%platform%/%arch%
@REM Code tips: It is recommended to use vs code with clangd
xmake project -k compile_commands
