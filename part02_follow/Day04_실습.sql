/*================================================================================================================================================
==================================================================================================================================================

	Day04_실습
    
==================================================================================================================================================
=================================================================================================================================================*/

/*________________________________________________________________________________________________________________________________________________

	서브쿼리(SubQuery) : 메인 쿼리에 다른 쿼리를 추가하여 실행하는 방식
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	select [컬럼리스트 : (스칼라서브쿼리)] / 스칼라서브쿼리는 사용을 권장하지 않고 지양함, 속도가 엄청 느려서 효율성이 떨어져 오라클은 절대 쓰지 말 것을 권해 아예 지원하지 않음
	        from [테이블명 : (인라인뷰)]
	        where [조건절 : (서브쿼리)]
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

use hrdb2019;
select database();
show tables;

-- 정보시스템 부서명의 사원들을 모두 조회
-- 사번, 사원명, 부서아이디, 폰번호, 급여
-- 이너 조인으로 처리하면 복잡성이 증가하게 되어 이너 조인보다는 서브쿼리를 사용하게 됨
select *					-- < 여기부터
from employee
where dept_id = '정보시스템';	-- > 여기까지 메인 쿼리 단위



/*________________________________________________________________________________________________________________________________________________

	서브쿼리 : 단일행
	서브쿼리를 먼저 작성하고 출력 정상 유무 확인 후 괄호 처리
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 정보시스템 부서명의 사원들을 모두 조회
-- 사번, 사원명, 부서아이디, 폰번호, 급여
select emp_id, emp_name, dept_id, phone, salary
from employee
where dept_id = (select dept_id from department where dept_name = '정보시스템');

select dept_id from department where dept_name = '정보시스템';



/*________________________________________________________________________________________________________________________________________________

	스칼라 서브쿼리 : mysql에서는 에러가 뜨지 않음
	불러오는 값이 적으면 문제없지만, 불러오는 값이 많아질수록 로드가 무거워짐
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 정보시스템 부서명의 사원들을 모두 조회
-- 사번, 사원명, 부서아이디, 부서명(부서테이블), 폰번호, 급여
select emp_id, emp_name, dept_id,
	   (select dept_name from department where dept_name = '정보시스템') as dept_name, -- 사용은 되지만 권장하지 않음
	   phone, salary
from employee
where dept_id = (select dept_id from department where dept_name = '정보시스템');

select dept_name from department where dept_name = '정보시스템';



/*________________________________________________________________________________________________________________________________________________

	서브쿼리 : 단일행
	'=' 로 조건절을 비교하는 경우 :: 단일행 서브쿼리
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 홍길동 사원이 속한 부서명을 조회
select dept_name 
from department
where dept_id = (select dept_id from employee where emp_name = '홍길동'); -- and나 or을 사용할 경우 다중행 서브쿼리 처리임

select dept_id from employee where emp_name = '홍길동';

-- 홍길동 사원의 휴가사용 내역을 조회
select *
from vacation
where emp_id = (select emp_id from employee where emp_name = '홍길동');

-- 제3본부에 속한 모든 부서를 조회
select *
from department
where unit_id = (select unit_id from unit where unit_name = '제3본부');

-- 급여가 가장 높은 사원의 정보 조회
select *
from employee
where salary = (select max(salary) as salary from employee);

-- 급여가 가장 낮은 사원의 정보 조회
select *
from employee
where salary = (select min(salary) as salary from employee);

-- 가장 빨리 입사한 사원의 정보 조회
select *
from employee
where hire_date = (select min(hire_date) as hire_date from employee);

-- 가장 최근 입사한 사원의 정보 조회
select *
from employee
where hire_date = (select max(hire_date) as hire_date from employee);



/*________________________________________________________________________________________________________________________________________________

	서브쿼리 : 다중행 - IN
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- '제3본부'에 속한 모든 사원 정보 조회
select *
from employee
where dept_id = (select dept_id -- 단일행 출력인데 다중행을 가져오고 있어 에러 발생
	             from department
	             where unit_id = (select unit_id from unit where unit_name = '제3본부')
); -- 1번 처리 : 유닛 > 2번 처리 : 디파트먼트 > 3번 처리 : 임플로이

select *
from employee
where dept_id in (select dept_id
	              from department
	              where unit_id = (select unit_id from unit where unit_name = '제3본부')
); -- > select * from employee where dept_id in (a, b);

-- '제3본부'에 속한 모든 사원들의 휴가 사용 내역 조회
select *
from vacation
where emp_id in (select emp_id
				 from employee
				 where dept_id in (select dept_id
	                               from department
	                               where unit_id = (select unit_id from unit where unit_name = '제3본부')
	                               )
);



/*________________________________________________________________________________________________________________________________________________

	서브쿼리 > 인라인뷰 : 메인쿼리의 테이블 자리에 들어가는 서브쿼리 형식
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 사원별 휴가사용 일수를 그룹핑하여 사원아이디, 사원명, 입사일, 연봉, 휴가사용일수를 조회
-- 휴가를 사용한 사원정보만
select e.emp_id, e.emp_name, e.hire_date, e.salary, v.duration
from employee e, (select emp_id, sum(duration) as duration
	              from vacation
	              group by emp_id) v -- 별칭 붙이지 않으면 에러 발생, 별칭 꼭 추가
where e.emp_id = v.emp_id;

-- 휴가를 사용 + 사용하지 않은 사원정보 모두 포함
-- 휴가를 사용하지 않은 사원은 기본값 0
-- 사용일수 기준 내림차순 정렬
-- left outer join
select e.emp_id, e.emp_name, e.hire_date, e.salary, ifnull(v.duration, 0) as duration
from employee e
	 left outer join (select emp_id, sum(duration) as duration
	                  from vacation
	                  group by emp_id) v
on e.emp_id = v.emp_id
order by duration desc;

-- ansi : inner join
select e.emp_id, e.emp_name, e.hire_date, e.salary, ifnull(v.duration, 0) as duration
from employee e
	 inner join (select emp_id, sum(duration) as duration
	             from vacation
	             group by emp_id) v
on e.emp_id = v.emp_id;

-- (1) 2016년도부터 2017년도까지 입사한 사원들 조회
select *
from employee
where left(hire_date, 4) between '2016' and '2017';

-- (2) 1번의 실행 결과와 vacation 테이블을 조인하여 휴가사용 내역 조회
select *
from vacation v, (select *
	              from employee
	              where left(hire_date, 4) between '2016' and '2017') e
where v.emp_id = e.emp_id;

-- (1) 부서별 총급여, 평균급여를 구하여 30000 이상인 부서 조회
select dept_id, sum(salary) as sum, avg(salary) as avg
from employee
group by dept_id
having sum(salary) >= 30000;

-- (2) 1번의 실행 결과와 employee 테이블을 조인하여 사원아이디, 사원명, 급여, 부서아이디, 부서명, 부서별 총급여, 평균급여 조회
select e.emp_id, e.emp_name, e.salary, e.dept_id, d.dept_name, t.sum, t.avg
from employee e,
	 department d, (select dept_id, sum(salary) as sum, avg(salary) as avg
	                from employee
	                group by dept_id
	                having sum(salary) >= 30000) t
where e.dept_id = d.dept_id and d.dept_id = t.dept_id;



/*________________________________________________________________________________________________________________________________________________

	테이블 결과 합치기 : union, union all
	서브쿼리로 사용할 수 있므면 서브쿼리로 진행하나 사용할 수 없을 경우 union 사용, 각각 실행하고 조합해 느려져 속도 저하로 왠만하면 사용 지양
	연결되지 않은 각각의 테이블을 출력하고 합치는 마지막 수단으로 실행, 시간이 오히려 더 나을 경우도 있으니 성능 고려시 옵션으로 사용할 수도 있음
	** 실행결과 컬럼이 동일(컬럼명, 데이터타입)
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	쿼리1 실행 결과 union 쿼리2 실행 결과 (똑같은 아이만 필터링해서 결과 출력)
	쿼리1 실행 결과 union all 쿼리2 실행 결과 (합집합으로 결과 출력)
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 영업부, 정보시스템 부서의 사원아이디, 사원명, 급여, 부서아이디 조회
-- > 영업부 부서의 사원 ~ 부서아이디까지 가져오고 그 다음에 정부시스템 부서의 사원 ~ 부서아이디까지 가져와 합침
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업');

select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '정보시스템');

-- > union : 중복되는 row를 제외하고 출력 > 영업 부서 사원들이 한번만 출력
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업')
union
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업')
union
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '정보시스템');

-- > union : 중복되는 row를 포함하고 출력 > 영업 부서 사원들이 중복되어 출력
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업')
union all
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업')
union all
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '정보시스템');

select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업')
union
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업')
union
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '영업')
union all
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '정보시스템')
union
select emp_id, emp_name, salary, dept_id from employee where dept_id = (select dept_id from department where dept_name = '정보시스템');



/*________________________________________________________________________________________________________________________________________________

	논리적인 테이블 : VIEW(뷰), SQL을 실행하여 생성된 결과를 가상테이블로 정의 (매크로처럼 뷰 이름으로 저장해놓고 꺼내쓰는 식)
	양이 많아질수록 메모리 효율성 떨어짐
    
	(1) 뷰 생성 : create view [view 이름]
	                         as (SQL 정의);
	
	(2) 뷰 삭제 : drop view [view 이름]
	                       as (SQL 정의);
    
	** 뷰 생성시 권한을 할당 받아야 함 - mysql, maria 제외 (권한 할당 자동으로 되어 있음) > 권한 문제로 막아두는 경우도 있음
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

select *
from information_schema.views; -- 내부 정보 관리하는 주체

select *
from information_schema.views
where table_schema = 'hrdb2019'; -- 현재 생성된 게 아무것도 없어서 내용은 출력되지 않음 / 아래 부서 총급여 가상의 테이블 생성후 재조회시 내용 출력

-- 부서 총급여가 30000 이상인 테이블
create view view_salary_sum
as
select e.emp_id, e.emp_name, e.salary, e.dept_id, d.dept_name, t.sum, t.avg
from employee e,
	 department d, (select dept_id, sum(salary) as sum, avg(salary) as avg
	                from employee
	                group by dept_id
	                having sum(salary) >= 30000) t
where e.dept_id = d.dept_id and d.dept_id = t.dept_id;

select *
from information_schema.views
where table_schema = 'hrdb2019'; -- 위의 부서 총급여 가상의 테이블 생성후 재조회시 내용 출력

-- (1) view_salary_sum 실행 / 쿼리가 확 줄어듬
select *
from view_salary_sum;

-- (2) view_salary_sum 삭제
drop view view_salary_sum;
select * from information_schema.views
where table_schema = 'hrdb2019';



/*________________________________________________________________________________________________________________________________________________

	DDL (Data Definition Language) : 생성, 수정, 삭제 - 테이블 기준
	DML : C(insert), R(select), U(update), D(delete)
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 모든 테이블 목록
show tables;



/*________________________________________________________________________________________________________________________________________________

	테이블 생성
	데이터 타입 : 정수형(int, long ...), 실수형(float, double), 문자형(char, varchar, longtext ...)
	           이진데이터(longblob) 날짜형(date, datetime) ...
	char(고정형 문자형) : 크기가 메모리에 고정되는 형식
	                   char(10) --> 3자리 입력 : 7자리 낭비
	varchar(가변형 문자형) : 실제 저장되는 데이터 크기에 따라메모리가 변경되는 형식 (너무 크면 동작 안함)
	                      varchar(10) --> 3자리 입력 : 메모리 실제 3자리 공간만 생성
	longtext : 문장형태로 다수의 문자열을 저장
	longblob : 이진데이터 타입의 이미지, 동영상 등 데이터 저장
	date : 년, 월, 일
	datetime : 년, 월, 일, 시, 분,초 ->sysdate(), now()
	나머지 자세한 내용은 책 챕터 4에 있으니 참조
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	create table [테이블명] (
	              컬럼명	데이터타입(크기),
	              ...
	);
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

desc employee;
select * from employee;

-- (1) 테이블 생성
-- emp_id : (char, 4), ename " (varchar, 10), gender : (char, 1), hire_date : (datetime), salary: (int)
show tables;
create table emp(
	emp_id		char(4),
	ename		varchar(10),
	gender		char(4),
	hire_date	datetime,
	salary		int
);

select * from information_schema.tables
where table_schema = 'hrdb2019';

desc emp;

-- (2) 테이블 삭제
show tables;
drop table emp;

-- (3) 테이블 복제 - view[가상의 테이블]와 달리 물리적[실제의 테이블]으로 생성됨
    
-- 	형식 _____________________________________________________________________________________________________________________________________
    
-- 	create table [테이블명]
-- 	              as [SQL 정의]

-- __________________________________________________________________________________________________________________________________________

-- employee 테이블을 복제하여 emp 테이블 생성
create table emp
as
select * from employee;

show tables;
select * from emp;
desc employee;
desc emp;

-- 2016년도에 입사한 사원의 정보를 복제 : employee_2016
create table employee_2016
as
select * from employee where left(hire_date, 4) = '2016';

show tables;
select * from employee_2016; -- 복제는 보통 테스트를 위해 사용됨



/*________________________________________________________________________________________________________________________________________________

	데이터 생성 (insert : C)
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	insert into [테이블명] ({컬럼리스트 ...}) <- 이부분은 생략 가능하나 되도록 넣는 것을 권장
	             values(데이터1, 데이터2 ...)

-------------------------------------------------------------------------------------------------------------------------------------------------*/

