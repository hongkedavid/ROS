# Build individual modules
bazel build modules/monitor:all
bazel build modules/control:all
bazel build modules/canbus:all
bazel build modules/planning:all
bazel build modules/prediction:all
bazel build modules/localization:all
bazel build modules/routing:all
bazel build modules/third_party_perception:all
bazel build modules/drivers/conti_radar:all
bazel build modules/calibration/lidar_ex_checker:all
bazel build modules/calibration/republish_msg:all

# Build fail in dreamview and perception
bazel build modules/perception:all
bazel build modules/dreamview:all
