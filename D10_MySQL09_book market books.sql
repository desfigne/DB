/*================================================================================================================================================
==================================================================================================================================================

	Day10_실습
    
==================================================================================================================================================
=================================================================================================================================================*/

/*________________________________________________________________________________________________________________________________________________

	book_market_books : 도서 테이블
	book_market_cart : 장바구니 테이블
	book_market_member : 회원 테이블
	** 테이블 별 레파지토리 3개 생성 필요

-------------------------------------------------------------------------------------------------------------------------------------------------*/

use hrdb2019;
select database();
show tables;

/*------------------------------------------------------------------------------------------------------------------------------------------------

	- 도서 테이블 (book_market_books)
	ㄴ 도서 아이디 (bks_id) / 도서 카테고리 (bks_category) / 도서 이름 (bks_title) / 도서 작가 (bks_author) / 도서 출판일 (bks_date) / 도서 판매가 (bks_price)

	- 회원 테이블 (book_market_member)
	ㄴ 고객 이름 (mbr_name) / 연락처 (mbr_phone) / 주소지 (mbr_address)

	- 장바구니 테이블 (book_market_cart)
	ㄴ 주문 아이디 (crt_id) / 주문 도서 아이디 (crt_bks_id) / 주문 회원 아이디 (crt_mbr_id) / 주문 도서 수량 (crt_amount) / 주문 도서별 총금액 (crt_each_total_price)

-------------------------------------------------------------------------------------------------------------------------------------------------*/

create table book_market_books(
	bks_id 					char(8)			primary key, -- 트리거로 "ISBN1234" 형식 지정
	bks_category 			varchar(10)		not null,
	bks_title 				varchar(150)	not null,
	bks_author 				varchar(10)		not null,
	bks_date 				datetime 		not null,
	bks_price 				int
);

create table book_market_member(
	mbr_id 					varchar(8)		primary key,
	mbr_name 				varchar(10)		not null,
	mbr_phone 				varchar(20)		not null,
	mbr_address 			varchar(200)
);

create table book_market_cart(
	crt_id 					char(8)			primary key,
	crt_amount 				int,
	crt_price_each_total 	int,
	crt_bks_id 				char(8),
	crt_mbr_id 				char(8),
	constraint fk_bks_crt_bks_id 	foreign key(crt_bks_id)
	                                references book_market_books(bks_id),
	constraint fk_bks_crt_mbr_id 	foreign key(crt_mbr_id)
	                                references book_market_member(mbr_id)
);

drop table book_market_cart;
drop table book_market_member;
drop table book_market_books;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER trg_books_before_insert
BEFORE INSERT ON book_market_books
FOR EACH ROW
BEGIN
  DECLARE seq INT;
  IF NEW.bks_id IS NULL OR NEW.bks_id = '' THEN
    SELECT IFNULL(MAX(CAST(SUBSTRING(bks_id,5) AS UNSIGNED)),0) + 1
      INTO seq
      FROM book_market_books;
    SET NEW.bks_id = CONCAT('ISBN', LPAD(seq,4,'0'));
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_member_before_insert
BEFORE INSERT ON book_market_member
FOR EACH ROW
BEGIN
  DECLARE seq INT;
  IF NEW.mbr_id IS NULL OR NEW.mbr_id = '' THEN
    SELECT IFNULL(MAX(CAST(SUBSTRING(mbr_id,4) AS UNSIGNED)),0) + 1
      INTO seq
      FROM book_market_member;
    SET NEW.mbr_id = CONCAT('MBR', LPAD(seq,5,'0'));
  END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_cart_before_insert
BEFORE INSERT ON book_market_cart
FOR EACH ROW
BEGIN
  DECLARE seq INT;
  IF NEW.crt_id IS NULL OR NEW.crt_id = '' THEN
    SELECT IFNULL(MAX(CAST(SUBSTRING(crt_id,4) AS UNSIGNED)),0) + 1
      INTO seq
      FROM book_market_cart;
    SET NEW.crt_id = CONCAT('CRT', LPAD(seq,5,'0'));
  END IF;
END$$
DELIMITER ;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

SELECT * FROM book_market_books;

INSERT INTO book_market_books (bks_category, bks_title, bks_author, bks_date, bks_price)
VALUES ('IT전문서', '쉽게 배우는 JSP 웹 프로그래밍', '송미영', NOW(), 27000);

INSERT INTO book_market_books (bks_category, bks_title, bks_author, bks_date, bks_price)
VALUES ('IT전문서', '안드로이드 프로그래밍', '우재남', NOW(), 33000);

INSERT INTO book_market_books (bks_category, bks_title, bks_author, bks_date, bks_price)
VALUES ('컴퓨터입문', '컴퓨팅 사고력을 키우는 블록 코딩', '고광일', NOW(), 33000);






-- 