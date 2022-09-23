#!/bin/bash

docker run -d --privileged --network external0 -ip 10.111.223.23 --name client1 --volume client:/data fedoratest
