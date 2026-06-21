@echo off
chcp 65001

xmake f -y -c -p wasm --toolchain=emcc -vD --sdk=C:/Users/moli/.vmr/versions/emsdk

xmake -vD


set "src=build\wasm\wasm32"
set "dst=..\..\assets\wasm"

set "coreJs=%src%\ffmpeg_core.js"
set "injectionJs=%src%\function_injection.js"

type "%injectionJs%" >> "%coreJs%"

md "%dst%" 2>nul

copy "%src%\ffmpeg_core.js" "%dst%\" /y
copy "%src%\ffmpeg_core.wasm" "%dst%\" /y