show tables;
drop table emp;
show tables;

create table emp(
	emp_id		char(4),
	ename		varchar(10),
	gender		char(4),
	hire_date	datetime,
	salary		int
);

desc emp;
select * from employee;

insert into emp(emp_id, ename, gender, hire_date, salary)
	        values('s001', '홍길동', 'm', now(), '1000'); -- 정석적인 방식은 타입을 맞춰서 1:1 매핑 순서 준수해야 함

insert into emp(ename, emp_id, gender, hire_date, salary)
	        values('s001', '홍길동', 'm', now(), '1000'); -- 키 정의가 없어 중복된 내용이 들어갈 수 있음

insert into emp(ename, emp_id, gender, salary, hire_date)
	        values('s001', '홍길동', 'm', now(), '1000'); -- 데이트타임 타입과 인트 타입이 1:1 매핑이 되지 않아 에러 발생하는 케이스

insert into emp(ename, emp_id, gender, salary, hire_date)
	        values('s001', '홍길동', 'm', '1000'); -- 타입 개수와 값의 개수를 맞추지 않아 에러 발생하는 케이스

insert into emp(ename, emp_id, gender, salary, hire_date)
	        values('s001', '홍길동', 'm', '1000', null); -- desc emp 출력 후 null 값 정의 보면 YES로 되어 있어 null 값 들어감

