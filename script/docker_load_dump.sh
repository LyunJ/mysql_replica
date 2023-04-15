#!/bin/zsh
docker exec -i datapipeline-mysql-source-1 sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -Dapplication' < $1