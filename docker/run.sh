#!/bin/bash
eval $(docker-machine env)
docker run --network=office --name=agorum -d -p 80:80 -p 443:443 -v /mnt/sda1/data/agorum:/opt/agorum/data -d agorum agorum-start
