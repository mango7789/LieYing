#!/bin/bash
docker run -d --runtime=runc --name lieying-redis -p 6379:6379 \
    -v $(pwd)/redis.conf:/usr/local/etc/redis/redis.conf redis:7 redis-server /usr/local/etc/redis/redis.conf