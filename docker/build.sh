#!/bin/bash
docker build -f ./Dockerfile --build-arg GH_TOKEN=$(cat ../secret/github-token) -t agorum:latest .