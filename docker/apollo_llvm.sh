# clang and llvm setup in docker instance
# Ref: https://github.com/whoenig/ros-clang-instrumentation
sudo apt-get update
sudo apt install -y llvm-3.8-dev libclang-3.8-dev clang

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
cmake --build .
sudo cmake --build . --target install

# Build LLVM bitcode for v3.0
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/localization:localization
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/routing:routing
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/prediction:prediction
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/planning:planning
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/control:control
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/guardian:guardian
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/monitor:monitor
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/canbus:canbus
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/drivers/gnss:gnss  
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/drivers/radar/conti_radar:conti_radar
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/drivers/radar/ultrasonic_radar:ultrasonic_radar
bazel build --define ARCH=x86_64 --define CAN_CARD=fake_can --cxxopt=-DUSE_ESD_CAN=false --copt=-mavx2 --copt=-mno-sse3 --cxxopt=-DCPU_ONLY --crosstool_top=tools/wllvm:toolchain //modules/drivers/radar/racobit_radar:racobit_radar

# Build LLVM bitcode for v3.5
# Comment c++1y in tools/bazel.rc
bash apollo.sh build_no_perception --copt=-mavx2 --cxxopt=-mavx2 --copt=-mno-sse3 --crosstool_top=tools/wllvm:toolchain

# CROSSTOOL config does not work, seems hard to reconfigure bazel_tools
# Ref: https://github.com/bazelbuild/bazel/issues/3566
# Ref: https://stackoverflow.com/questions/45710957/how-to-generate-llvm-ir-binary-bc-while-compiling-project-with-bazel 
# Ref: https://github.com/bazelbuild/bazel/wiki/Building-with-a-custom-toolchain
# Ref: https://groups.google.com/forum/#!topic/bazel-discuss/VBhB9aVkho4
# Ref: https://groups.google.com/forum/#!topic/bazel-discuss/uvPVi9fmQME
# Ref: https://groups.google.com/forum/#!topic/bazel-discuss/U4yMaZGPqe4
# Ref: https://docs.bazel.build/versions/master/command-line-reference.html
# Ref: https://docs.bazel.build/versions/master/best-practices.html
# cpu: k8, armeabi-v7a, x64_windows_msvc, x64_windows_msys, s390x, ios_x86_64
bazel build --crosstool_top=@bazel_tools//tools/cpp:toolchain --cpu=k8 modules/monitor:all 

# Per-module LLVM bitcode for Apollo, need to run in Apollo docker
# Ref: https://clang.llvm.org/docs/CommandGuide/clang.html
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/modules/monitor/monitor.cc -o /apollo/modules/monitor/monitor.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/civetweb/include/ /apollo/modules/dreamview/backend/hmi/hmi.cc -o /apollo/modules/dreamview/backend/hmi/hmi.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/modules/control/control.cc -o /apollo/modules/control/control.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/modules/canbus/canbus.cc -o /apollo/modules/canbus/canbus.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/eigen/ /apollo/modules/planning/planning.cc -o /apollo/modules/planning/planning.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/eigen/ /apollo/modules/routing/routing.cc -o /apollo/modules/routing/routing.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/eigen/ /apollo/modules/prediction/prediction.cc -o /apollo/modules/prediction/prediction.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/local_integ/ /apollo/modules/localization/localization.cc -o /apollo/modules/localization/localization.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/eigen/ -I /usr/local/include/pcl-1.7/ /apollo/modules/perception/perception.cc -o /apollo/modules/perception/perception.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/modules/third_party_perception/third_party_perception.cc -o /apollo/modules/third_party_perception/third_party_perception.bc

# LLVM bitcode for protocol buffer source code
clang -c -emit-llvm -std=c++11 -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/bazel-genfiles/modules/control/proto/pad_msg.pb.cc -o pad_msg.pb.bc
clang -c -emit-llvm -std=c++11 -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/bazel-genfiles/modules/control/proto/control_cmd.pb.cc -o control_cmd.pb.bc
clang -c -emit-llvm -std=c++11 -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/bazel-genfiles/modules/canbus/proto/chassis.pb.cc -o chassis.pb.bc
clang -c -emit-llvm -std=c++11 -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/bazel-genfiles/modules/localization/proto/localization.pb.cc -o localization.pb.bc
clang -c -emit-llvm -std=c++11 -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/bazel-genfiles/modules/planning/proto/planning.pb.cc -o planning.pb.bc
clang -c -emit-llvm -std=c++11 -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/bazel-genfiles/modules/control/proto/control_conf.pb.cc -o control_conf.pb.bc

clang -c -emit-llvm -std=c++11 -I /apollo/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/eigen/ /apollo/modules/common/vehicle_state/vehicle_state_provider.cc -o vehicle_state_provider.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ /apollo/modules/common/adapters/adapter_manager.cc -o adapter_manager.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles /apollo/modules/control/controller/controller_agent.cc -o controller_agent.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /apollo/bazel-genfiles/external/com_github_gflags_gflags/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/eigen/ /apollo/modules/common/apollo_app.cc -o apollo_app.bc

clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /apollo/bazel-genfiles/external/com_github_gflags_gflags/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/curlpp/include/ /apollo/modules/common/util/http_client.cc -o http_client.bc
clang -c -emit-llvm -std=c++11 -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/com_google_protobuf/src/ -I /apollo/bazel-genfiles/external/com_github_gflags_gflags/ -I /home/david/.cache/bazel/_bazel_david/540135163923dd7d5820f3ee4b306b32/external/ /apollo/modules/map/tools/proto_map_generator.c -o proto_map_generator.bc

# Ref: https://llvm.org/docs/GettingStarted.html
# Ref: https://stackoverflow.com/questions/9148890/how-to-make-clang-compile-to-llvm-ir
# clang preprocessor
clang -C -E $file.cc > $file.ii 

# Emit llvm bitcode 
clang -emit-llvm $file.cc -c -o $file.bc

# Emit llvm bitcode with debug option
clang -g -emit-llvm $file.cc -c -o $file.bc

# llvm bitcode with fastest-runtime optimze option
# Ref: https://clang.llvm.org/docs/CommandGuide/clang.html
clang -O3 -emit-llvm $file.cc -c -o $file.bc

# Clang IR with reduce-code-size optimze option
clang -Os -S -emit-llvm $file.cc -o $file.ll

# native assembly
clang $file.cc -S -o $file.s

# executable binary
clang $file.cc -o $file

# view bitcode
llvm-dis < $file.bc | cat > $file.ll
clang -S -emit-llvm $file.cc -o $file.ll

# bitcode to assembly
llc $file.bc -o $file.s

# assembly to executable
gcc $file.s -o $file

# Combine multiple bitcode files into one bitcode file using LLVM Gold Plugin
# Ref: https://llvm.org/docs/GoldPlugin.html
# Ref: https://github.com/SVF-tools/SVF/wiki/Install-LLVM-Gold-Plugin-on-Ubuntu
# Ref: https://stackoverflow.com/questions/9148890/how-to-make-clang-compile-to-llvm-ir
clang -flto -c $file1.cc -o $file1.bc
clang -flto -c $file2.cc -o $file2.bc
clang -flto -Wl,-plugin-opt=also-emit-llvm $file1.bc $file2.bc -o $file3

# generate “pruned” SSA form
opt -mem2reg $file.bc -o $file_ssa.bc

# convert “pruned” SSA form back to original
opt -reg2mem $file_ssa.bc -o $file.bc

# devirtualize bitcode (require at least LLVM 4.0)
# first two lines of command seem to give same bitcode
#clang -c -emit-llvm -flto -fwhole-program-vtables -I $include_dir $src_file -o $file.bc
#clang -c -emit-llvm -flto -fstrict-vtable-pointers -I $include_dir $src_file -o $file.bc
# same output from llvm-dis given above bitcode and the following bitcode
#opt -wholeprogramdevirt $file.bc -o $file_devirt.bc

# Ref: https://groups.google.com/forum/#!topic/llvm-dev/Z7O338-BYkQ
clang -c -fvisibility=hidden -emit-llvm -flto -fwhole-program-vtables -I $include_dir $src_file -o $file.bc
# Example
clang -c -fvisibility=hidden -emit-llvm -flto -std=c++11 -fwhole-program-vtables -I /apollo/ -I /home/tmp/ -I /apollo/bazel-genfiles -I $build_dir/external/com_google_protobuf/src/ -I /apollo/bazel-genfiles/external/com_github_gflags_gflags/ -I $build_dir/external/eigen/ -I /usr/local/include/pcl-1.7/ -I /usr/include/vtk-5.8/ -I $build_dir/external/curlpp/include/ -I $build_dir/external/ -I $build_dir/external/local_integ/ -I $build_dir/external/civetweb/include/ -I /usr/local/ipopt/include/coin/ -I $build_dir/external/gtest/googlemock/include/ /apollo/modules/control/controller/controller_agent.cc -o controller_agent.bc
opt -wholeprogramdevirt $file.bc -o $file_devirt.bc

# dump vtable
clang++ -Xclang -fdump-vtable-layouts -c -I $include_dir $file.bc > $file.vtable

# run llvm pass on llvm bitcode
# Ref: https://stackoverflow.com/questions/9791528/why-optimizations-passes-doesnt-work-without-mem2reg
opt -load $pass.so -$pass < $file.bc > $file_inst.bc

# run llvm pass in one command line
clang -Xclang -load -Xclang $pass.so $file.c

# Ref: https://llvm.org/docs/Passes.html
# generate per-function CFG (without function definition) into dot file
opt -dot-cfg-only $file.bc

# generate per-function CFG (with function definition) into dot file
opt -dot-cfg $file.bc

# generate call graph into dot file
opt -dot-callgraph $file.bc

# convert dot to pdf file
dot -Tpdf $file.dot -o $file.pdf
