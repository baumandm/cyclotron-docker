# Cyclotron on Docker

This repository contains a Docker Compose configuration for running Cyclotron.  It creates a Cyclotron container, a MongoDB container, and a MongoDB data volume.

    docker-compose up -d

## Running without Docker Compose

    docker build -t cyclotron .
    docker images
    docker run -d --name cyclotron -p 777:777 -p 8077:8077 cyclotron
    docker exec -it cyclotron /bin/bash
