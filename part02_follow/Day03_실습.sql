/*================================================================================================================================================
==================================================================================================================================================

	Day03_실습
    
==================================================================================================================================================
=================================================================================================================================================*/

/*________________________________________________________________________________________________________________________________________________

	조인(JOIN) : 두 개 이상의 테이블을 연동해서 SQL 실행
	ERD(Entity Relationshop Diagram) : 데이터베이스 구조도(설계도)
	- 데이터 모델링 : 정규화 과정
    
	** ANSI SQL : 데이터베이스 시스템들의 표준 SQL
    
	조인(JOIN) 종류
	(1) CROSS JOIN (오라클 쪽은 CATEISIAN JOIN라 불림) - 합집합 : 테이블의 데이터 전체를 조인 - 테이블A(10) * 테이블B(10) > 무조건 곱하기 처리로 100개로 나옴 : 데이터의 연관성이 없을때 소위 '뻥튀기'한다고 칭함
	(2) INNER JOIN (NATURAL) - 교집합 : 두 개 이상의 테이블을 조인 연결 고리(키)를 통해 조인 실행
	(3) OUTER JOIN - INNER JOIN(교집합) + (교집합한 다음에)선택한 테이블의 조인 제외 ROW 포함
	(4) SELF JOIN : 한 테이블을 두 개 테이블처럼 조인 실행
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

use hrdb2019;
select datbase();
show tables;
select * from employee;
select * from department;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

select count(*) from employee; -- 20
select count(*) from department; -- 7
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- cross join / 무조건 곱하기

	select count(*)
	from employee, department; -- 140
	select * from employee, department; -- 테이블 조회

	select count(*)
	from employee cross join department; -- 140
	select * from employee, department; -- 테이블 조회

	select count(*) from vacation; -- 102
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 사원, 부서, 휴가 테이블 cross join : 20 * 7 * 102 / 테스트 이외에는 사용 주의, 실제 데이터에 사용 시 다운될 수 있음

	select count(*) from employee, department, vacation; -- 오라클에서는 이런 형태로 사용
	select count(*)
	from employee corss join department, corss join vacation;
	select count(*)
	from employee corss join department, vacation;



/*________________________________________________________________________________________________________________________________________________

	조인 > inner join : 기본 SQL 방식, 오라클·MySQL 등에서 사용 가능
	(FROM 뒤에 ,(쉼표)로 테이블 나열 + WHERE로 조인 조건 작성)
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	(1) 기본 SQL 방식  > select [컬럼리스트] from [테이블1], [테이블2], ...
                               where [테이블1.조인컬럼] = [테이블2.조인컬럼]
                                      and [조건절~]
	(2) ANSI SQL 표준 > select [컬럼리스트] from [테이블1] 
                               inner join [테이블2], ...
                                           on [테이블1.조인컬럼] = [테이블2.조인컬럼]
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

select *
-- select count(*)
from employee, department
where employee.dept_id = department.dept_id
order by emp_id;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- (1) 기본 SQL 방식, 오라클·MySQL 등에서 사용 가능 (3개 테이블)
-- ㄴ 직접 FROM에 ,로 다 나열 + WHERE에서 각각 연결)
-- ** 전략기획에 인원이 없어도 전략기획이 나타나려면 OUTER JOIN

	select *
	-- select count(*)
	from employee e, department d, unit u
	where e.dept_id = d.dept_id
		  and d.unit_id = u.unit_id -- 카운트 19는 1개가 null 값이라 빠진 것을 확인 가능
	order by e.emp_id;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- (2) ANSI SQL 표준, 대부분의 RDBMS(mssql, mysql 등)에서 권장
-- ㄴ INNER JOIN ... ON ... 형태로 명확하게 작성

	select *
	-- select count(*)
	from employee inner join department
		 on employee.dept_id = department.dept_id
	order by emp_id;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- (1) 기본 SQL 방식, 오라클·MySQL 등에서 사용 가능 (4개 테이블)

	select *
	from employee e, department d, unit u, vacation v
	where e.dept_id = d.dept_id
		  and d.unit_id = u.unit_id
		  and e.emp_id = v.emp_id
	order by e.emp_id;

-- (2) ANSI SQL 표준, 대부분의 RDBMS에서 권장 (3개 테이블)

	select *
	from employee e
		 inner join department d on e.dept_id = d.dept_id
		 inner join unit u on d.unit_id = u.unit_id;

-- (2) ANSI SQL 표준, 대부분의 RDBMS에서 권장 (4개 테이블)

	select *
	from employee e
		 inner join department d on e.dept_id = d.dept_id
		 inner join unit u on d.unit_id = u.unit_id
		 inner join vacation v on e.emp_id = v.emp_id
	order by e.emp_id;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 모든 사원들의 사번, 사원명, 부서아이디, 부서명, 입사일, 급여 조회

	select e.emp_id, e.emp_name, e.dept_id, d.dept_name, e.hire_date, e.salary
	from employee e, department d
	where e.dept_id = d.dept_id;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 영업부에 속한 사원들의 사번, 사원명, 입사일, 퇴사일, 폰번호, 급여, 부서아이디, 부서명 조회

	select e.emp_id, e.emp_name, e.hire_date, e.retire_date, e.phone, e.dept_id, d.dept_name
	from employee e, department d
	where e.dept_id = d.dept_id
		  and d.dept_name = '영업';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 인사과에 속한 사원들 중에 휴가를 사용한 사원들의 내역을 조회

	select *
	from employee e, department d, vacation v
	where e.dept_id = d.dept_id
		  and e.emp_id = v.emp_id
		  and d.dept_name = '인사';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 영업부서 사원의 사원명, 폰번호, 부서명, 휴가사용 이유 조회
-- ㄴ 휴가 사용 이유가 '두통'인 사원, 소속본부 조회

	select e.emp_name, e.phone, d.dept_id, u.unit_name, v.reason
	from employee e, department d, unit u, vacation v
	where e.dept_id = d.dept_id
		  and d.unit_id = u.unit_id
		  and e.emp_id = v.emp_id
		  and d.dept_name = '영업'
		  and v.reason = '두통';
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 2014년부터 2016년까지 입사한 사원들 중에서 퇴사하지 않은 사원들의 사원아이디, 사원명, 부서명, 입사일, 소속본부를 조회
-- ㄴ 소속본부 기준으로 오름차순 정렬

	select e.emp_id, e.emp_name, d.dept_name, e.hire_date, u.unit_name
	from employee e, department d, unit u
	where e.dept_id = d.dept_id
		  and d.unit_id = u.unit_id
		  and left(hire_date, 4) between '2014' and '2016'
		  and e.retire_date is null
	order by u.unit_name asc;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 부서별 총급여, 평균급여, 총 휴가사용 일수를 조회
-- ㄴ 부서명, 부서아이디, 총급여, 평균급여, 휴가사용일수

	select d.dept_name, d.dept_id, sum(e.salary), avg(e.salary), sum(v.duration)
	-- sum(e.salary), avg(e.salary) : 서브 컬럼에서 합계를 계산 후 가져오는 식으로 처리 필요
	from employee e, department d, vacation v
	where e.dept_id = d.dept_id
		  and e.emp_id = v.emp_id
	group by d.dept_id, d.dept_name;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 본부별, 부서의 휴가사용 일수

	select u.unit_name, d.dept_name, d.dept_id, sum(duration) as 휴가사용일수
	from employee e, department d, vacation v, unit u
	where e.dept_id = d.dept_id
		  and e.emp_id = v.emp_id
		  and d.unit_id = u.unit_id
	group by d.dept_id, d.dept_name, u.unit_name;



/*________________________________________________________________________________________________________________________________________________

	조인 > Outer join : inner join + 조인에서 제외된 row(테이블별 지정), 전통적인 방식으로는 안됨
	오라클 형식의 outer join은 사용불가, ansi sql 형식만 사용가능
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	select [컬럼리스트] from
                          [테이블명1 테이블별칭] left/right outer join 테이블명3 [테이블별칭], ...]
                                                                  ON [테이블명1.조인컬럼 = 테이블명2.조인컬럼]

	** 오라클 형식 Outer join, 사용불가 (에러가 나서 동작은 안되지만 추가 설명)
	select * from table1 t1, table2 t2
	where t1.col = t2.col(+);
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 모든 부서의 부서아이디, 부서명, 본부명을 조회

	select * from department;
	select d.dept_id, d.dept_name, ifnull(u.unit_name, '협의중') unit_name
	from department d
		 left outer join unit u
		 on d.unit_id = u.unit_id
	order by unit_name asc;
	-- where d.unit_id = u.unit_id(+); / 지원되지 않는 코드
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 본부별, 부서의 휴가사용 일수
-- ㄴ 부서의 누락없이 모두 출력

	select
		 u.unit_name 본부명,  d.dept_name 부서명,  count(v.duration) 휴가사용일수
		 -- 무엇: 본부명(각 부서의 소속 본부 표시)
	                             -- 무엇: 부서명(집계의 그룹 기준)
	                                                 -- 무엇: 휴가 사용 횟수(누가 몇 번이나 휴가를 썼는지, 없는 경우 0)
	from employee e
	     left outer join vacation v     on e.emp_id = v.emp_id      -- 어떻게: 사원별로 휴가 내역을 연결(휴가 없는 사원도 보임, 누가/무엇을)
	     right outer join department d  on e.dept_id = d.dept_id    -- 왜: 모든 부서가 반드시 결과에 나오도록(누구를, 왜: 부서 누락 X) 
	     left outer join unit u         on d.unit_id = u.unit_id    -- 어떻게: 본부(소속)를 부서에 붙여서 보여줌(어디에, 무엇을)
	group by u.unit_name, d.dept_name                               -- 누구/무엇: 본부별+부서별로 결과를 모으기 위해(누구끼리)
	order by u.unit_name asc;                                       -- 어떻게: 본부명 내림차순으로 보기 좋게 정렬(어떻게)
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 2017년부터 2018년도까지 입사한 사원들의 사원명, 입사일, 연봉, 부서명, 본부명을 조회
-- ㄴ 단, 퇴사한 사원들 제외
-- ㄴ 소속본부를 모두 조회

	select
		 e.emp_name 사원명,	e.hire_date 입사일,	e.salary 연봉,	dept_name 부서명,		u.unit_name 본부명
	from
		 employee e inner join department d		on e.dept_id = d.dept_id
					 left outer join unit u		on d.unit_id = u.unit_id
	where
		 left(hire_date, 4) between '2017' and '2018'
	and
		 retire_date is null;



/*________________________________________________________________________________________________________________________________________________

	조인 > self join : 자기 자신의 테이블을 조인
	코드 복잡성이 높아져 서브 쿼리 형태로 실행하는 경우가 많음
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	select [컬럼리스트] from [테이블1], [테이블2], where [테이블1.컬럼명] = [테이블2.컬럼명]
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 사원테이블 self join
	select e.emp_id, e.emp_name, m.emp_id, m.emp_name
	from employee e, employee m
	where e.emp_id = m.emp_id;
    
    
-- -----------------------------------------------------------------------------------------------------------------------------------------------

-- 사원테이블 서브 쿼리
	select emp_id, emp_name													-- < 서브쿼리 형식
	from employee
	where emp_id = (select emp_id from employee where emp_name = '홍길동');	-- > 서브쿼리 형식





