/*================================================================================================================================================

Day03_실습
    
=================================================================================================================================================*/

/*------------------------------------------------------------------------------------------------------------------------------------------------

	조인(JOIN) : 두 개 이상의 테이블을 연동해서 SQL 실행
    ERD(Entity Relationshop Diagram) : 데이터베이스 구조도(설계도)
    - 데이터 모델링 : 정규화 과정
    
    ** ANSI SQL : 데이터베이스 시스템들의 표준 SQL
    조인(JOIN) 종류
    1) CROSS JOIN (오라클 쪽은 CATEISIAN JOIN라 불림) - 합집합 : 테이블의 데이터 전체를 조인 - 테이블A(10) * 테이블B(10) > 무조건 곱하기 처리로 100개로 나옴 : 데이터의 연관성이 없을때 소위 '뻥튀기'한다고 칭함
    2) INNER JOIN (NATURAL) - 교집합 : 두 개 이상의 테이블을 조인 연결 고리(키)를 통해 조인 실행
    3) OUTER JOIN - INNER JOIN(교집합) + (교집합한 다음에)선택한 테이블의 조인 제외 ROW 포함
    4) SELF JOIN : 한 테이블을 두 개 테이블처럼 조인 실행
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

use hrdb2019;
select datbase();
show tables;
select * from employee;
select * from department;

select count(*) from employee; -- 20
select count(*) from department; -- 7

-- cross join / 무조건 곱하기
select count(*)
from employee, department; -- 140
select * from employee, department; -- 테이블 조회

select count(*)
from employee cross join department; -- 140
select * from employee, department; -- 테이블 조회

--
select count(*) from vacation; -- 102

-- 사원, 부서, 휴가 테이블 cross join : 20 * 7 * 102 / 몇 천건이였으나 통신 발달 후 몇 억건 정도로 늘어남, 테스트 이외에는 사용 주의, 실제 데이터에 사용 시 다운될 수 있음
select count(*) from employee, department, vacation; -- 오라클에서는 이런 형태로 사용
select count(*)
from employee corss join department, corss join vacation;
select count(*)
from employee corss join department, vacation;

-- inner join : ansi / 오라클이나 다른 sql에서 사용가능
select *
-- select count(*)
from employee, department
where employee.dept_id = department.dept_id
order by emp_id;

-- inner join / mssql나 시퀄은 이렇게 사용해야 함
select *
-- select count(*)
from employee inner join department
on employee.dept_id = department.dept_id
order by emp_id;

-- inner join : ansi (사원테이블, 부서테이블, 본부테이블) / 오라클이나 다른 sql에서 사용가능 - 전략기획에 인원이 없어도 전략기획이 표시되어야 함, 이때 3) 아우터 조인 사용
select *
-- select count(*)
from employee e, department d, unit u
where e.dept_id = d.dept_id
and d.unit_id = u.unit_id -- 카운트 19는 1개가 null 값이라 빠진 것을 확인 가능
order by e.emp_id;

-- inner join (사원테이블, 부서테이블, 본부테이블) / mssql나 시퀄은 이렇게 사용해야 함
select *
from employee e
inner join department d on e.dept_id = d.dept_id
inner join unit u on d.unit_id = u.unit_id;

-- inner join : ansi (사원테이블, 부서테이블, 본부테이블, 휴가테이블)
select *
from employee e, department d, unit u, vacation v
where e.dept_id = d.dept_id
and d.unit_id = u.unit_id
and e.emp_id = v.emp_id
order by e.emp_id;

-- inner join (사원테이블, 부서테이블, 본부테이블, 휴가테이블)
select *
from employee e
inner join department d on e.dept_id = d.dept_id
inner join unit u on d.unit_id = u.unit_id
inner join vacation v on e.emp_id = v.emp_id
order by e.emp_id;