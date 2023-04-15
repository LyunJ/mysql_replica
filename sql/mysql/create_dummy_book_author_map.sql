use book_test;

/**
  책 하나가 다수의 작가를 가질 수 있고, 저자는 무조건 최소 1개는 가져야한다.
  하나의 책에 작가를 무작위로 넣는 작업을 2회 실시한다
  그리고 book_author_map 테이블을 읽어 저자 카테고리의 작가를 가지지 않을 경우 추가해주는 작업을 실시한다
  */



INSERT IGNORE INTO book_author_map
SELECT bam.book_id,(select id from book_author where book_author_category_id = 1 order by rand() limit 1), null
FROM book_author_map bam left join book_author ba on bam.book_author_id = ba.id
GROUP BY bam.book_id
HAVING COUNT(case when ba.book_author_category_id = 1 then 1 end) = 0;
