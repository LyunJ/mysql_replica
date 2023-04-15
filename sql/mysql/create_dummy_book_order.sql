USE book_test;

/**
  책 주문 건수 : 5000만 건
  주문당 책 주문량 : 1억 2천만 건
  주문 발생 일자 : 2023년을 시작으로 1년동안 발생
  무작위로 선택된 유저가 무작위로 선택된 책을 N개(N <= 4) 주문
  */

DELIMITER ;;
CREATE PROCEDURE cd_book_order(IN dummy_count INTEGER)
BEGIN
    DECLARE i INTEGER DEFAULT 1;
    DECLARE j INTEGER DEFAULT 0;
    DECLARE BULK_INSERT_NUMBER INTEGER DEFAULT 1000000;

    DECLARE MAX_BOOK_ORDERING_COUNT INTEGER DEFAULT 3;
    DECLARE random_book_ordering_count INTEGER DEFAULT 0;

    DECLARE random_book_id INTEGER DEFAULT 0;
    DECLARE book_price INTEGER DEFAULT 0;
    DECLARE book_order_count INTEGER DEFAULT 0;


    SET AUTOCOMMIT = FALSE;
    WHILE i < dummy_count + 1 DO
#         100000개마다 COMMIT 하여 메모리 과적 방지
        IF i % BULK_INSERT_NUMBER = 1 then
            START TRANSACTION ;
        end if;
        IF i % BULK_INSERT_NUMBER = 0 then
            COMMIT;
            select CONCAT(i,'row insert complete');
        end if;

        INSERT IGNORE INTO book_order (id, user_id, status)
        VALUES (i,FLOOR((RAND() * 100000) + 1),IF(RAND() * 10 > 9, 'PROCESSING','DONE'));


        SET random_book_ordering_count = FLOOR(RAND() * MAX_BOOK_ORDERING_COUNT) + 1;
        WHILE j < random_book_ordering_count DO
            SET random_book_id = FLOOR((RAND() * 1560000) + 1);
            SET book_price = (SELECT price FROM book WHERE id=random_book_id);
            SET book_order_count = (SELECT book_count FROM book WHERE id=random_book_id);

            INSERT IGNORE INTO book_order_detail (book_order_id, book_id, price, book_count)
            VALUES (i, random_book_id,book_price,FLOOR((RAND() * book_order_count) + 1));

            SET j = j + 1;
            end while ;

        SET j = 0;
        SET i = i + 1;
        end while;
#     남은 INSERT 데이터 COMMIT
    COMMIT;
    SET AUTOCOMMIT=TRUE;

    SELECT CONCAT(i,'row insert complete');
end;;
DELIMITER ;

drop procedure cd_book_order;

# 메모리 과적 방지로 634mb ~ 830mb 사이에서 메모리 사용량이 놀았음.
call cd_book_order(156000000);

# create_dt를 2023년 중의 랜덤한 날짜로 변환
UPDATE book_order SET create_dt = FROM_UNIXTIME(UNIX_TIMESTAMP(STR_TO_DATE('20230101', '%Y%m%d')) + FLOOR(0 + (RAND() * 31104000)));