use book_test;

# 책 제목 검색을 위한 ngram index 등록
# 전문 검색 인덱스를 짧은 문장에 적용 시 like 보다 속도가 떨어지는 현상 발생
ALTER TABLE book ADD FULLTEXT INDEX fx_msg(title) WITH PARSER ngram;