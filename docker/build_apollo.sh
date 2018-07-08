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

# Build test
bazel build modules/control/tools:control_tester

# Build fail in dreamview and perception
# Related issue: https://github.com/ApolloAuto/apollo/issues/2629
bazel build modules/perception:all
bazel build modules/dreamview:all

# Build Apollo ROS platform
# Ref: https://github.com/ApolloAuto/apollo/blob/d49f5957f2aa027a509825b08b60ddb3e51d5331/docs/quickstart/apollo_1_0_quick_start_developer.md
# Ref: https://answers.ros.org/question/59031/how-do-i-limit-the-number-of-cores-used-in-the-build-process-by-catkin/
export ROS_PARALLEL_JOBS=-j64
cd ros
bash build.sh build
cd /apollo/apollo-platform-2.1.2/ros/build_isolated/roscpp && /apollo/apollo-platform-2.1.2/ros/install/ros_x86_64/env.sh make cmake_check_build_system
cd /apollo/apollo-platform-2.1.2/ros/build_isolated/roscpp && /apollo/apollo-platform-2.1.2/ros/install/ros_x86_64/env.sh make -j64 -l64
