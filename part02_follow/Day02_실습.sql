/*================================================================================================================================================
==================================================================================================================================================

	Day02_실습
    
==================================================================================================================================================
=================================================================================================================================================*/

/*________________________________________________________________________________________________________________________________________________

	내장 함수 : 숫자 함수, 문자 함수, 날짜 함수
	호출되는 위치 - [컬럼리스트], [조건절의 컬럼명]
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

USE HRDB2019;
SELECT DATABASE();
SHOW TABLES;



/*________________________________________________________________________________________________________________________________________________

	숫자 함수
	함수 실습을 위한 테이블 : DUAL 테이블
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- (1) abs(숫자) : 절대값
select abs(100), abs(-100) from dual;

-- (2) floor(숫자), truncate(숫자, 자리수) : 소수점 버리기
select floor(123.456), truncate(123.456, 0), truncate(123.456, 1) from dual;

-- 사원테이블의 sys부서 사원들의 사원명, 부서아이디, 폰번호, 급여, 보너스(급여의 25%) 컬럼을 추가하여 조회
select emp_name, emp_id, phone, salary, salary*0.25 as bonus from employee where dept_id = 'sys';

-- 보너스 컬럼은 소수점 1자리로 출력
select emp_name, emp_id, phone, salary, truncate(salary*0.25, 1) as bonus from employee where dept_id = 'sys';

-- (3) RAND() : 임의의 수를 난수로 발생시키는 함수이며 0 ~ 1 사이의 난수를 생성 (RAND : 랜덤의 약자)
select rand() from dual;
select floor(rand() * 1000) as randnumber from dual; -- 정수 3자리(0 ~ 999) 난수 발생

-- 정수 4자리(0 ~ 9999) 난수 발생, 소수점 2자리
select truncate(rand() * 10000, 2) as randnumber from dual;

-- (4) mod(숫자, 나누는 수) : 나머지 함수
select mod(123, 2) as odd, mod(124, 2) as even from dual;

-- 3자리 수를 랜덤으로 발생시켜 2로 나눈 후 홀수, 짝수를 구분
select mod(floor(rand() * 1000), 2) as result from dual;
select mod(truncate(rand() * 1000, 0), 2) as result from dual;
select floor(rand() * 1000) as result01, mod(truncate(rand() * 1000, 0), 2) as result02 from dual;



/*________________________________________________________________________________________________________________________________________________

	문자 함수
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- (1) concat(문자열1, 문자열2 ...) : 문자열 합쳐주는 함수
select concat('안녕하세요~ ', '홍길동', '입니다.') as str;

-- 사번, 사원명, 사원명2 컬럼을 생성하여 조회
-- 사원명2 컬럼의 데이터 형식은 S0001(홍길동) 출력
select emp_id, emp_name, concat(emp_id, ' ( ', emp_name, ' )') as emp_name2 from employee;

-- 사번, 사원명, 영어이름, 입사일, 폰번호, 급여를 조회
select emp_id, emp_name, eng_name, hire_date, phone, salary from employee;

-- 영어이름의 출력형식을 '홍길동/hong' 타입으로 출력
select emp_id, concat(emp_name, ' / ', eng_name) as eng_name, hire_date, phone, salary from employee;

-- 영어이름이 null인 경우에는 'smith'를 기본으로 조회
-- 따옴표는 싱글과 더블 혼용 가능하나 실제로 사용시에는 기준에 맞춰 하나만 사용해야 함
select emp_id, concat(emp_name, " / ", ifnull(eng_name, 'smith')) as eng_name, hire_date, phone, salary from employee;

-- (2) substring(문자열, 위치, 갯수) : 문자열 추출
select substring('대한민국 홍길동', 1, 4), -- 메모리 구조가 아니기에 인덱스가 0번으로 시작안함, 저장소 관련 작업만 인덱스가 1번으로 시작함
	   substring('대한민국 홍길동', 1, 5), -- 공백도 하나의 문자로 인식하여 처리
	   substring('대한민국 홍길동', 6, 3) from dual;

-- 사원테이블의 사번, 사원명, 입사년도, 입사월, 입사일, 급여를 조회
select * from employee;
select emp_id, emp_name, substring(hire_date, 1, 4) as 입사년도, substring(hire_date, 6, 2) as 입사월, substring(hire_date, 9, 2) as 입사일, salary from employee;

-- 2015년도에 입사한 모든 사원 조회
-- select * from employee where hire_date = '2015'; -- 실제 데이터에는 년도 외에 월과 일이 들어가져 있어 진행 안됨
select * from employee where substring(hire_date, 1, 4) = '2015';

-- 2018년도에 입사한 정보시스템(sys) 부서 사원 조회
select * from employee where substring(hire_date, 1, 4) = '2018' and dept_id = 'sys';

-- (3) left(문자열, 갯수), right(문자열, 갯수) : 왼쪽, 오른쪽 기준으로 문자열 추출
select curdate() from dual;
select left(curdate(), 4) as year, right('010-1234-5678', 4) as phone from dual;

-- 2018년도에 입사한 모든 사원 조회
select * from employee where left(hire_date, 4) = '2018';

-- 2015년부터 2017년 사이에 입사한 모든 사원 조회
select * from employee where left(hire_date, 4) between '2015' and '2017';

-- 사원번호, 사원명, 입사일, 폰번호, 급여를 조회
-- 폰번호는 마지막 4자리만 출력
select emp_id, emp_name, hire_date, right(phone, 4) as phone, salary from employee;

-- (4) upper(문자열), lower(문자열) : 대문자, 소문자로 치환 / 오라클에서는 뒤에 케이스가 붙음, uppercase, lowercase
select upper('welcomeToMysql~!'), lower('welcomeToMysql~!') from dual;

-- 사번, 사원명, 영어이름, 부서아이디, 이메일, 급여를 조회
-- 영어이름은 전체 대문자, 부서아이디는 소문자, 이메일은 대문자
select emp_id, emp_name,
	   upper(eng_name) as eng_name,
	   lower(dept_id) as dept_id,
	   upper(email) as email, salary from employee;

-- (5) trim() : 공백 제거 / 중간에 있는 공백은 제거 안됨
select trim('         대한민국') as t1,
	   trim('대한민국         ') as t2,
	   trim('대한         민국') as t3,
	   trim('     대한민국    ') as t4 from dual;

-- (6) format(문자열, 소수점자리) : 문자열 포맷
select format(123456, 0) as format from dual; -- 낮은 버전에서는 인식이 안됨
select format('123456', 0) as format from dual;

-- 사번, 사원명, 입사일, 폰번호, 급여, 보너스(급여의 20%)
-- 급여, 보너스는 소수점 없이 3자리 콤마(,)로 구분하여 출력
select emp_id, emp_name, hire_date, phone, format(salary, 0) as salary, format(salary *0.2, 0) as bonus from employee;

-- 급여가 null인 경우에는 기본값 0
select emp_id, emp_name, hire_date, phone, format(ifnull(salary, 0), 0) as salary, format(ifnull(salary,0) *0.2, 0) as bonus from employee;

-- 2015년부터 2017년 사이에 입사한 사원을 조회
-- 사번 기준으로 내림차순 정렬
select emp_id, emp_name, hire_date, phone,
format(ifnull(salary, 0), 0) as salary,
format(ifnull(salary,0) *0.2, 0) as bonus from employee
where left(hire_date, 4) between '2016' and '2017'
order by emp_id desc;



/*________________________________________________________________________________________________________________________________________________

	날짜 함수
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- curdate() : 현재 날짜(년, 월, 일)를 가지고 옴
-- sysdate(), now() : 현재 날짜(년, 월, 일, 시, 분, 초) / 가입하거나 주문할 경우 사용
select curdate(), sysdate(), now() from dual;



/*________________________________________________________________________________________________________________________________________________

	형변환 함수
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- cast(변환하고자 하는 값 as 데이터 타입) / 사용 시 이걸로 진행하면 됨
-- convert(변환하고자 하는 값 as 데이터 타입) / MySQL에서 이전에 사용하던 Old 버전
select 1234 as number, cast(1234 as char) as string from dual; -- 1234 숫자가 문자열(스트링)로 전환됨
select '1234' as string, cast('1234' as signed integer) as number from dual;
select '20250723' as string, cast('20250723' as date) as date from dual; -- 페이지에서 가져오는 날짜 데이터는 문자열이므로 date 타입으로 변환하면 하이픈으로 구분됨
select now() as date,
	   cast(now() as char) as string,
	   cast(cast(now() as char) as date) as date,
	   cast(cast(now() as char) as datetime) as date,
	   curdate() as date_time_before,
	   cast(curdate() as datetime) as datetime
from dual;

select'12345' as string,
	   cast('12345' as signed integer) as cast_int,
	   cast('12345' as unsigned integer) as cast_int,
	   cast('12345' as decimal(10, 2)) as cast_decinal
from dual;



/*________________________________________________________________________________________________________________________________________________

	문자 치환 함수
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- replace(문자열, old, new)
select '홍-길-동' as old, replace('홍-길-동', '-', ',') as new from dual;

-- 사원 테이블의 사번, 사원명, 입사일, 퇴사일, 부서아이디, 폰번호, 급여를 조회
-- 입사일, 퇴사일 출력은 '-'을 '/'로 치환하여 출력
-- 재직중인 사원은 현재 날짜를 출력
-- 급여 출력시 3자리 콤마(,) 구분
select emp_id, emp_name,
	   -- replace(cast(hire_date as char), '-', '/') as hire_date, // 이렇게 줘도 되지만 버전이 올라가면서 자동으로 처리되어 안해도 됨, 그러나 이게 정석 / 모든 디비에 적용되지는 않음
	   replace(hire_date, '-', '/') as hire_date,
	   replace(ifnull(retire_date, curdate()), '-', '/') as retire_date,
	   phone, format(salary, 0) as salary
from employee;

-- '20150101' 입력된 날짜를 기준으로 해당 날짜 이후에 입사한 사원들을 모두 조회
-- 조건 없을 경우
select * from employee where hire_date >= '20150101'; -- 오라클은 자동으로 변환해주지 않음, 자동 전환은 지양하는 편

-- 모든 mysql 데이터베이스에서 적용 가능한 형태로 작성
select * from employee where hire_date >= cast('20150101' as date);

-- '20150101' ~ '20171231' 사이에 입사한 사원들을 모두 조회
-- 모든 mysql 데이터베이스에서 적용 가능한 형태로 작성
select * from employee where hire_date between cast('20150101' as date) and cast('20171231' as date);

-- 조건 없을 경우
select * from employee where hire_date between '20150101' and '20171231';



/*________________________________________________________________________________________________________________________________________________

	그룹(집계) 함수 : sum(), avg(), min(), max(), count() ...
	group by - 그룹 함수를 적용하기 위한 그룹핑 컬럼 정의
	having - 그룹 함수에서 사용하는 조건절 (where 절은 따로 별개임, having은 그룹 함수 내에서만)
	** 그룹 함수는 그룹핑이 가능한 반복된 데이터를 가진 컬럼과 사용하는게 더 올바름
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- (1) sum(숫자) : 전체 총합을 구하는 함수
-- 사원들 전체의 급여 총액을 조회, 3자리 구분, 마지막 '만원' 추가 표시
select concat(format(sum(salary),0), '만원') as 총급여 from employee;

-- select emp_id, sum(salary) from employee; / 함께 사용 불가
-- select emp_id, sum(salary) from employee group by emp_id; / 유니크한 항목에는 그룹핑이 안되므로 의미가 없음

-- (2) avg(숫자) : 전체 평균을 구하는 함수
-- 사원들 전체의 급여 평균을 조회, 3자리 구분, 앞에 '$' 표시
-- 소수점은 절삭
select floor(avg(salary)) as 평균급여 from employee;
select format(avg(salary), 0) as 평균급여 from employee;
select concat('$', format(avg(salary), 0)) as 평균급여 from employee;

-- 정보시스템(sys) 부서 전체의 급여 총액과 평균을 조회
-- 3자리 구분, 마지막 '만원' 표시
select concat(format(sum(salary), 0), '만원') as 평균급여, concat(format(avg(salary), 0), '만원') as 총급여 from employee where dept_id = 'sys';

-- (3) max(숫자) : 최대값 구하는 함수
-- 가장 높은 급여를 받는 사원의 급여를 조회
select max(salary) from employee;

-- (4) min(숫자) : 최소값 구하는 함수
-- 가장 낮은 급여를 받는 사원의 급여를 조회
select min(salary) from employee;

-- 사원들의 총급여, 평균급여, 최대급여, 최소급여를 조회
-- 3자리 구분
select format(sum(salary), 0) as 총급여,
	   format(avg(salary), 0) as 평균급여,
	   format(max(salary), 0) as 최대급여,
	   format(min(salary), 0) as 최소급여
from employee;

-- (5) count(컬럼) : 조건에 맞는 데이터의 row 수를 조회, null은 제외
-- 전체 로우 수
select count(*) from employee; -- 20

-- 급여 컬럼의 row count
select count(salary) from employee; -- 19, null은 카운트에서 제외됨

-- 재직중인 사원의 row count
select count(hire_date) as 재직사원 from employee where retire_date is null;
select count(*) as 재직사원 from employee where retire_date is null;
select count(*) as 총사원, count(retire_date) as 퇴사자, count(*) - count(retire_date) as 재직자 from employee;

-- '2015'년도 입사자 수
select count(*) from employee where left(hire_date, 4) = '2015';

-- 정보시스템(sys) 부서의 사원수
select count(*) from employee where dept_id = 'sys';

-- 가장 빠른 입사자, 가장 늦은 입사자를 조회 : max(), min() 함수를 사용
select min(hire_date), max(hire_date) from employee;

-- 가장 빨리 입사한 사람의 정보를 조회 - 서브 쿼리로 그룹 함수 사용, 쿼리 함수중 서브 쿼리 함수를 제일 주로 씀
select * from employee where hire_date = (select min(hire_date) from employee);



/*________________________________________________________________________________________________________________________________________________

	그룹(집계) 함수 > group by : 그룹 함수와 일반 컬럼을 함께 사용할 수 있도록 함
	~별 그룹핑이 가능한 컬럼으로 쿼리를 실행
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 부서별 총급여, 평균급여, 사원수, 최대급여, 최소급여 조회
select dept_id, sum(salary), avg(salary), count(*), max(salary), min(salary) from employee group by dept_id;
-- select ~ from ~ where 까지는 한 그룹임, 그 이후 그룹 바이를 붙임

-- 연도별 사원수, 총급여, 평균급여, 최대급여, 최소급여 조회
-- 소수점 X, 3자리 구분
select left(hire_date, 4) 연도,
	   count(*) 사원수,
	   format(sum(salary), 0) 총급여,
	   format(avg(salary), 0) 평균급여,
	   format(max(salary), 0) 최대급여,
	   format(min(salary), 0) 최소급여
from employee
group by left(hire_date, 4);

-- 사원별 총급여, 평균급여 조회 / 사원 각각의 row가 나오기 때문에 그룹 바이는 효과가 없음



/*________________________________________________________________________________________________________________________________________________

	그룹(집계) 함수 > having 조건절 : 그룹 함수를 적용한 결과에 조건을 추가
	그룹으로 산출된 결과가 나오고 나서 그 결과 값에서 조건을 적용
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 부서별 총급여, 평균급여를 조회
-- 부서의 총급여가 30000이상인 부서만 출력
-- 급여 컬럼의 null은 제외
select dept_id,
	   format(sum(salary), 0) 총급여,
	   format(avg(salary), 0) 평균급여
from employee
where salary is not null
group by dept_id
having sum(salary) >= 30000;

-- 연도별 사원수, 총급여, 평균급여, 최대급여, 최소급여 조회
-- 소수점 X, 3자리 구분
-- 총급여가 30000 이상인 년도 출력
-- 급여 협상이 안된 사원은 제외 (salary가 null인 사원은 제외)
select left(hire_date, 4) 연도,
	   count(*) 사원수,
	   format(sum(salary), 0) 총급여,
	   format(avg(salary), 0) 평균급여,
	   format(max(salary), 0) 최대급여,
	   format(min(salary), 0) 최소급여
from employee
where salary is not null
group by left(hire_date, 4)
having sum(salary) >= 30000;



/*________________________________________________________________________________________________________________________________________________

	rollup 함수 : 리포팅을 위한 함수
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

-- 부서별 사원수, 총급여, 평균급여 조회
select dept_id 부서,
	   count(*) 사원수,
	   format(sum(ifnull(salary, 0)), 0) 총급여,
	   format(avg(ifnull(salary, 0)), 0) 평균급여
from employee
group by dept_id with rollup;

-- rollup한 결과의 부서 아이디를 추가
-- 부서별 사원수, 총급여, 평균급여 조회
select if(grouping(dept_id), '총합계', ifnull(dept_id, '-')) 부서명,
	   count(*) 사원수,
	   format(sum(ifnull(salary, 0)), 0) 총급여,
	   format(avg(ifnull(salary, 0)), 0) 평균급여
from employee
group by dept_id with rollup;

-- 연도별 사원수, 총급여, 평균급여, 최대급여, 최소급여 조회
-- 소수점 X, 3자리 구분
-- 총급여가 30000 이상인 년도 출력
-- 급여 협상이 안된 사원은 제외 (salary가 null인 사원은 제외)
-- select if(grouping(left(hire_date, 4)), '총합계', ifnull(dept_id, '-')) 연도, / 함수가 있기에 동작 안함, 사용 빈도가 낮아 버전 릴리즈에 반영되지 않음
select left(hire_date, 4) 연도,
	   count(*) 사원수,
	   format(sum(salary), 0) 총급여,
	   format(avg(salary), 0) 평균급여,
	   format(max(salary), 0) 최대급여,
	   format(min(salary), 0) 최소급여
from employee
where salary is not null
group by left(hire_date, 4)
having sum(salary) >= 30000;



/*________________________________________________________________________________________________________________________________________________

	limit 함수 : 출력 갯수 제한 함수
    
-------------------------------------------------------------------------------------------------------------------------------------------------*/

select * from employee limit 3;

-- 최대급여를 수급하는 사원을 순서대로 5명까지 출력
select * from employee order by salary desc limit 5;
-- mysql에만 limit 개념이 있고 다른 db에는 리미트가 없어 다른 방식으로 처리





