/*================================================================================================================================================
==================================================================================================================================================

	Day06_실습
    
==================================================================================================================================================
=================================================================================================================================================*/

/*________________________________________________________________________________________________________________________________________________

	행번호, 트리거를 이용한 사원번호 생성

-------------------------------------------------------------------------------------------------------------------------------------------------*/

use hrdb2019;
select database();

-- 사원 테이블의 사번, 사원명, 입사일, 폰번호, 이메일, 급여 조회
	select emp_id, emp_name, hire_date, phone, email, salary
	from employee;
-- 최대한 DB에서 가공해 가져오는게 베스트임
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- (1) 행 번호를 구하는 함수

	-- row_number() over(order by 컬럼명 asc/desc) / order by 생략 가능
	-- ㄴ 입사일 : 입사년도만, 급여 : 3자리 구분
		select
			row_number() over(order by emp_id) as rno,
			emp_id, emp_name,
			concat(left(hire_date, 4), '년') as hire_date,
			phone, email,
			concat(format(salary, 0), '만원') as salary
		from employee;
		-- 연봉의 인트는 디폴트로 0이 되고, 스트링은 디폴트로 null이 됨

	-- rno 행번호 추가, 주문날짜(년, 월, 일), 가격(소수점 생략, 3자리 구분)
	-- ㄴ 가공은 최종 출력되는 값에 적용하는 것을 추천하고 권장함
		select 
			row_number() over() as rno,
			t1.name, t1.created_at,
			left(t1.order_date, 10) as order_date,
			t1.quantity, p.name,
			format(floor(p.price), 0) as price
			from (select distinct m.name, m.created_at, o.order_date, oi.quantity, oi.product_id
					from member m, `order` o, orderitem oi
					where m.member_id = o.member_id 
					and o.order_id = oi.order_id) t1 right outer join product p
													on t1.product_id = p.product_id;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- (2) 석차를 구하는 함수

	-- rank (동일 데이터 값은 동일 순번으로 지정해줌) / 오라클은 오더 바이 붙여야 함
		select
			rank() over(order by salary desc) as r,
			emp_id,
			emp_name,
			dept_id,
			salary
		from employee;

	-- row_number 함수와 rank 함수를 동시에 사용할 수 있음
		select
			row_number() over(order by emp_id) as rno, -- row 먼저 실행 후 rank 실행됨
			rank() over(order by salary desc) as r,
			emp_name,
			emp_id,
			dept_id,
			salary
		from employee;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- (3) 트리거 : 프로시저(함수, 메소드)를 호출하는 시작점
	select *
	from information_schema.triggers;
        
	-- 트리거 실습 테이블 생성 / 인트에 부여가 안되기에 트리거를 사용해 부여함
		create table trg_member(
			mid 	char(5), 	-- 'M0001'
			name 	varchar(10),
			mdate 	date
		);
		
		show tables;
		desc trg_member;
		select * from trg_member; -- insert가 명령어가 실행될때 트리거가 자동으로 실행되도록 함
        
	-- trg_member, mid 컬럼 타입 수정 : varchar(10)
		alter table trg_member
			modify column mid varchar(10);
		desc trg_member;

	-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
	-- 트리거 생성 : 여러개의 sql문 포함 ** 인서트가 실행 완료되기 전에 호출 : before
    
		delimiter $$
        
        -- (1) create trigger [트리거명]
			create trigger trg_member_mid
			before insert on trg_member -- 테이블명 / 업데이트 등은 애프터로 들어감
			for each row
			begin
			declare max_code int; -- 'M0001'
        
        -- (2) 현재 저장된 값 중 가장 큰 값을 가져옴
			select ifnull(max(cast(right(mid, 4) as unsigned)), 0)
			into max_code
			from trg_member;
        
        -- (3) 'M0001' 형식으로 아이디 생성, LPAD(값, 크기, 채워지는 문자형식) > M0001
			set new.mid = concat('M', lpad((max_code + 1), 4, '0'));
        
        end $$
        delimiter ;

	-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        
	-- 트리거 생성 확인
		select *
		from information_schema.triggers; -- 테이블이 변경되거나 더이상 사용되지 않을 경우 지워줘야 함
        
	-- 트리거 실습 테이블 확인
    select * from trg_member;
    insert into trg_member(name, mdate)
		values('홍길동', curdate());
        
	-- 오류 발생시 아래 명렁어 사용
        
		-- 트리거 삭제
			drop trigger trg_member_mid;
		
		-- null 값 레코드 삭제
			set sql_safe_updates = 0;
			delete from trg_member where mid is null or mid = '';
			delete from trg_member;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
        
show tables;
drop table dept; -- 참조되고 있는 테이블은 삭제가 안됨
drop table employee_2016;

-- employee 테이블 구조만 복제 > employee_stru
	desc employee;
	create table employee_stru
	as
	select * from employee where 1 = 0;
	show tables;
	desc employee_stru;
	select * from employee_stru;
    