insert into emp(emp_id)
	        values('s002'); -- null 허용 컬럼은 null 입력하지 않아도 디폴트로 자동으로 null이 들어감

select * from emp;



/*________________________________________________________________________________________________________________________________________________

	테이블 절삭 : 테이블의 데이터만 영구 삭제 - truncate 수행시 롤백은 불가하며 롤백을 고려한다면 delete로 수행해야 함
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	truncate table [테이블];
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

truncate table emp;
select * from emp;
show tables;
drop table emp;
show tables;

create table emp(
	emp_id		char(4)			not null,
	ename		varchar(10)		not null,
	gender		char(4)			not null,
	hire_date	datetime,
	salary		int
);

desc emp;
insert into emp(emp_id, ename, gender, hire_date, salary)
	        values('s001', '홍길동', 'm', now(), 1000); -- into 없이 insert만 입력해야하는 db 종류가 있고, into를 포함해야하는 db가 있음
         
insert into emp
	        values('s002', '이순신', 'm', sysdate(), 2000); -- 빼고 진행할 수 있으나 넣고 진행하는 것을 추천
         
insert into emp -- 
	        values(3000, 's003', '김유신', 'm', sysdate()); -- 지정된 입력 값 범위()를 벗어나 에러 발생하는 케이스
         
insert into emp -- 
	        values('s003', null, 'm', sysdate(), 2000); -- null 비허용으로 에러 발생하는 케이스
         
insert into emp -- 
	        values('s003', '김유신', 'm', sysdate(), 3000);
         
desc emp; -- desc 상의 필드 순서대로 입력됨
select * from emp;



/*________________________________________________________________________________________________________________________________________________

	자동 행번호 생성 (auto_increment) : 게시판에서 글 작성할때 자동으로 카운트 처리하는 기능 담당, 아이디 제외 다른 타입에 대부분 적용
	정수형으로 번호를 생성하여 저장함, pk, unique 제약으로 설정된 컬럼에 주로 사용
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

create table emp2(
	emp_id		int				auto_increment		primary key, -- primary key : unique + not null (중복되면 안되고, not null되면 안될때 사용)
	ename		varchar(10)		not null,
	gender		char(1)			not null,
	hire_date	date,
	salary		int
);

show tables;
desc emp2;

insert into emp2(ename, gender, hire_date, salary)
	        values('홍길동', 'm', now(), 1000); -- auto_increment로 emp2()와 values에 지정하지 않아도 진행됨
          
select * from emp2;



/*________________________________________________________________________________________________________________________________________________

	테이블 변경 : alter table
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	alter table [테이블명]
	             add column [새로 추가하는 컬럼명, 데이터타입] - null 허용으로 해야 진행되며 사이에 추가 안되고 가장 끝에 추가됨
	             modify column  [변경하는 컬럼명, 데이터타입] - 크기 고려 (데이터베이스는 입력한 값을 보존하는 것이 최우선으로 크기가 작아져 유실되는 경우는 있어선 안됨)
	             drop column	[삭제하는 컬럼명]
                 
-------------------------------------------------------------------------------------------------------------------------------------------------*/

