# Install docker-ce at https://docs.docker.com/install/linux/docker-ce/ubuntu/
# Add user into docker group if needed, need to re-login to be effective
# Ref: https://askubuntu.com/questions/136788/how-do-i-list-the-members-of-a-group
# Ref: https://docs.docker.com/engine/installation/linux/linux-postinstall/#manage-docker-as-a-non-root-user
getent group docker
sudo usermod -aG docker $USER

# List running containers 
docker container list

# Attach to a running container 
docker attach $container_name
 
# Detach from a running container
exit

# Run a container
docker exec -t -i $container_name /bin/bash

# Lista all create containers
docker ps -a

# List all exited containers
docker ps -a -q -f status=exited

# Remove dangling docker images
docker rmi $(docker images -f "dangling=true" -q)

# Remove exited containers, use with caution
docker rm -v $(docker ps -a -q -f status=exited)

# Remove dangling volume
# Ref: https://forums.meteor.com/t/low-disk-space-docker-container-increasing-in-size-everyday/24424/8
docker volume rm $(docker volume ls -qf dangling=true)
