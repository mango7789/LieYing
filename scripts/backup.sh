#!/bin/bash
docker exec -i lieying mysqldump -u root -p --databases lieying > lieying.sql
