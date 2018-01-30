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
