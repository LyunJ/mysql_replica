#!/bin/zsh

docker exec -i datapipeline-mysql-source-1 sh -c 'exec mysql -u root -ppassword datapipeline < /var/lib/mysql-files/backup.sql'
