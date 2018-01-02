# List running containers 
sudo docker container list

# Attach to a running container 
sudo docker attach apollo_dev
 
# Detach from a running container
exit

# Run a container
sudo docker exec -t -i 04f16cf35fae /bin/bash
