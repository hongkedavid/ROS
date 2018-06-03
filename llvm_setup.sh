# Install Clang and LLVM 3.4 on Ubuntu 14
sudo apt-get install llvm clang
cd /usr/share/llvm-3.4/cmake
sudo ln -s LLVM-Config.cmake LLVMConfig.cmake

# Install LLVM 4.0 on Ubuntu 14
# Ref: https://releases.llvm.org/4.0.1/docs/CMake.html
