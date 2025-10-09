#!/bin/bash

# Load Docker image
sudo docker load < webapp.tar

# Stop & remove any existing container
sudo docker stop webapp 2>/dev/null
sudo docker rm webapp 2>/dev/null

# Run container
sudo docker run -d --name webapp -p 80:80 codecrafters-webapp
