/*================================================================================================================================================
==================================================================================================================================================

	Day05_실습
    
==================================================================================================================================================
=================================================================================================================================================*/

/*________________________________________________________________________________________________________________________________________________

	Constraint (제약사항) : 데이터의 "무결성 원칙"을 적용하기 위한 규칙 (CRUD 모두 해당됨)
	- unique (유니크 제약) : 중복을 방지하는 제약 (아이디 중복 체크 등)
	- not null : null 값을 허용하지 않는 제약 :: 화면 구현시 유효성 체크 로직과 연동
	- primary key (기본키) : unique + not null 제약을 동시에 설정
	- foreign key (참조키) : 타 테이블의 기본키를 참조하는 컬럼 설정,
	                        참조하는 기본키의 데이터 타입 동일
	- default : 데이터 입력 시 기본으로 저장 데이터에 할당되는 값 설정
    
	** 제약사항은 테이블 생성 시 정의 가능함, 또는 테이블 수정으로도 변경, 추가 가능
	- create table ..., alter table ...
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

use hrdb2019;
select database();
select * from information_schema.table_constraints
	where table_schema = 'hrdb2019';

desc employee; -- mysql은 참조키 표시가 mul로 표기됨
desc department;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 테이블 생성 : emp_const

	create table emp_const (
		emp_id		char(4)			primary key,
		emp_name	varchar(10)		not null,
		hire_date	date,
		salary		int
	);

	show tables;
	desc emp_const;

	insert into emp_const(emp_id, emp_name, hire_date, salary) values('s001', '홍길동', curdate(), 1000);

	insert into emp_const(emp_id, emp_name, hire_date, salary) values('s001', '홍길동', curdate(), 1000); -- 중복되는 값으로 에러 발생

	insert into emp_const(emp_id, emp_name, hire_date, salary) values(null, '홍길동', curdate(), 1000); -- null이 들어갈 수 없는 조건 키이기 때문에 에러 발생

	insert into emp_const(emp_id, emp_name, hire_date, salary) values('s002', null, curdate(), 1000);  -- null이 들어갈 수 없는 조건 키이기 때문에 에러 발생

	insert into emp_const(emp_id, emp_name, hire_date, salary) values('s002', '홍길동', curdate(), 1000); -- 이름은 동일이름이 있을 수 있으므로 정상 등록 처리됨

	insert into emp_const(emp_id, emp_name) values('s003', '이순신'); -- 생략시 null 값이 자동으로 들어가 가능

	insert into emp_const(emp_id, emp_name, hire_date, salary) values('s004', '김유신', null, null); -- 그러나 개발시 일일히 찾아봐야 하는 경우가 발생하므로 1:1 매핑하는 식으로 작업하는 것을 추천
		
	select * from emp_const;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

	create table emp_const2(
		emp_id		char(5),
		emp_name	varchar(10)		not null,
		hire_date	date,
		salary		int,
		constraint	pk_emp_const2	primary key(emp_id) -- 워크벤치 버전에 따라 가능한 경우가 있고 불가한 경우가 있음, 현재 학습 버전에서는 등록됨
	);

	select * from information_schema.table_constraints where table_name = 'emp_const2'; -- 현재 학습 버전에서는 위의 pk_emp_const2가 등록은 되었으나 내부적으로 조회시 PRIMARY로 나옴

	insert into emp_const2(emp_id, emp_name, hire_date, salary) values('s001', '홍길동', now(), 1000); -- curdate를 사용시 일 뒤 시분초는 안들어가나 now는 시분초까지 생성되고 나서 date 타입에 들어가기 때문에 효율성이 떨어져서 아웃풋 창에서 워닝으로 알려줌
		
	select * from emp_const2;
	desc emp_const2;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- emp_const2 컬럼 추가 : phone, char(13) 컬럼 추가

	select * from emp_const2; -- 데이터가 있는 상태에서는 not null 처리하면 안됨
    
	alter table emp_const2 add column phone char(13) null;

	desc emp_const2;
	select * from emp_const2;

    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 홍길동의 폰 번호 업데이트 후, phone 컬럼을 not null로 수정

	set sql_safe_updates = 0; -- 프로그램 실행시 디폴트 값이 금지로 변경되기에 먼저 해제 필요
	update emp_const2 set phone = '010-1234-5678' where emp_id = 's001';
	--     where emp_name = '홍길동'; -- 이렇게 처리도 가능하나 동명이인의 이름의 폰 번호가 변경될 수 있으므로 프라이머리 키를 지정해 변경하는 것을 권장

	select * from emp_const2;
    
	alter table emp_const2
	modify column phone char(13) not null;
	desc emp_const2;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- phone 컬럼에 unique 제약 추가
-- - 중복된 데이터 확인 : 똑같은 데이터가 있을 경우 사전 update로 교체 후 진행
-- - null 입력 가능: 처음 한번만 들어갈 수 있음, 두 번째부터는 중복으로 에러 처리됨
	
	alter table emp_const2 add constraint uni_phone unique(phone);
        
	desc emp_const2;
	select * from information_schema.table_constraints where table_name = 'emp_const2';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- phone 컬럼에 unique 제약 삭제

	alter table emp_const2 drop constraint uni_phone;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 테이블 삭제 : emp, emp2

	show tables;
	drop table emp;
	drop table emp2;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 테이블 복사
-- ㄴ department 테이블의 복사본 : dept
-- ㄴ employee 테이블 복사본 : emp
-- ** 복제 시 키 값은 복제되지 않음

	create table dept
	as
	select * from department
	where unit_id is not null; -- 본부가 아직 정해지지 않은 부분은 제외하고 복제
    
	show tables;
	desc dept; -- 현재 키 값은 복제되지 않음
    
	select * from dept;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- dept_id 컬럼에 primary key 제약 추가
    
	alter table dept add constraint pk_dept_id primary key(dept_id);
        
	select * from information_schema.table_constraints where table_name = 'dept';
	desc dept;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- 2018년도에 입사한 사원들만 복제
    
	create table emp
	as
	select * from employee
	where left(hire_date, 4) = '2018';
    
	show tables;
	desc emp;
	select * from emp;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- emp 테이블에 제약 사항 추가

	-- primary key(emp_id) 기본키 제약 추가
		select * from information_schema.table_constraints where table_name = 'emp';

		alter table emp add constraint primary key(emp_id);
		desc emp;
    
	-- foreign key(dept_id) 참조키 제약 추가
		alter table emp add constraint fk_dept_id foreign key(dept_id) references dept(dept_id); -- 에러 발생, 사유는 아래 기재
				
		select * from dept;
		select * from emp; -- 조회해보면 사원정보에는 STG가 있으나 dept에는 현재 STG가 없음
    
		-- 고소해 사원 부서이동 --> ACC
			update emp set dept_id = 'ACC' where emp_id = 'S0020';

			alter table emp add constraint fk_dept_id foreign key(dept_id) references dept(dept_id);
			desc dept;
			desc emp;
            
		-- 홍길동 사원 추가
			desc emp;
			insert emp(emp_id, emp_name, eng_name, gender, hire_date, retire_date, dept_id, phone, email, salary)
			values('S0001', '홍길동', null, 'M', curdate(), null, 'HRD', '010-1234-5678', 'hong@test.com', null);
			
			select * from emp;
			
			insert emp(emp_id, emp_name, eng_name, gender, hire_date, retire_date, dept_id, phone, email, salary)
			values('S0002', '홍길동', null, 'M', curdate(), null, 'ABC', '010-1234-5678', 'hong@test.com', null); -- ABC 부서가 없기에 에러 발생

			insert emp(emp_id, emp_name, eng_name, gender, hire_date, retire_date, dept_id, phone, email, salary)
			values('S0002', '홍길동', null, 'M', curdate(), null, 'SYS', '010-1234-5678', 'hong@test.com', null);
			
			select * from emp;



/*________________________________________________________________________________________________________________________________________________

	학사관리 시스템 설계
    
	(1) 과목(SUBJECT) 테이블은 
		컬럼 : SID(과목아이디), SNAME(과목명), SDATE(등록일:년월일 시분초)
		SID는 기본키, 자동으로 생성한다.
        
	(2) 학생(STUDENT) 테이블은 반드시 하나 이상의 과목을 수강해야 한다. 
		컬럼 : STID(학생아이디) 기본키, 자동생성
	          SNAME(학생명) 널허용x,
	          GENDER(성별)  문자1자 널허용x,
	          SID(과목아이디),
	          STDATE(등록일자) 년월일 시분초
            
	(3) 교수(PROFESSOR) 테이블은 반드시 하나 이상의 과목을 강의해야 한다.
		컬럼 : PID(교수아이디) 기본키, 자동생성
	          NAME(교수명) 널허용x
	          SID(과목아이디),
	          PDATE(등록일자) 년월일 시분초
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 테이블 생성

	-- (1) 과목
		create table subject(
			sid     int             primary key     auto_increment,
			sname   varchar(10)     not null,
			sdate   datetime
		);
		
		drop table subject;

	-- (2) 학생
		create table student(
			stid    int             primary key     auto_increment,
			sname   varchar(10)     not null,
			gender  char(1)         not null,
			sid     int,
			stdate  datetime,
			constraint fk_sid_student       foreign key(sid)
	                                                references subject(sid)
		);
		
		show tables;
		desc student;
		
		drop table student;

	-- (3) 교수
		create table professor(
			pid     int             primary key     auto_increment,
			name    varchar(10)     not null,
			sid     int,
			pdate   datetime,
			constraint fk_sid_professor     foreign key(sid)
	                                                references student(sid)
		);
		
		show tables;
		desc professor;
		
		drop table professor;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- 테이블 제약 사항 확인

	select * from information_schema.table_constraints where table_name in ('subject', 'student', 'professor');
        
	-- 위 코드 실행 후 Database > Reverse Engineer 실행
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 데이터 추가

	-- (1) 과목
		insert into subject(sname, sdate) values('java', now());
		insert into subject(sname, sdate) values('mysql', now());
		insert into subject(sname, sdate) values('html', now());
		insert into subject(sname, sdate) values('react', now());
		insert into subject(sname, sdate) values('node', now());
		
		select * from subject;

	-- (2) 학생
		insert into student(sname, gender, sid, stdate) values('홍길동', 'm', 1, now());
		insert into student(sname, gender, sid, stdate) values('이순신', 'm', 2, now());
		insert into student(sname, gender, sid, stdate) values('김유신', 'm', 3, now());
		insert into student(sname, gender, sid, stdate) values('박보검', 'm', 4, now());
		insert into student(sname, gender, sid, stdate) values('아이유', 'f', 5, now());
		
		select * from student;

	-- (3) 교수
		insert into professor(name, sid, pdate) values('스미스', 1, now());
		insert into professor(name, sid, pdate) values('홍홍', 3, now());
		insert into professor(name, sid, pdate) values('김철수', 4, now());
		
		select * from professor;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- 홍길동 학생이 수강하는 과목명을 조회

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select su.sname
		from subject su, student st
		where su.sid = st.sid and st.sname = '홍길동';

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select su.sname
		from subject su inner join student st on su.sid = st.sid
		where st.sname ='홍길동';
		
	-- 서브쿼리 :
		select sname from subject
		where sid = (select sid from student where sname = '홍길동');
    
-- 홍길동 학생이 수강하는 과목명과 학생명을 조회

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select su.sname as 과목명, st.sname as 학생명
		from subject su, student st
		where su.sid = st.sid and st.sname = '홍길동';

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select su.sname as 과목명, st.sname as 학생명
		from subject su inner join student st on su.sid = st.sid
		where st.sname = '홍길동';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- 스미스 교수가 강의하는 과목을 조회

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select su.sname
		from subject su, professor p
		where su.sid = p.sid and name = '스미스';

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select su.sname
		from subject su inner join professor p on su.sid = p.sid
		where sname = '스미스';
		
	-- 서브쿼리 :
		select sname from subject
		where sid = (select sid from professor where name = '스미스');
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- java, 안중근 교수 추가

	insert into professor(name, sid, pdate) values('안중근', 1 , now());
    
	select * from professor;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- java, 수업을 강의하는 모든 교수 조회

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select p.name
		from professor p, subject su
		where p.sid = su.sid and su.sname = 'java';

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select p.name
		from professor p inner join subject su on p.sid = su.sid
		where su.sname = 'java';

	-- 서브쿼리 :
		select name from professor
		where sid = (select sid from subject where sname = 'java');
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- java, 수업을 강의하는 교수와 수강신청한 학생들을 조회
-- ㄴ 과목아이디, 과목명, 교수명, 학생명

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select su.sid, su.sname, p.name, st.sname
		from subject su, professor p, student st
		where su.sid = p.sid and su.sid = st.sid and su.sname = 'java';

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select su.sid, su.sname, p.name, st.sname
		from subject su inner join professor p on su.sid = p.sid
		                inner join student st on su.sid = st.sid
		where su.sname = 'java';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 김철수 교수가 강의하는 과목을 수강하는 학생 조회
-- ㄴ 학생명 출력, 서브쿼리

	select sname from student
	where sid = (select sid from subject
	              where sid = (select sid from professor where name = '김철수')
    );
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- kor, eng, math 과목 컬럼 추가, decimal(10, 2)
    
	desc student;
	select * from student;
    
	alter table student add column kor decimal(7, 2) null;
    
	alter table student add column eng decimal(7, 2) null;
    
	alter table student add column math decimal(7, 2) null;
    
	desc student;

-- kor, eng, math 과목 컬럼 0점 입력
    
	update student set kor = 0, eng = 0, math = 0
	               where kor is null and eng is null and math is null;

	select * from student;



/*________________________________________________________________________________________________________________________________________________

	회원, 상품, 주문, 주문상세 테이블 생성 및 실습

-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 테이블 생성

	-- (1) 회원
		create table member(
			member_id       int             primary key     auto_increment,
			name            varchar(50)     not null,
			email           varchar(100)    unique          not null,
			created_at      datetime        default         current_timestamp
		);
		
		drop table member;

	-- (2) 상품
		create table product(
			product_id      int             primary key     auto_increment,
			name            varchar(100)    not null,
			price           decimal(10,2)   not null,
			stock           int             default         0
		);
		
		drop table product;

	-- (3) 주문
		create table `order`(
			order_id        int             primary key     auto_increment,
			member_id       int,
			order_date      datetime        default         current_timestamp,
			status          varchar(20)     default         '주문완료',
			constraint fk_order_member      foreign key(member_id)
	                                                references member(member_id)
		);
		
		drop table `order`;

	-- (4) 주문 상세
		create table orderitem(
			order_item_id   int             primary key     auto_increment,
			order_id        int,
			product_id      int,
			quantity        int             not null,
			unit_price      decimal(10, 2)  not null,
			constraint fk_orderitem_order 	foreign key(order_id)
	                                                references `order`(order_id),
			constraint fk_orderitem_product foreign key(product_id)
	                                                references product(product_id)
		);
		
		drop table orderitem;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 테이블 등록

	-- (1) 회원
		show tables;
		
		insert into member(name, email) values ('이순신', 'lee@naver.com');
		insert into member(name, email) values ('홍길동', 'hong@naver.com');
		
		select * from member;

	-- (2) 상품
		desc product;
		
		insert into product(name, price)
			values('모니터', 1000), ('키보드', 2000), ('마우스', 3000);
				  
		select * from product;

	-- (3) 주문
		show tables;
		desc `order`;
		
		insert into `order`(member_id, order_date)
			values(1, '2024-06-20'), (1, '2024-06-23'); -- 1번 회원의 주문 2건
				  
		insert into `order`(member_id, order_date)
			values(2, '2024-06-22'), (2, '2024-06-25'); -- 2번 회원의 주문 2건
				  
		select * from `order`;

	-- (4) 주문 상세
		show tables;
		desc orderitem;
		
		insert into orderitem(order_id, product_id, quantity, unit_price)
			values(1, 1, 2, 1000), (1, 2, 3, 2000);
				-- 1번(member_id) 회원의 첫 번째(order_id 1) 주문 - 모니터 2개
				-- 1번(member_id) 회원의 첫 번째(order_id 1) 주문 - 키보드 3개
		
		insert into orderitem(order_id, product_id, quantity, unit_price)
			values(2, 3, 2, 2500), (2, 1, 3, 3000);
				-- 1번(member_id) 회원의 두 번째(order_id 2) 주문 - 마우스 2개
				-- 1번(member_id) 회원의 두 번째(order_id 2) 주문 - 모니터 3개
		
		insert into orderitem(order_id, product_id, quantity, unit_price)
			values(3, 2, 1, 2000), (3, 3, 1, 3000);
				-- 2번(member_id) 회원의 첫 번째(order_id 3) 주문 - 키보드 1개
				-- 2번(member_id) 회원의 첫 번째(order_id 3) 주문 - 마우스 1개
		
		insert into orderitem(order_id, product_id, quantity, unit_price)
			values(4, 1, 2, 1000), (4, 2, 1, 2000);
				-- 2번(member_id) 회원의 두 번째(order_id 4) 주문 - 모니터 2개
				-- 2번(member_id) 회원의 두 번째(order_id 4) 주문 - 키보드 1개
			
		select * from orderitem;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 홍길동 고객의 고객명, 이메일, 가입날짜, 주문날짜를 조회
-- ㄴ 주문날짜는 년, 월, 일로만 출력

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select * from member;
		
		select m.name, m.email, m.created_at, left(o.order_date, 10) as order_date
		from member m, `order` o
		where m.member_id = o.member_id and m.name = '홍길동';

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select m.name, m.email, m.created_at, left(o.order_date, 10) as order_date
		from member m inner join `order` o on m.member_id = o.member_id
			where m.name = '홍길동';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 상품별 주문 건수
-- ㄴ 상품명, 주문 건수 출력

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select p.name, count(*) as count
		from product p, orderitem oi
		where p.product_id = oi.product_id
		group by p.name
		order by count;

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select p.name, count(*) as count
		from product p inner join orderitem oi on p.product_id = oi.product_id
		group by p.name
		order by count;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 테이블 등록 > 상품 추가

	desc product;
    
	insert into product(name, price)
		values('리모컨', 3000), ('USB', 4000), ('마우스패드', 5000);
              
	select * from product;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 상품별 주문 건수(수량), 모든 상품 조회(주문이 없는 상품도 포함) - 아우터 조인은 ansi 방식으로만 동작하므로 ansi 방식으로만 진행

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select p.name, count(quantity) as count
		from product p left outer join orderitem oi on p.product_id = oi.product_id
		group by p.name
		order by count desc;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 연습은 커맨드라인에서 진행을 추천, 더 정확하지 않으면 진행이 안되기 때문
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 회원이 주문한 내역과 제품명 조회
-- ㄴ 회원명, 가입날짜, 주문날짜, 주문수량, 제품명, 가격

	-- oracle 방식의 조인 : 실무에서는 이 방식을 더 자주 사용함
		select m.name, m.created_at, od.order_date, oi.quantity, p.name, oi.unit_price
		from member m, `order` od, orderitem oi, product p
			where m.member_id = od.member_id
				and od.order_id = oi.order_id
				and oi.product_id = p.product_id
		order by m.created_at;
                

	-- ansi 방식의 조인 : 자격증에서는 이 방식을 알아야 함
		select m.name, m.created_at, od.order_date, oi.quantity, p.name, oi.unit_price
		from member m 
			inner join `order` od on od.member_id = m.member_id
			inner join orderitem oi on od.order_id = oi.order_id
			inner join product p on oi.product_id = p.product_id
		order by m.created_at;





