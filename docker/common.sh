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
