#!/bin/bash

docker run -d --privileged --network external0 --ip 10.111.223.23 --name client1 --volume $(pwd)/client1:/data fedoratest /data/client1_setup.sh
docker run -d --privileged --network external1 --ip 10.111.224.23 --name client2 --volume $(pwd)/client2:/data fedoratest /data/client2_setup.sh
