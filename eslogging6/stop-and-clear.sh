#!/bin/sh

# echo "disabled!!!"
docker-compose down
rm .env
rm -rf data
rm -rf certificates