# Ref: https://github.com/ApolloAuto/apollo/blob/master/README.md
# Don't use command start or attach command for docker

# Start Apollo docker container
bash docker/scripts/dev_start.sh

# Attach to the container
bash docker/scripts/dev_into.sh

# Within docker container
# Start ROS and monitor/dreamview
# Tune master timeout value if needed (ref: https://github.com/ApolloAuto/apollo/issues/2500)
bash scripts/bootstrap.sh

# Download demo rosbag
bash ./docs/demo_guide/rosbag_helper.sh download 

# Set up ROS environment
# Ref: https://github.com/ApolloAuto/apollo/issues/181
source /apollo/bazel-apollo/external/ros/setup.bash

# Relay demo rosbag and go to http://localhost:8888
rosbag play -l ./docs/demo_guide/demo_2.0.bag

# Stop module monitor
bash scripts/bootstrap.sh stop

# Stop a particular module
supervisorctl stop $module

# Detach from the container
exit (or Ctrl-D)

# Stop and remove the docker container if needed
sudo docker stop apollo_david_dev
sudo docker container list
sudo docker ps -aq -f status=exited
sudo docker rm apollo_david_dev

# Optional: enable incoming traffic to port 8888
sudo iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
