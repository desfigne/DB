/*================================================================================================================================================
==================================================================================================================================================

	Day09_실습
    
==================================================================================================================================================
=================================================================================================================================================*/

/*________________________________________________________________________________________________________________________________________________

	SQL 쿼리 생성

-------------------------------------------------------------------------------------------------------------------------------------------------*/

use hrdb2019;
select database();
show tables;

-- 테이블 3개 생성, book_tj, book_yes24, book_aladin
-- bid : pk('b001', 트리거 생성 [이름은 임의로 정의), title, author, price, isbn(랜덤 정수 4자리 생성 [바코드 코드]), bdate
-- isbn 진행 시 오라클의 랜덤 함수 또는 자바의 랜덤 함수 둘 중에 하나 선택해 진행

create table book_tj (
	bid 	char(5) 		primary key,
    title 	varchar(50) 	not null,
    author 	varchar(20),
    price 	int,
    isbn 	int 			not null,
    bdate 	datetime
);

create table book_yes24 (
	bid 	char(5) 		primary key,
    title 	varchar(50) 	not null,
    author 	varchar(20),
    price 	int,
    isbn 	int 			not null,
    bdate 	datetime
);

create table book_aladin (
	bid 	char(5) 		primary key,
    title 	varchar(50) 	not null,
    author 	varchar(20),
    price 	int,
    isbn 	int 			not null,
    bdate 	datetime
);
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

delimiter $$
	create trigger trg_book_tj_mid
	before insert on book_tj
	for each row
	begin
	declare max_code int; -- 'B0001'
    
	select ifnull(max(cast(right(bid, 3) as unsigned)), 0)
	into max_code
	from book_tj;
    
	set new.bid = concat('B', lpad((max_code + 1), 3, '0'));
end $$
delimiter ;

delimiter $$
	create trigger trg_book_yes24_mid
	before insert on book_yes24
	for each row
	begin
	declare max_code int; -- 'B0001'
    
	select ifnull(max(cast(right(bid, 3) as unsigned)), 0)
	into max_code
	from book_yes24;
    
	set new.bid = concat('B', lpad((max_code + 1), 3, '0'));
end $$
delimiter ;

delimiter $$
	create trigger trg_book_aladin_mid
	before insert on book_aladin
	for each row
	begin
	declare max_code int; -- 'B0001'
    
	select ifnull(max(cast(right(bid, 3) as unsigned)), 0)
	into max_code
	from book_aladin;
    
	set new.bid = concat('B', lpad((max_code + 1), 3, '0'));
end $$
delimiter ;

-- 트리거 생성 확인
select *
from information_schema.triggers; -- 테이블이 변경되거나 더이상 사용되지 않을 경우 지워줘야 함


/*________________________________________________________________________________________________________________________________________________

	Connection 확인

-------------------------------------------------------------------------------------------------------------------------------------------------*/

SHOW STATUS LIKE 'Threads_connected';  -- 접속 커넥션 수
SHOW PROCESSLIST;                      -- 활성중인 커넥션
SHOW VARIABLES LIKE 'max_connections'; -- 최대 접속 가능 커넥션 수


























desc member;

-- score_member 테이블 생성
create table score_member(
	mid 		char(5) 		primary key, -- 'M0001' 형식의 트리거 적용
    name 		varchar(10) 	not null,
    department 	varchar(20),
    kor 		decimal(6, 2) 	default 0.0,
    eng 		decimal(6, 2) 	default 0.0,
    math 		decimal(6, 2) 	default 0.0,
    mdate 		datetime
);
desc score_member;
select * from score_member;

-- 트리거 생성 : 여러개의 sql문 포함 ** 인서트가 실행 완료되기 전에 호출 : before
    
		delimiter $$
        
		-- (1) create trigger [트리거명]
			create trigger trg_score_member_mid
			before insert on score_member -- 테이블명 / 업데이트 등은 애프터로 들어감
			for each row
			begin
			declare max_code int; -- 'M0001'
        
		-- (2) 현재 저장된 값 중 가장 큰 값을 가져옴
			select ifnull(max(cast(right(mid, 4) as unsigned)), 0)
			into max_code
			from score_member;
        
		-- (3) 'M0001' 형식으로 아이디 생성, LPAD(값, 크기, 채워지는 문자형식) > M0001
			set new.mid = concat('M', lpad((max_code + 1), 4, '0'));
        
		end $$
		delimiter ;

	-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
	-- 트리거 생성 확인
		select *
		from information_schema.triggers; -- 테이블이 변경되거나 더이상 사용되지 않을 경우 지워줘야 함





-- 