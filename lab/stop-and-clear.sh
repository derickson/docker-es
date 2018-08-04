#!/bin/sh

# echo "disabled!!!"
docker-compose down
# docker-compose -f docker-compose-startup.yml down
rm .env
rm -rf data
rm -rf certificates