-- employee_stru, emp_id에 기본키(Primary key) 제약사항 추가
	alter table employee_stru
		add constraint primary key(emp_id);
	
    desc employee_stru;
    
-- emp_id에 데이터 insert 작업 시 트리거가 실행되도록 생성
-- ㄴ 'E0001' 형식으로 데이터 추가
	select * from information_schema.triggers;
        
-- 트리거 생성 : 여러개의 sql문 포함 ** 인서트가 실행 완료되기 전에 호출 : before
	delimiter $$
	
	-- (1) create trigger [트리거명]
		create trigger trg_employee_stru_emp_id
		before insert on employee_stru -- 테이블명 / 업데이트 등은 애프터로 들어감
		for each row
		begin
		declare max_code int; -- 'M0001'
	
	-- (2) 현재 저장된 값 중 가장 큰 값을 가져옴
		select ifnull(max(cast(right(emp_id, 4) as unsigned)), 0)
		into max_code
		from employee_stru;
	
	-- (3) 'M0001' 형식으로 아이디 생성, LPAD(값, 크기, 채워지는 문자형식) > E0001
		set new.emp_id = concat('E', lpad((max_code + 1), 4, '0'));
	
	end $$
	delimiter ;
	
-- 트리거 생성 확인
	select *
	from information_schema.triggers; -- 테이블이 변경되거나 더이상 사용되지 않을 경우 지워줘야 함
	
-- 트리거 실습 테이블 확인
	desc employee_stru;
	select * from employee_stru;
	insert into employee_stru(emp_name, gender, hire_date, dept_id, phone, email, salary)
		values('홍홍', 'F', curdate(), 'SYS', '010-1234-5678', 'hong@test.com', 1000);

	select * from employee_stru;
	
-- 오류 발생시 아래 명렁어 사용
	
	-- 트리거 삭제
		drop trigger trg_employee_stru_emp_id;
	
	-- null 값 레코드 삭제
		set sql_safe_updates = 0;
		delete from employee_stru where mid is null or mid = '';
		delete from employee_stru;

/*________________________________________________________________________________________________________________________________________________

	참조관계에 대한 트리거 생성 : 참조관계(부모(dept : dept_id( <---> 자식(emp : dept_id))
	- 누군가 참조하고 있으면 삭제할 수 없음

-------------------------------------------------------------------------------------------------------------------------------------------------*/

select * from dept;
select * from emp;

-- ACC 부서 삭제
	delete from dept where dept_id = 'ACC'; -- emp의 고소해 사원이 참조중이므로 삭제 불가

-- GEN 부서 삭제
	delete from dept where dept_id = 'GEN'; -- emp에서 참조하는 사원이 없으므로 삭제 가능

-- 정주고 사원 삭제
	delete from emp where emp_id = 'S0019';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------
    
-- 1. 참조 관계 설정 시 on delete cascade, on update cascade
-- ㄴ 부모의 참조 컬럼이 삭제되면 자식의 행이 함께 삭제됨
-- - 뉴스 테이블의 기사 컬럼이 삭제되며 댓글 테이블의 댓글도 함께 삭제되는 경우
-- - 게시판의 게시글 삭제 시 게시글의 댓글이 함께 삭제되는 경우

	create table board(
		bid 		int 			primary key 	auto_increment,
		title 		varchar(100) 	not null,
		content 	longtext,
		bdate 		datetime
	);
    
    create table reply(
		rid         int             primary key     auto_increment,
		content     varchar(100)    not null,
        bid         int             not null,
        rdate       datetime,
        constraint fk_reply_bid     foreign key(bid)
	                                references board(bid)
		on delete cascade -- bid가 딜리트되면 함께 삭제됨
-- 		on update cascade -- bid가 업데이트되면 함께 업데이트됨
    );
    
    desc board;
    desc reply;
    
    select * from board;
    insert into board(title, content, bdate)
		values('test', 'test', curdate());
    
    select * from reply;
    insert into reply(content, bid, rdate)
		values('reply test', 1, curdate());
	
-- bid, 2 삭제
	delete from board where bid = 2;
    
	select * from board;
	select * from reply;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 2. 트리거를 사용하여 부모의 참조 컬럼 삭제 시 자식의 참조 컬럼 데이터를 null로 변경
-- ㄴ 부모의 참조 컬럼이 삭제되어도 자식의 행에 들어있던 값이 null값으로 업데이트 됨
	select * from information_schema.triggers;
    
    -- 트리거 생성 : dept 테이블의 row 삭제시(dept_id 컬럼 포함), 참조하는 emp 테이블의 dept_id에 null값 업데이트
		delimiter $$
		
		-- (1) create trigger [트리거명]
			create trigger trg_dept_dept_id_delete -- 네이밍시 포함하는 컬럼과 포함하는 테이블 명칭을 포함시킴
			after delete on dept -- 테이블명 / 업데이트 등은 애프터로 들어감
			for each row
			begin
			
		-- (2) 참조하는 emp 테이블의 dept_id에 null값 업데이트
			update emp
				set dept_id = null
				where dept_id = old.dept_id; -- old.dept_id : dept 테이블에서 삭제된 dept_id
		
		end $$
		delimiter ;
    
		select * from information_schema.triggers;
    
    -- 부서 테이블 삭제
		select * from dept;
		select * from emp;
    
		-- dept 테이블의 ACC 부서 삭제
			delete from dept where dept_id = 'ACC'; -- emp의 dept_id가 not null로 되어 있어 삭제가 안됨
		
		-- emp 테이블의 dept_id 컬럼 null 허용으로 변경
			alter table emp
				modify column dept_id char(3) null;
				
			desc emp;
			desc dept;

