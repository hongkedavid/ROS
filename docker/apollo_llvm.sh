# clang and llvm setup in docker instance
# Ref: https://github.com/whoenig/ros-clang-instrumentation
sudo apt-get update
sudo apt install -y llvm-3.8-dev libclang-3.8-dev clang

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

# convert LLVM IR into SSA form
opt -mem2reg $file.bc -o $file_ssa.bc

# convert SSA form back to original
opt -reg2mem $file_ssa.bc -o $file.bc

# run llvm pass on llvm bitcode
# Ref: https://stackoverflow.com/questions/9791528/why-optimizations-passes-doesnt-work-without-mem2reg
opt -load $pass.so -$pass < $file.bc > $file_inst.bc

# run llvm pass in one command line
clang -Xclang -load -Xclang $pass.so $file.c

# generate per-function CFG into dot file
opt -dot-cfg-only $file.bc
