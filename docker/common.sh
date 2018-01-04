# List running containers 
sudo docker container list

# Attach to a running container 
sudo docker attach $container_name
 
# Detach from a running container
exit

# Run a container
sudo docker exec -t -i $container_name /bin/bash
