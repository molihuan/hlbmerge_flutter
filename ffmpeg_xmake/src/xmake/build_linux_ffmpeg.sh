
arch="x86_64"

xmake f -y -c -p linux -a ${arch} -vD

xmake -vD

xmake project -k cmakelists -a outputdir build/linux/${arch}

xmake project -k compile_commands