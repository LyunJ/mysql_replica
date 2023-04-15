/**
  유저의 주소는 랜덤 위치좌표로 대체
  주소명은 md5로 생성된 문자열로 대체하였음

  랜덤 위치좌표는 위도 (38.61 - 33.11), 경도 (131.87 - 124.60) 사이에서 선택
  */

DELIMITER ;;
CREATE PROCEDURE cd_user_address(IN dummy_count INTEGER)
BEGIN
    DECLARE i INTEGER DEFAULT 1;
    DECLARE user_address_max_id INTEGER DEFAULT 0;
    DECLARE BULK_INSERT_NUMBER INTEGER DEFAULT 50000;

#     유저의 마지막 id값 추출
    SET user_address_max_id = (SELECT IFNULL(MAX(id),1) FROM user_address);

    SET AUTOCOMMIT = FALSE;
    WHILE i < dummy_count + 1 DO
#         50000개마다 COMMIT 하여 메모리 과적 방지
        IF i % BULK_INSERT_NUMBER = 1 then
            START TRANSACTION ;
        end if;
        IF i % BULK_INSERT_NUMBER = 0 then
            COMMIT;
            select CONCAT(i,'row insert complete');
        end if;

        INSERT INTO user_address (id, user_id, address, gis)
        VALUES (i,user_address_max_id + i,MD5(RAND()),POINT(RAND()*(38.61 - 33.11) + 33.11,RAND()*(131.87 - 124.60) + 124.60));

        SET i = i + 1;
        end while;
#     남은 INSERT 데이터 COMMIT
    COMMIT;
    SET AUTOCOMMIT=TRUE;

    SELECT CONCAT(i,'row insert complete');
end;;
DELIMITER ;


call cd_user_address(100000);