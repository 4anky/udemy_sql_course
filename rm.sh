#!/bin/bash
# This script removes all docker containers (ran and stopped)

# Get a list of all container IDs
container_ids=$(docker ps -aq)

# Check if there are any containers to remove
if [ -z "$container_ids" ]; then
  echo "No containers found."
else
  # Remove each container
  for container_id in $container_ids; do
    echo "Removing container: $container_id"
    docker stop $container_id
    docker rm $container_id
  done

  echo "All containers removed."
fi
