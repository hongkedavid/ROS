# Ref: https://github.com/ramosbugs/ucklee/wiki/Building-UC-KLEE

# LLVM-2.7 needs to be built by gcc 4.4
# Ref: https://lists.gt.net/clamav/devel/59892
sudo apt-get install gcc-4.4 g++-4.4
sudo ln -s -b /usr/bin/gcc /usr/bin/gcc
sudo ln -s -b /usr/bin/g++ /usr/bin/g++
