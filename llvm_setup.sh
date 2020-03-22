# Ref: http://releases.llvm.org/3.4/tools/clang/docs/ReleaseNotes.html
# Install Clang and LLVM 3.4 on Ubuntu 14
sudo apt-get install llvm clang
cd /usr/share/llvm-3.4/cmake
sudo ln -s LLVM-Config.cmake LLVMConfig.cmake

# Install LLVM 4.0 (may need to upgrade CMake) on Ubuntu 14
# Ref: https://askubuntu.com/questions/829310/how-to-upgrade-cmake-in-ubuntu
sudo apt remove cmake
wget https://cmake.org/files/v3.11/cmake-3.11.3-Linux-x86_64.sh
sudo mv cmake-3.11.3-Linux-x86_64.sh /opt/
cd /opt
sudo ./cmake-3.11.3-Linux-x86_64.sh 
sudo ln -s /opt/cmake-3.11.3-Linux-x86_64/bin/* /usr/bin/
# Ref: https://releases.llvm.org/4.0.1/docs/CMake.html
cd llvm-4.0.0.src
mkdir build
cd build
/opt/cmake-3.11.3-Linux-x86_64/bin/cmake llvm-4.0.0.src/
/opt/cmake-3.11.3-Linux-x86_64/bin/cmake --build . -- -j32

# LLVM debug build
# https://github.com/llvm/llvm-project/blob/master/clang/INSTALL.txt
# https://llvm.org/docs/CMake.html
wget http://releases.llvm.org/3.4.2/cfe-3.4.2.src.tar.gz
wget http://releases.llvm.org/3.4.2/llvm-3.4.2.src.tar.gz
tar xf cfe-3.4.2.src.tar.gz
tar xf llvm-3.4.2.src.tar.gz
mv cfe-3.4.2.src llvm-3.4.2.src/tools/clang
mkdir llvm_build
cd llvm_build
cmake -DCMAKE_BUILD_TYPE=Debug ../llvm-3.4.2.src
# for LLVM 8, may need to enable LLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN
cmake -DCMAKE_BUILD_TYPE=Debug -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=true ../llvm-8.0.1.src
# Build and install LLVM and Clang
cmake --build .
sudo cmake --build . --target install

