# clang preprocessor
clang -C -E $file.cc > $file.ii 

# llvm bitcode
clang -O3 -emit-llvm $file.cc -c -o $file.bc
