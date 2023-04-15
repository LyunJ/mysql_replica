use book_test;

/**
    작가 1000명 등록
    작가 카테고리는 4종류를 골고루 가짐
    작가 이름은 md5함수로 무작위 생성
*/

DELIMITER ;;
CREATE PROCEDURE cd_book_author(IN dummy_count INTEGER)
BEGIN
    DECLARE i INTEGER DEFAULT 1;
    DECLARE book_author_max_id INTEGER DEFAULT 0;
    DECLARE BULK_INSERT_NUMBER INTEGER DEFAULT 100;

#     유저의 마지막 id값 추출
    SET book_author_max_id = (SELECT IFNULL(MAX(id),0) FROM book_author);

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

        INSERT INTO book_author (id, book_author_category_id, name)
        VALUES (book_author_max_id + i, floor(RAND()*4 + 1), substr(md5(rand()),1,15));

        SET i = i + 1;
        end while;
#     남은 INSERT 데이터 COMMIT
    COMMIT;
    SET AUTOCOMMIT=TRUE;

    SELECT CONCAT(i,'row insert complete');
end;;
DELIMITER ;

drop procedure cd_book_author;

# 1000명의 저자, 그림, 번역, 검수가들 등록
CALL cd_book_author(1000);
