SELECT bo.id AS order_id,
       bo.user_id AS user_id,
       bo.status AS order_status,
       u.name AS user_name,
       u.nick AS user_nick,
       ua.gis AS user_gis,
       bod.book_id AS book_id,
       b.title AS book_title,
       b.subtitle AS book_subtitle,
       bod.book_count AS book_order_count,
       bod.price AS book_order_price
FROM book_order bo
    LEFT JOIN user u on bo.user_id = u.id
    LEFT JOIN user_address ua on u.id = ua.user_id
    LEFT JOIN book_order_detail bod on bo.id = bod.book_order_id
    LEFT JOIN book b on bod.book_id = b.id
WHERE bo.id > 10000000
LIMIT 10;