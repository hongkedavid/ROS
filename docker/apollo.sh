# Ref: https://github.com/ApolloAuto/apollo/blob/master/README.md
# Don't use command start or attach command for docker

# Start Apollo docker container
bash docker/scripts/dev_start.sh

# Attach to the container
bash docker/scripts/dev_into.sh

# Detach from the container
exit (or Ctrl-D)

# Start module monitor
bash scripts/bootstrap.sh

# Download demo rosbag
bash ./docs/demo_guide/rosbag_helper.sh download 

# Relay demo rosbag 
rosbag play -l ./docs/demo_guide/demo_2.0.bag
