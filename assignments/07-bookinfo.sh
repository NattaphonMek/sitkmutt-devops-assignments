#!/bin/sh

set -e

docker build -t ratings ../ratings/
docker build -t reviews ../reviews/
docker build -t details ../details/
docker build -t productpage ../productpage/

docker run --name ratings -p 8080:8080 -d ratings
docker run --name details -p 8081:8081 -d details
docker run --name reviews -e 'RATINGS_SERVICE=ratings_url' -p 8082:9080 -d reviews
docker run --name mongodb -p 27017:27017 -v /home/nattaphon_mek/ratings/databases:/docker-entrypoint-initdb.d bitnami/mongodb:5.0.2-debian-10-r2
docker run --name productpage --link reviews:reviews --link ratings:ratings --link reviews:reviews --link details:details -e 'RATINGS_HOSTNAME=ratings_url' -e 'DETAILS_HOSTNAME=details_url' -e 'REVIEWS_HOSTNAME=reviews_url' -p 8083:8083 -d productpage