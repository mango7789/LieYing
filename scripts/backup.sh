#!/bin/bash
docker exec -e MYSQL_PWD=lieying lieying \
  mysqldump -u root --default-character-set=utf8mb4 --databases lieying > lieying.sql
