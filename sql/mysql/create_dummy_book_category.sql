use book_test;

/**
  책 카테고리는 3 level 계층구조를 가지고 있고, level 마다 5개의 카테고리 데이터를 저장하고 있다.
    level마다 5개씩의 데이터를 가질 수 있도록 재귀 프로시저를 활용하였음.
  */

DELIMITER ;;
CREATE PROCEDURE cd_book_category(IN level INTEGER,IN dummy_per_level INTEGER,IN lv_counter INTEGER,IN parent_id_in INTEGER, INOUT uid INTEGER)
BEGIN
    DECLARE i INTEGER DEFAULT 0;

    WHILE i < dummy_per_level AND lv_counter < level DO
        if lv_counter = 0 then
            INSERT INTO book_category (id,parent_id, name)
            VALUES (uid,null,CONCAT('CATEGORY',uid));
        else
            INSERT INTO book_category (id, parent_id, name)
            VALUES (uid, parent_id_in,CONCAT('CATEGORY',uid) );
        end if ;

        SET uid = uid + 1;
        SET i = i + 1;
        CALL cd_book_category(3,5,lv_counter + 1,uid - 1,uid);
        end while ;
end;;
DELIMITER ;

drop procedure cd_book_category;

set @category_id = 1;
CALL cd_book_category(3,5,0,0,@category_id);

set autocommit = true;
set foreign_key_checks =1;

show variables like 'max_sp_recursion_depth';
set max_sp_recursion_depth = 3;