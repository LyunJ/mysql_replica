use book_test;

/**
  데이터 저장 기간 : 201001 ~ 20221230
  1달 간 저장되는 책 데이터 : 1만 개
  한국서적과 외국서적 비율 : 10:1
  책 수량 : 3000개 이하
  */

DELIMITER ;;
CREATE PROCEDURE cd_book(IN dummy_count INTEGER)
BEGIN
    DECLARE i INTEGER DEFAULT 1;
    DECLARE book_max_id INTEGER DEFAULT 0;
    DECLARE BULK_INSERT_NUMBER INTEGER DEFAULT 10000;
    DECLARE STANDARD_DATE DATETIME DEFAULT STR_TO_DATE('20100101', '%Y%m%d');

#     유저의 마지막 id값 추출
    SET book_max_id = (SELECT IFNULL(MAX(id),0) FROM book);

    SET AUTOCOMMIT = FALSE;
    WHILE i < dummy_count + 1 DO
#         10000개마다 COMMIT 하여 메모리 과적 방지
        IF i % BULK_INSERT_NUMBER = 1 then
            START TRANSACTION ;
        end if;
        IF i % BULK_INSERT_NUMBER = 0 then
            COMMIT;

            # 1만 개 등록 시 기준 월을 1달 앞당긴다.
            SET STANDARD_DATE = ADDDATE(STANDARD_DATE,INTERVAL 1 MONTH);
            select CONCAT(i,'row insert complete');
        end if;

        INSERT INTO book (id, translate_book_id, title, subtitle, price, isbn, publication_date, page, width, height, depth, weight, book_count, book_type)
        VALUES (book_max_id + i, null, CONCAT('TITLE',i),CONCAT('SUBTITLE',i),RAND()*40000 + 5000,SUBSTR(md5(CONCAT('TITLE',i)),1,13),FROM_UNIXTIME(UNIX_TIMESTAMP(STANDARD_DATE) + FLOOR(0 + (RAND() * 2160000))),RAND()*1000 + 100,RAND()*100 + 200,RAND()*100 + 300, RAND()*50 + 10, RAND()*300 + 50, RAND()*3000+1,IF(RAND()*10 > 9,'FOREIGNER','KOREAN') );

        SET i = i + 1;
        end while;
#     남은 INSERT 데이터 COMMIT
    COMMIT;
    SET AUTOCOMMIT=TRUE;

    SELECT CONCAT(i,'row insert complete');
end;;
DELIMITER ;

drop procedure cd_book;

# 1년에 1만권의 책이 등록된다고 가정 총 13년간의 책 데이터 등록
CALL cd_book(1560000);

set autocommit = true;