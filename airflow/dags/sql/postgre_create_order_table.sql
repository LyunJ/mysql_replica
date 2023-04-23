CREATE TABLE IF NOT EXISTS book_order (
    order_id INTEGER,
    user_id INTEGER,
    order_status enum_order_status,
    user_name VARCHAR(20),
    user_nick VARCHAR(20),
    user_gis GEOMETRY,
    book_id INTEGER,
    book_title VARCHAR(50),
    book_subtitle VARCHAR(50),
    book_order_count INTEGER,
    book_order_price INTEGER
);