-- 2번 방법은 오라클 데이터베이스에서는 트리거 실행 가능
-- innoDB 형식의 데이터베이스인 mysql, maria는 트리거 실행 불가능
-- 이유는 innoDB 형식은 트리거 실행 전 참조관계를 먼저 체크하여 에러 발생시킴

-- > 퍼플렉시티 AI에게 해결 방안 : 아래 코드 실행 후 ACC 부서 삭제 진행하면 에러없이 진행됨
-- 	ALTER TABLE emp DROP FOREIGN KEY fk_dept_id;

/*------------------------------------------------------------------------------------------------------------------------------------------------

	키(외래키, primary key 등)를 건드리지 않고
	즉, 외래키 제약조건(ON DELETE CASCADE, ON DELETE SET NULL 등)을 바꾸거나 삭제하지 않고
    기존 관계 그대로 두면서 “부모(dept) 행 삭제 시 자식(emp)의 참조 컬럼을 null로 변경”하는 동작을 하고 싶다면
	MySQL(InnoDB)은 기술적으로 이게 불가능합니다.

	왜냐하면?
	InnoDB 스토리지 엔진은
	트리거 실행 전에 무결성(참조관계) 위반 여부를 먼저 검사합니다.

	즉, 부모 행을 삭제하면 바로 외래키 제약조건(FK RESTRICT/NO ACTION 등)에 위배되어
	트리거가 실행될 기회조차 주지 않고 에러(1451번)로 막아버립니다.

	그래서 키(FK)를 건드리지 않는 한, 트리거나 어떤 프로시저로도 우회가 불가합니다.

	현실적인 방법 및 권장 프로세스
	사전에 트랜잭션 내에서 아래 순서로 진행

	(1) 먼저 자식 테이블(emp)의 참조 컬럼을 수동으로 null로 업데이트

	(2) 그 후 부모 행을 삭제

	예시)

	sql
	START TRANSACTION;
		update emp set dept_id = null where dept_id = 'ACC';
		delete from dept where dept_id = 'ACC';
	COMMIT;
	이렇게 하면 키를 절대 건드리지 않고 순차적으로 무결성을 지킬 수 있음

	뷰나 저장 프로시저를 활용

	이런 과정을 프로시저로 만들어 사용하면 실수 방지 및 일관성 유지에 도움

	예시:

	sql
	DELIMITER $$
	CREATE PROCEDURE delete_dept_and_null_emp(p_dept_id CHAR(3))
	BEGIN
	  update emp set dept_id = null where dept_id = p_dept_id;
	  delete from dept where dept_id = p_dept_id;
	END $$
	DELIMITER ;
	사용: CALL delete_dept_and_null_emp('ACC');

	결론 정리
	키(외래키)를 건드리지 않는 한, 트리거만으로는 불가 (InnoDB 특성 때문)

	대안: 수동 update → delete 순서로 코드 작성 (직접 실행 또는 프로시저화)

	이 방법은 무결성을 해치지 않고, DB 구조(키)도 변화시키지 않으면서 원하는 동작을 실현할 수 있는 가장 표준적인 방법입니다.

-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 사원 테이블의 급여 변경시 로그 저장 :: 트리거 업데이트 이용
    
    -- 테이블 생성
		create table salary_log(
			emp_id          char(5)     primary key,
			old_salary      int,
			new_salary      int,
			change_date     date
		);
		
		desc salary_log;
    
    -- 트리거 생성 : dept 테이블의 row 삭제시(dept_id 컬럼 포함), 참조하는 emp 테이블의 dept_id에 null값 업데이트
		delimiter $$
		
		-- (1) create trigger [트리거명]
			create trigger trg_salary_update -- 네이밍시 포함하는 컬럼과 포함하는 테이블 명칭을 포함시킴
			after update on employee -- 테이블명 / 업데이트 등은 애프터로 들어감
			for each row
			begin
			
		-- (2) 사원 테이블의 급여 변경시 로그 저장, old.salary(기존 급여), new.salary(새로운 급여)
			if old.salary <> new.salary then
				insert into salary_log(emp_id, old_salary, new_salary, change_date)
							values(old.emp_id, old.salary, new.salary, now());
			end if;
		end $$
		delimiter ;
    
		select * from information_schema.triggers;
    
    -- 변경 내역 확인
		select * from salary_log;
		
		update employee set salary = 1000 where emp_id = 'S0020';
		
		select * from salary_log;





