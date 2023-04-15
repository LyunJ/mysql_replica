CREATE TABLE `user` (
	`id`	INTEGER	NOT NULL,
	`name`	VARCHAR(20)	NOT NULL,
	`nick`	VARCHAR(20)	NOT NULL,
	`create_dt`	DATETIME	NOT NULL	DEFAULT now(),
	`update_dt`	DATETIME	NOT NULL	DEFAULT now(),
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (id)
);

CREATE TABLE `user_address` (
	`id`	INTEGER	NOT NULL,
	`user_id`	INTEGER	NOT NULL,
	`address`	VARCHAR(100)	NOT NULL,
	`gis`	POINT	NOT NULL,
	`create_dt`	DATETIME	NOT NULL	DEFAULT now(),
	`update_dt`	DATETIME	NOT NULL	DEFAULT now(),
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (user_id) REFERENCES `user` (id)
);

CREATE TABLE `book` (
	`id`	INTEGER	NOT NULL,
	`translate_book_id`	INTEGER	NOT NULL,
	`title`	VARCHAR(50)	NOT NULL,
	`subtitle`	VARCHAR(50)	NULL,
	`price`	INTEGER	NOT NULL,
	`isbn`	INTEGER	NULL,
	`publication_date`	date	NULL,
	`page`	INTEGER	NULL,
	`width`	INTEGER	NULL,
	`height`	INTEGER	NULL,
	`depth`	INTEGER	NULL,
	`weight`	INTEGER	NULL,
	`book_count`	INTEGER	NOT NULL	DEFAULT 1,
	`book_type`	ENUM('KOREAN','FOREINER')	NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (translate_book_id) REFERENCES `book` (id)
);

CREATE TABLE `book_category` (
	`id`	INTEGER	NOT NULL,
	`parent_id`	INTEGER	NOT NULL,
	`name`	VARCHAR(20)	NOT NULL,
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (parent_id) REFERENCES `book_category` (id)
);

CREATE TABLE `book_author_category` (
	`id`	INTEGER	NOT NULL,
	`name`	VARCHAR(20)	NOT NULL,
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (id)
);

CREATE TABLE `book_author` (
	`id`	INTEGER	NOT NULL,
	`book_author_category_id`	INTEGER	NOT NULL,
	`name`	VARCHAR(20)	NOT NULL,
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (book_author_category_id) REFERENCES `book_author_category` (id)
);

CREATE TABLE `book_category_map` (
	`book_id`	INTEGER	NOT NULL,
	`book_category_id`	INTEGER	NOT NULL,
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (book_id,book_category_id),
	FOREIGN KEY (book_id) REFERENCES `book` (id),
	FOREIGN KEY (book_category_id) REFERENCES `book_category` (id)
);

CREATE TABLE `book_author_map` (
	`book_id`	INTEGER	NOT NULL,
	`book_author_id`	INTEGER	NOT NULL,
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (book_id, book_author_id),
	FOREIGN KEY (book_id) REFERENCES `book` (id),
	FOREIGN KEY (book_author_id) REFERENCES `book_author` (id)
);

CREATE TABLE `book_detail` (
	`book_id`	INTEGER	NOT NULL,
	`information`	BLOB	NULL,
	`summary`	BLOB	NULL,
	`trailer_url`	VARCHAR(500)	NULL,
	`book_index`	BLOB	NULL,
	`book_review`	BLOB	NULL,
	PRIMARY KEY (book_id),
	FOREIGN KEY (book_id) REFERENCES `book` (id)
);

CREATE TABLE `book_order` (
	`id`	INTEGER	NOT NULL,
	`user_id`	INTEGER	NOT NULL,
	`create_dt`	DATETIME	NOT NULL	DEFAULT now(),
	`status`	ENUM('PROCESSING','DONE')	NOT NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (user_id) REFERENCES `user` (id)
);

CREATE TABLE `book_order_detail` (
	`book_order_id`	INTEGER	NOT NULL,
	`book_id`	INTEGER	NOT NULL,
	`price`	INTEGER	NOT NULL,
	`book_count`	INTEGER	NOT NULL,
	PRIMARY KEY (book_order_id, book_id),
	FOREIGN KEY (book_order_id) REFERENCES `book_order` (id),
	FOREIGN KEY (book_id) REFERENCES `book` (id)
);

CREATE TABLE `book_review` (
	`id`	INTEGER	NOT NULL,
	`book_order_id`	INTEGER	NOT NULL,
	`book_id`	INTEGER	NOT NULL,
	`score`	TINYINT	NOT NULL,
	`keyword`	ENUM('집중돼요','도움돼요','쉬웠어요','최고에요','추천해요')	NULL,
	`content`	VARCHAR(1000)	NOT NULL,
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (book_order_id, book_id) REFERENCES `book_order_detail` (book_order_id, book_id)
);

CREATE TABLE `book_review_image` (
	`id`	INTEGER	NOT NULL,
	`book_review_id`	INTEGER	NOT NULL,
	`image_url`	VARCHAR(500)	NOT NULL,
	`image_order`	TINYINT	NULL,
	`delete_dt`	DATETIME	NULL,
	PRIMARY KEY (id),
	FOREIGN KEY (book_review_id) REFERENCES `book_review` (id)
);