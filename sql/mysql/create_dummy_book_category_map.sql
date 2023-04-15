use book_test;

/**
  책마다 카테고리들을 반드시 갖는다.
  책마다 가질 수 있는 카테고리는 1~5개다.
  */

DELIMITER ;;
CREATE PROCEDURE cd_book_category_map(IN dummy_count INTEGER)
BEGIN
    DECLARE i INTEGER DEFAULT 1;
    DECLARE BULK_INSERT_NUMBER INTEGER DEFAULT 100000;
    DECLARE MAX_BOOK_CATEGORY_ID INTEGER DEFAULT 0;
    DECLARE MAX_CATEGORY_COUNT INTEGER DEFAULT 4;
    DECLARE category_count_standard INTEGER DEFAULT 0;
    DECLARE j INTEGER DEFAULT 0;

    SET MAX_BOOK_CATEGORY_ID = (select IFNULL(MAX(id),0) FROM book_category);

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

        SET category_count_standard = FLOOR((RAND() * MAX_CATEGORY_COUNT) + 1);

        WHILE j < category_count_standard DO
            INSERT IGNORE INTO book_category_map (book_id, book_category_id)
            VALUES (i,FLOOR(RAND() * MAX_BOOK_CATEGORY_ID));

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

drop procedure cd_book_category_map;


call cd_book_category_map(1560000);