show tables;
select * from emp;

-- phone(char, 13) 컬럼 추가, null 허용 (데이터가 없는 상태면 상관없음)
alter table emp
	        add column phone char(13) not null; -- 오라클은 add만 입력, 컬럼은 생략됨, 데이터가 없는데 넣으려고 하면 오라클은 에러나며 진행안됨

desc emp;
select * from emp;

-- phone 컬럼 삭제
alter table emp
	        drop column phone;
    
select * from emp;

alter table emp
	        add column phone char(13) null;
    
desc emp;
select * from emp;

insert into emp
	        values('s004', '홍홍', 'f', now(), 4000, '010-1234-5678');
    
select * from emp;

-- phone 컬럼의 크기 변경 : char(13) -> char(10)
alter table emp
	        modify column phone char(10) null; -- 저장된 데이터보다 크기가 작으면 에러 발생, 데이터 유실 위험 발생으로 진행 안됨
    
alter table emp
	        modify column phone char(20) null; -- 크기가 커지는건 가능함
    
desc emp;

alter table emp
	        modify column phone char(13) null;

-- phone 컬럼 삭제
alter table emp
	        drop column phone;



/*________________________________________________________________________________________________________________________________________________

	데이터 수정 (update : U)
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	update [테이블명]
	        set [컬럼리스트 ...]
	        where [조건절 ~]
	** set sql_safe_update = 1 or 0; / 오라클은 안뜨나 mysql은 뜸
	   - 1 : 업데이트 불가, 업데이트 모듈을 사용하지 못하게 막음 - mysql 워크벤치 실행시마다 초기화되어 디폴트 보호모드로 시작됨
	   - 0 : 업데이트 가능

-------------------------------------------------------------------------------------------------------------------------------------------------*/

