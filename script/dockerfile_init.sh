#!/bin/bash

echo "===============MYSQL REPLICA INIT START=================="

docker exec -i datapipeline-mysql-source-1 mysql -h 172.20.0.2 --protocol=tcp -u root -ppassword -D application < ./sql/create_replica_user.sql
docker exec -i datapipeline-mysql-replica1-1 mysql -h 172.20.0.5 --protocol=tcp -u root -ppassword -D application < ./sql/start_replication.sql
docker exec -i datapipeline-mysql-replica2-1 mysql -h 172.20.0.4 --protocol=tcp -u root -ppassword -D application < ./sql/start_replication.sql
docker exec -i datapipeline-mysql-replica3-1 mysql -h 172.20.0.3 --protocol=tcp -u root -ppassword -D application < ./sql/start_replication.sql