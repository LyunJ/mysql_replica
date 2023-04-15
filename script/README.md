# 도커 실행을 도와주는 스크립트 파일

## docker_start.sh
docker compose 백그라운드로 실행
```docker compose up -d```

## docker_bash_exec.sh
`docker ps`의 컨테이너 리스트에서 하나를 선택해 bash에 접속할 수 있는 스크립트

## docker_load_dump.sh
mysql-source에 덤프 파일 load하는 스크립트
```
docker exec -i mysql-source-mysql-source-1 sh -c 'exec mysql -uroot -p"$MYSQL_ROOT_PASSWORD"' < $1
```

## dockerfile_init.sh
도커를 실행 후 Replica 설정을 위해 실행해야하는 스크립트

## docker_mysql_dump.sh
playground 데이터베이스 백업파일 생성

## docker_mysql_restore.sh
playground 데이터베이스 복원