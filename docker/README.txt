# Build 

docker build -t gigatec/ubuntu-14.04-dev -f ./Dockerfile .
docker build -t gigatec/ubuntu-14.04-dev -f ./Dockerfile.001 ../..
docker build -t gigatec/ubuntu-14.04-dev -f ./Dockerfile.002 ..

# Upgrade

docker run --name upgrade.dev gigatec/ubuntu-16.04-php7.0
docker exec -ti upgrade.dev bash --login # ds-root upgrade
docker commit -m "Install php-xdebug" upgrade.dev gigatec/ubuntu-16.04-php7.0

# Show History

docker history gigatec/ubuntu-16.04-php7.0

# Restore old version

docker tag 4b82e0b30929 gigatec/ubuntu-16.04-php7.0

# Push to Docker Hub

docker push gigatec/ubuntu-16.04-php7.0

# Remove Docker Image

docker rm upgrade.dev
