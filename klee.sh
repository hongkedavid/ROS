# Build KLEE source code
cd /apollo/klee_build_dir
make
sudo make install

# Run KLEE on Apollo
cd /apollo/bazel-bin/modules/planning
klee --libc=uclibc --posix-runtime --link-llvm-lib=/apollo/boost_1_69_0/o_files/boost.bc --link-llvm-lib=liblog4cxx.so.10.0.0.bc --link-llvm-lib=libroconsole_all.bc --link-llvm-lib=dummy.bc planning.bc

# Generate Apollo bitcode
cd /apollo
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/planning:planning --compilation_mode=dbg
cd /apollo/bazel-bin/modules/planning
extract-bc planning
