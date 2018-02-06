# clang and llvm setup in docker instance
# Ref: https://github.com/whoenig/ros-clang-instrumentation
sudo apt-get update
sudo apt install -y llvm-3.8-dev libclang-3.8-dev clang

# CROSSTOOL
# cpu: k8, armeabi-v7a, x64_windows_msvc, x64_windows_msys, s390x, ios_x86_64
bazel build --crosstool_top=@bazel_tools//tools/cpp:toolchain --cpu=k8 modules/monitor:all 

# clang preprocessor
clang -C -E $file.cc > $file.ii 

# llvm bitcode
clang -O3 -emit-llvm $file.cc -c -o $file.bc

# native assembly
clang $file.cc -S -o $file.s

# executable binary
clang $file.cc -o $file

# view bitcode
llvm-dis < $file.bc | less

# bitcode to assembly
llc $file.bc -o $file.s

# assembly to executable
gcc $file.s -o $file

# run llvm pass on llvm bitcode
opt -load $pass.so -$pass < $file.bc > $file_inst.bc

# run llvm pass in one command line
clang -Xclang -load -Xclang $pass.so $file.c
