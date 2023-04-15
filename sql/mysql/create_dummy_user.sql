/**
  유저 수 : 10만 명
  */

DELIMITER ;;
CREATE PROCEDURE cd_user(IN dummy_count INTEGER)
BEGIN
    DECLARE i INTEGER DEFAULT 1;
    DECLARE user_max_id INTEGER DEFAULT 0;
    DECLARE BULK_INSERT_NUMBER INTEGER DEFAULT 50000;

#     유저의 마지막 id값 추출
    SET user_max_id = (SELECT IFNULL(MAX(id),1) FROM user);

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

        INSERT INTO user (id, name, nick)
        VALUES (user_max_id + i, CONCAT('NAME', user_max_id + i),CONCAT('NICK', user_max_id + i));

        SET i = i + 1;
        end while;
#     남은 INSERT 데이터 COMMIT
    COMMIT;
    SET AUTOCOMMIT=TRUE;

    SELECT CONCAT(i,'row insert complete');
end;;
DELIMITER ;

call cd_user(100000);