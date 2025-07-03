#!/bin/bash
docker exec -i lieying mysqldump -u root -p --default-character-set=utf8 --databases lieying > lieying.sql
