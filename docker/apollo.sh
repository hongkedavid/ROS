# Ref: https://github.com/ApolloAuto/apollo/blob/master/README.md
# Don't use command start or attach command for docker

# Start Apollo docker container
bash docker/scripts/dev_start.sh

# Attach to the container
bash docker/scripts/dev_into.sh

# Within docker container
# Start module monitor
bash scripts/bootstrap.sh

# Download demo rosbag
bash ./docs/demo_guide/rosbag_helper.sh download 

# Set up ROS environment
source /apollo/bazel-apollo/external/ros/setup.bash

# Relay demo rosbag 
rosbag play -l ./docs/demo_guide/demo_2.0.bag

# Detach from the container
exit (or Ctrl-D)
