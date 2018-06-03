# Install Clang and LLVM 3.4 on Ubuntu 14
sudo apt-get install llvm clang
cd /usr/share/llvm-3.4/cmake
sudo ln -s LLVM-Config.cmake LLVMConfig.cmake

# Install LLVM 4.0 (may need to upgrade CMake) on Ubuntu 14
# Ref: https://releases.llvm.org/4.0.1/docs/CMake.html
# Ref: 
sudo apt remove cmake
sudo mv cmake-3.11.3-Linux-x86_64.sh /opt/
cd /opt
sudo ./cmake-3.11.3-Linux-x86_64.sh 
sudo ln -s /opt/cmake-3.11.3-Linux-x86_64/bin/* /usr/bin/