select * from emp;

-- 홍길동의 급여를 6000으로 수정
update emp
	   set salary = 6000; -- 이렇게 주면 전원이 다 바뀜

update emp
	   set salary = 6000
	   where emp_id = 's001'; -- 업데이트 불가 에러 발생
    
set sql_safe_updates = 0; -- 업데이트 보호모드 해제 / 워크벤치 실행시마다 초기화되어 보호모드 자동 실행됨, 릴리즈 버전마다 달라질 수 있음

update emp
	   set salary = 6000
	   where emp_id = 's001';

select * from emp;

-- 김유신의 입사날짜를 '20210725'로 수정
update emp
-- 	   set hire_date = '20210725' -- 문자열인 내용이 데이터타입 데이트로 바꿔야 하나 자동 변환되어 바로 진행됨
-- 	   set hire_date = cast('20210725', datetime) -- 오라클은 무조건 ,로 구분하나 mysql에서는 동작안함
	   set hire_date = cast('20210725' as datetime)
	   where emp_id = 's003';

select * from emp;

-- emp2 테이블에 retire_date 컬럼추가 : date, null 허용으로 추가
-- 기존 데이터는 현재 날짜로 업데이트
-- 업데이트 완료 후 retire_date의 설정을 'not null'로 변경
alter table emp2
	        add column retire_date date null;
    
update emp2
	   set retire_date = curdate()
	   where retire_date is null;

select * from emp2;
    
desc emp2;
alter table emp2
	        modify column retire_date date not null;
desc emp2;

select * from emp2;



/*________________________________________________________________________________________________________________________________________________

	데이터 삭제 (delete : D)
    
	형식 -------------------------------------------------------------------------------------------------------------------------------------
    
	delete from [테이블명]
	             where [조건절 ~]
	** set sql_safe_update = 1 or 0; / 오라클은 안뜨나 mysql은 뜸
	   - 1 : 업데이트 불가, 업데이트 모듈을 사용하지 못하게 막음 - mysql 워크벤치 실행시마다 초기화되어 디폴트 보호모드로 시작됨
	   - 0 : 업데이트 가능

-------------------------------------------------------------------------------------------------------------------------------------------------*/

select * from emp;

-- 이순신 사원 삭제
delete from emp
	        where emp_id = 's002'; -- 아이디값을 모르고 이름만 알 경우 서브쿼리로도 진행 가능

select * from emp;
-- truncate는 row 그 자체를 없애버려서 복구가 안됨, delete는 표시처리로 진행해 복구됨

rollback; -- 오토커밋은 대부분 비활성화(disable = false)가 디폴트임, mysql은 디폴트(enable = ture)가 활성화되어 롤백 동작안함, 실행시마다 트랜젝션이 완료, 완료 처리되고 있는 상태

-- s004 사원 삭제
delete from emp
	        where emp_id = 's004';
select * from emp;

rollback;
select * from emp;

select @@autocommit; -- 명령어 트랜젝션 배울때 같이 배울 예정
set autocommit = 0; -- 1일 경우 바로 트랜젝션 진행

-- 다음주 학사 관리 테이블 설계 진행





