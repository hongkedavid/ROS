# Build KLEE source code
cd /apollo/klee_build_dir
make
sudo make install

# Run KLEE on Apollo
cd bazel-bin/modules/planning
klee --libc=uclibc --posix-runtime --link-llvm-lib=/apollo/boost_1_69_0/o_files/boost.bc --link-llvm-lib=liblog4cxx.so.10.0.0.bc --link-llvm-lib=libroconsole_all.bc --link-llvm-lib=dummy.bc planning.bc

# Generate Apollo bitcode
cd bazel-bin/modules/planning
klee --libc=uclibc --posix-runtime --link-llvm-lib=/apollo/boost_1_69_0/o_files/boost.bc --link-llvm-lib=liblog4cxx.so.10.0.0.bc --link-llvm-lib=libroconsole_all.bc --link-llvm-lib=dummy.bc planning.bc
