use book_test;

/**
  book_order_detail 테이블에 존재하는 primary key 에 해당하는 유저만 리뷰 작성 가능
  커서를 사용하여 book_order_detail 테이블을 스캔하고, 필요한 데이터들을 추출하여 리뷰 데이터 작성
  */

DELIMITER ;;
CREATE PROCEDURE cd_book_review()
BEGIN
    DECLARE i INTEGER DEFAULT 1;
    DECLARE v_no_more_data INTEGER DEFAULT 0;
    DECLARE v_book_order_id INTEGER DEFAULT 0;
    DECLARE v_book_id INTEGER DEFAULT 0;
    DECLARE v_create_dt DATETIME DEFAULT STR_TO_DATE('2023-01-01','%Y-%m-%d');
    DECLARE BULK_INSERT_NUMBER INTEGER DEFAULT 100000;

#   같은 리뷰 id를 공유하는 리뷰와 리뷰 이미지 데이터를 한 사이클에 저장하기 위해 i를 증가시켜줄 반복문이 필요했고,
#   따라서 INSERT ... SELECT 가 아닌 CURSOR를 사용하기로 하였음
    DECLARE v_book_order_list CURSOR FOR
	SELECT book_order_id,book_id,create_dt
	FROM book_order_detail bod left join book_order bo on bod.book_order_id = bo.id
    WHERE bod.book_id % 4 = 0;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_more_data = 1;

    SET AUTOCOMMIT = FALSE;
    OPEN v_book_order_list;
    REPEAT
#         100000개마다 COMMIT 하여 메모리 과적 방지
        IF i % BULK_INSERT_NUMBER = 1 then
            START TRANSACTION ;
        end if;
        IF i % BULK_INSERT_NUMBER = 0 then
            COMMIT;
            select CONCAT(i,'row insert complete');
        end if;

        FETCH v_book_order_list INTO v_book_order_id,v_book_id,v_create_dt;

        INSERT INTO book_review (id,book_order_id, book_id, score, keyword, content, create_dt)
        VALUES (i,v_book_order_id,v_book_id,FLOOR(RAND() * 3) + 1,CASE FLOOR(RAND() * 5)
                WHEN 0 THEN '집중돼요'
                WHEN 1 THEN '도움돼요'
                WHEN 2 THEN '쉬웠어요'
                WHEN 3 THEN '최고에요'
                WHEN 4 THEN '추천해요' END,
                SUBSTR(MD5(RAND()),1,20),
                FROM_UNIXTIME(UNIX_TIMESTAMP(v_create_dt) + FLOOR(1 + (RAND() * 15552000))));

        IF i % 2 = 0 THEN
            INSERT INTO book_review_image (book_review_id, image_url, image_order)
            VALUES (i,CONCAT(MD5(RAND()),MD5(RAND())),1);
        end if ;

        SET i = i + 1;
        UNTIL v_no_more_data END REPEAT ;
#     남은 INSERT 데이터 COMMIT
    COMMIT;
    SET AUTOCOMMIT=TRUE;

    SELECT CONCAT(i,'row insert complete');
end;;
DELIMITER ;

DROP PROCEDURE cd_book_review;

call cd_book_review();
