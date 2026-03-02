#!/bin/bash

# v1.00
HOST=172.17.0.1
HOST=127.0.0.0

echo "commonports on host=$HOST"

for port in 22 80 443 2200 2222 2375 2376 5355 8080 3000 5000 9000; do
  nc -zv -w 1 $HOST $port 2>&1
done