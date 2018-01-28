# Build individual modules
bazel build modules/monitor:all
bazel build modules/control:all
bazel build modules/canbus:all
bazel build modules/planning:all
bazel build modules/prediction:all
bazel build modules/localization:all
bazel build modules/dreamview:all
