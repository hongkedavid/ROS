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

# Start/Stop a particular module
# $module: dreamview, monitor, prediction, routing, planning, control
supervisorctl start/stop $module

# Check status of a particular module
supervisorctl status $module 
ps aux | grep $module

# Detach from the container
exit (or Ctrl-D)

# Stop and remove the docker container if needed
docker stop apollo_dev
docker container list
docker ps -aq -f status=exited
docker rm apollo_dev

# Remove docker instance and image
# Ref: https://stackoverflow.com/questions/17665283/how-does-one-remove-an-image-in-docker
# Ref: https://stackoverflow.com/questions/33907835/docker-error-cannot-delete-docker-container-conflict-unable-to-remove-reposito
docker container ls -a
docker rm $instance
docker images
docker rmi $image

# Backup docker iamge
# Ref: https://stackoverflow.com/questions/26707542/how-to-backup-restore-docker-image-for-deployment
docker save apolloauto/apollo:dev-x86_64-20180103_1300 | gzip -c > apollo_dev-x86_64-20180103_1300.tgz
gunzip -c apollo_dev-x86_64-20180103_1300.tgz | docker load

# Optional: enable incoming traffic to port 8888
sudo iptables -A INPUT -p tcp --dport 8888 -j ACCEPT
