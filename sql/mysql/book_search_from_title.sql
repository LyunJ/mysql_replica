use book_test;

SELECT id, title FROM book WHERE title like '%12%';

show variables like 'ngram_token_size';