/**
* MySQL 실습

===================================================================================================================================================

section 01. 개요

===================================================================================================================================================

MySQL :: 정형 데이터를 저장하는 데이터베이스

- SQL 문법을 사용하여 데이터를 CRUD 한다.
  C(Create: 생성, insert)
  R(Read  : 조회, select)
  U(Update: 수정, update)
  D(Delete: 삭제, delete)
  
- 개발자는 DML에 대한 CRUD 명령어를 잘 사용할 수 있어야 한다.
  자바 학습시 어레이리스트에 사용하던 CRUD를 DB로 대체해서 사용이 가능하다.
  
- SQL은 대소문자 구분하지 않음, 보통 소문자로 작성
  snake 방식의 네이밍 규칙을 가짐
  
- SQL은 크게 DDL, DML, DCL, DTL로 구분할 수 있다. (이 중에 특히 DML을 잘해야 한다.)
** 실무에서는 직접 작성하고 생성하기보단 권한을 받아 작업을 진행하는 경우가 많음

1. DDL (Data Definition Language) : 데이터 정의어
  : 데이터를 저장하기 위한 공간을 생성하고 논리적으로 정의하는 언어
  > create, alter, truncate, drop
  
2. DML (Data Manipuation Language) : 데이터 조작어
  : 데이터를 CRUD하는 명령어
  > insert, select, update, delete
  
3. DCL (Data Control Language) : 데이터 제어어
  : 데이터에 대한 권한과 보안을 정의하는 언어
  > grant, revoke
  
4. DTL(TCL이라고도 함) (Data Transaction Language, TCL) : 트랜잭션 제어어
  : 데이터베이스의 처리 작원 단위인 트랜잭션을 관리하는 언어
  > commit, save, rollback

-- "--"은 주석 처리(단축키는 "컨트롤 + /"), 번개 표시 누르면 표시됨, 컨트롤 + 엔터 눌러도 나옴
-- 글자 사이에 간격이 있어도 ;까지를 한 줄의 명령어로 인식

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 반드시 기억해주세요 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

show databases;
: 모든 데이터베이스 조회
> 1. 가장 먼저 데이터베이스 리스트를 불러옴 (1. 번개 버튼 또는 컨트롤+엔터)
   
use hrdb2019;
: 사용할 데이터베이스 오픈
> 2. 그 다음 사용할 데이터베이스를 열기 (2. 번개 버튼 또는 컨트롤+엔터)
   
select database();
: 데이터베이스 선택, 여기까지 진행해야 테이블을 사용할 수 있음
> 3. 그 다음 데이터베이스 선택 (3. 번개 버튼 또는 컨트롤+엔터)
   
show tables;
: 데이터베이스의 모든 테이블 조회
> 4. 그 다음 테이블 조회 (4. 번개 버튼 또는 컨트롤+엔터)

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
워크벤치 프로그램 실행시 마다 초기화되는 명령어 실행해야 하므로 외워야 함
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

===================================================================================================================================================

section 02. 실습

===================================================================================================================================================
*/
  
show databases;			-- 모든 데이터베이스 조회
use hrdb2019;			-- 사용할 데이터베이스 오픈
select database();		-- 데이터베이스 선택, 여기까지 진행해야 테이블을 사용할 수 있음
show tables;			-- 데이터베이스의 모든 테이블 조회

use market_db;
select database();
show tables;

use hrdb2019;
select database();
show tables;

/*************************************************************************************************************************************************
	DESC (DESCRIBE) : 테이블 구조 확인
    형식 > desc(describe) [테이블명];
    
**************************************************************************************************************************************************/
show tables;
desc employee;
desc department;
desc unit;
desc vacation;

/*************************************************************************************************************************************************
	SELECT : 테이블 내용 조회
    형식 > SELECT [컬럼리스트] FROM [테이블명];
    
**************************************************************************************************************************************************/
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;
SELECT EMP_NAME, GENDER, HIRE_DATE FROM EMPLOYEE;

-- 사원테이블의 사번, 사원명, 성별, 입사일, 급여를 조회
DESC EMPLOYEE;
SELECT EMP_ID, EMP_NAME, GENDER, HIRE_DATE, SALARY
FROM EMPLOYEE;

-- 부서테이블의 모든 정보를 조회
SHOW TABLES;
SELECT *
FROM DEPARTMENT;

/*************************************************************************************************************************************************
	AS : 컬럼명 별칭 부여
    형식 > SELECT [컬럼명 as 별칭,, ...] FROM [테이블명];
    
**************************************************************************************************************************************************/
-- 사원테이블의 사번, 사원명, 성별, 입사일, 급여 컬럼을 조회한 한글 컬럼명으로 출력 (공백이 들어가는 경우 따옴표로 감싸주면 됨, AS를 생략하고도 사용이 가능함, 오라클은 주로 이렇게 사용)
SELECT EMP_ID AS 사번, EMP_NAME AS "사 원 명", GENDER AS 성별, HIRE_DATE 입사일, SALARY 급여
FROM EMPLOYEE;

-- 사원테이블의 ID, NAME, GENDER, HDATE, SALARY 컬럼명으로 조회
SELECT EMP_ID AS ID, EMP_NAME AS NAME, GENDER, HIRE_DATE AS HDATE, SALARY
FROM EMPLOYEE;

-- 사원테이블의 사번, 사원명, 부서명, 폰번호, 이메일, 급여, 보너스(급여*10%)를 조회 (기존의 컬럼에 연산을 수행하여 새로운 컬럼을 생성할 수 있다.)
DESC EMPLOYEE;
SELECT EMP_ID, EMP_NAME, DEPT_ID, PHONE, EMAIL, SALARY, SALARY*10 AS BONUS
FROM EMPLOYEE;

/*************************************************************************************************************************************************
	CURDATE() : 현재 날짜 조회
    임시로 사용하는 테스트용 테이블을 생성
    
**************************************************************************************************************************************************/
-- SELECT CURDATE() FROM DUAL;
SELECT CURDATE() AS DATE FROM DUAL;

/*************************************************************************************************************************************************
	SELECT : 테이블 내용 상세 조회
    형식 > SELECT [컬럼리스트]
			FROM [테이블명]
			WHERE [조건절];
            
**************************************************************************************************************************************************/
-- 정주고 사원의 정보를 조회
-- SELECT * FROM EMPLOYEE WHERE EMP_NAME = 정주고; -- 에러 발생 사유는 CHAR가 문자열이기 때문에 감싸줘야함
SELECT * FROM EMPLOYEE WHERE EMP_NAME = "정주고";
SELECT * FROM EMPLOYEE WHERE EMP_NAME = '정주고'; -- 싱글 쿼테이션 ''와 더블 쿼테이션 "" 모두 사용 가능

-- SYS 부서에 속한 모든 사원을 조회
SELECT * FROM EMPLOYEE WHERE DEPT_ID = 'SYS';
SELECT * FROM EMPLOYEE WHERE DEPT_ID = 'sys'; -- 오라클은 대소문자 정확해야 동작, MySQL은 대소문자 모두 가능

-- 사번이 S0005인 사원의 사원명, 성별, 입사일, 부서아이디, 이메일, 급여를 조회
SELECT EMP_NAME, GENDER, HIRE_DATE, DEPT_ID, EMAIL, SALARY
FROM EMPLOYEE WHERE EMP_ID = 'S0005';

-- SYS 부서에 속한 모든 사원들을 조회, 단 출력되는 EMP_ID 컬럼은 '사원번호' 별칭으로 조회
SELECT * FROM EMPLOYEE;
-- SELECT EMP_ID AS '사원번호', * FROM EMPLOYEE WHERE DEPT_ID = "SYS"; -- 동작 안됨
SELECT EMP_ID AS '사원번호', EMP_NAME, ENG_NAME, GENDER, HIRE_DATE, SALARY
FROM EMPLOYEE WHERE DEPT_ID = 'SYS';

-- EMP_NAME '사원명' 별칭 수정
SELECT EMP_ID AS '사원번호', EMP_NAME AS '사원명', ENG_NAME, GENDER, HIRE_DATE, SALARY
FROM EMPLOYEE WHERE DEPT_ID = 'SYS';

-- WHERE 조건절 컬럼으로 별칭을 사용할 수 있을까요?
-- 사원명이 홍길동인 사원을 별칭으로 조회? ::: WHERE 조건절에서 별칭을 컬럼명으로 사용할 수 없음
SELECT EMP_ID AS '사원번호', EMP_NAME AS '사원명', ENG_NAME, GENDER, HIRE_DATE, SALARY
FROM EMPLOYEE WHERE 사원명 = '홍길동';
-- SELECT는 가장 마지막에 출력되는 결과값인 컬럼 리스트이기 때문에 별칭 조건절은 사용이 불가

-- 전략기획 부서의 모든 사원들의 사번, 사원명, 입사일, 급여를 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY FROM EMPLOYEE WHERE DEPT_ID = 'STG';

-- 입사일이 2014년 8월 1일인 사원들을 조회
SELECT * FROM EMPLOYEE WHERE HIRE_DATE = '2014-08-01'; -- DATE 타입은 표현은 문자열처럼, 처리는 숫자처럼

-- 급여가 5000인 사원들을 조회
SELECT * FROM EMPLOYEE WHERE SALARY = '5000';

-- 성별이 남자인 사원들을 조회
SELECT * FROM EMPLOYEE WHERE GENDER = 'M';

-- 성별이 여자인 사원들을 조회
SELECT * FROM EMPLOYEE WHERE GENDER = 'F';

/*************************************************************************************************************************************************
	NULL : 아직 정의되지 않은 미지수
	숫자에서는 가장 큰 수로 인식, 논리적인 의미를 포함하고 있으므로 등호(=)로는 검색 불가, IS 키워드와 함께 사용 가능
	값이 없다는 뜻이 아니라 아직 미정이라는 뜻, 0은 0이지만, NULL은 미지정의 숫자를 의미
	가장 큰 수가 들어갈 가능성이 있어 가장 큰 수, 미지수로 정의함, 리스트 정렬시 가장 마지막에 나옴
    
**************************************************************************************************************************************************/
-- 급여가 NULL인 값을 가진 사원들을 조회
-- SELECT * FROM EMPLOYEE WHERE SALARY = NULL; -- 조회 안됨
SELECT * FROM EMPLOYEE WHERE SALARY IS NULL;

-- 영어이름이 정해지지 않은 사원들을 조회
SELECT * FROM EMPLOYEE WHERE ENG_NAME IS NULL;

-- 퇴사하지 않은 사람들을 조회
SELECT * FROM EMPLOYEE WHERE RETIRE_DATE IS NULL;

-- 퇴사하지 않은 사람들의 보너스 컬럼(급여*20%)을 추가하여 조회, 컬럼명은 BONUS / *(아스타)는 지양
SELECT EMP_ID, EMP_NAME, ENG_NAME, GENDER, HIRE_DATE, RETIRE_DATE, DEPT_ID, PHONE, EMAIL, SALARY, SALARY*20 AS BONUS FROM EMPLOYEE WHERE RETIRE_DATE IS NULL;

/*************************************************************************************************************************************************
	IS NOT
    
**************************************************************************************************************************************************/
-- 퇴사한 사원들의 사번, 사원명, 이메일, 폰번호, 급여를 조회 / 반대일 경우 IS NOT 사용
SELECT EMP_ID, EMP_NAME, EMAIL, PHONE, SALARY FROM EMPLOYEE WHERE RETIRE_DATE IS NOT NULL;

/*************************************************************************************************************************************************
	IF NULL : NULL 값을 다른 값으로 대체하는 방법
    형식 > IFNULL(NULL포함 컬럼명, 대체값);
    
**************************************************************************************************************************************************/
-- STG 부서에 속한 사원들의 정보 조회, 단 급여가 NULL인 사원은 0으로 치환
SELECT EMP_ID, EMP_NAME, EMAIL, PHONE, IFNULL(SALARY, 0) AS SALARY FROM EMPLOYEE WHERE DEPT_ID ='STG';

-- 사원 전체 테이블의 내용을 조회, 단 영어이름이 정해지지 않은 사원들은 'SMITH' 이름으로 치환
SELECT EMP_ID, EMP_NAME, IFNULL(ENG_NAME, 'SMITH') AS ENG_NAME, GENDER, HIRE_DATE, RETIRE_DATE, DEPT_ID, PHONE, EMAIL, SALARY FROM EMPLOYEE;

-- MKT 부서의 사원들을 조회, 재직중인 사원들의 RETIRE_DATE 컬럼은 현재 날짜로 치환
SELECT EMP_ID, EMP_NAME, ENG_NAME, GENDER, HIRE_DATE, IFNULL(RETIRE_DATE, CURDATE()) AS RETIRE_DATE, DEPT_ID, PHONE, EMAIL, SALARY FROM EMPLOYEE WHERE DEPT_ID = 'MKT';

/*************************************************************************************************************************************************
	DISTINCT : 중복된 데이터를 배제하고 조회
    형식 > SELECT DISTINCT [컬럼리스트] ~
    
**************************************************************************************************************************************************/
-- 사원 테이블의 부서 리스트를 조회
SELECT DISTINCT DEPT_ID FROM EMPLOYEE;

-- 주의! UNIQUE한 컬럼과 함께 조회하는 경우 DISTINCT가 적용되지 않음
SELECT DISTINCT EMP_ID, DEPT_ID FROM EMPLOYEE;
SELECT DISTINCT DEPT_ID, EMP_ID FROM EMPLOYEE;

/*************************************************************************************************************************************************
	ORDER BY 컬럼 : 데이터 정렬
    정렬 후 넣는 것이 아닌, 가까운 빈 곳 아무 곳에 넣어버리기 때문에 정렬 명령어가 존재
    형식 > SELECT [컬럼리스트]
			FROM [테이블]
			WHERE [조건절]
            ORDER BY [컬럼명, , ...] ASC/DESC *하나가 아닌 여러개도 가능함 / 가장 마지막에 최종적 집합으로 정렬함
            
**************************************************************************************************************************************************/
-- 급여를 기준으로 오름차순 정렬
SELECT * FROM EMPLOYEE ORDER BY SALARY ASC; -- 오름차순은 생략 가능

-- 급여를 기준으로 내림차순 정렬
SELECT * FROM EMPLOYEE ORDER BY SALARY DESC;

-- 모든 사원을 급여, 성별을 기준으로 오름차순 정렬
SELECT * FROM EMPLOYEE ORDER BY SALARY, GENDER;

-- ENG_NAME이 NULL인 사원들을 입사일 기준으로 내림차순 정렬
SELECT * FROM EMPLOYEE WHERE ENG_NAME IS NULL ORDER BY HIRE_DATE DESC;

-- 퇴직한 사원들을 급여기준으로 내림차순 정렬
SELECT * FROM EMPLOYEE WHERE RETIRE_DATE IS NOT NULL ORDER BY SALARY DESC;

-- 퇴직한 사원들을 급여기준으로 내림차순 정렬, SALARY 컬럼을 '급여' 별칭으로 치환
-- '급여' 별칭으로 ORDER BY가 가능할까요? :: 별칭으로 ORDER BY 가능함
-- WHERE 조건절 데이터 탐색 > 컬럼리스트 > 정렬 순으로 진행
SELECT EMP_ID, EMP_NAME, ENG_NAME, GENDER, HIRE_DATE, RETIRE_DATE, DEPT_ID, PHONE, EMAIL, SALARY AS 급여 FROM EMPLOYEE WHERE RETIRE_DATE IS NOT NULL ORDER BY 급여 DESC;

-- 정보시스템(SYS) 부서 사원들 중 입사일이 빠른 순서, 급여를 많이 받는 순서로 정렬
-- HIRE_DATE, SALARY 컬럼은 '입사일', '급여' 별칭으로 컬럼리스트 생성 후 정렬
SELECT EMP_ID, EMP_NAME, ENG_NAME, GENDER, HIRE_DATE AS 입사일, RETIRE_DATE, DEPT_ID, PHONE, EMAIL, SALARY AS 급여 FROM EMPLOYEE WHERE DEPT_ID = 'SYS' ORDER BY 입사일, 급여 DESC;

/*************************************************************************************************************************************************
	WHERE 조건절 + 비교연산자 : 특정 범위 혹은 데이터 검색
    형식 > SELECT [컬럼리스트]
			FROM [테이블]
			WHERE [조건절]
            ORDER BY [컬럼명] ASC/DESC
            
**************************************************************************************************************************************************/
-- 급여가 5000 이상인 사원들을 조회
SELECT * FROM EMPLOYEE WHERE SALARY >= 5000;

-- 급여가 5000 이상인 사원들을 조회, 급여를 오름차순 정렬
SELECT * FROM EMPLOYEE WHERE SALARY >= 5000 ORDER BY SALARY;

-- 입사일이 2017-01-01 이후 입사한 사원들을 조회
SELECT * FROM EMPLOYEE WHERE HIRE_DATE > '2017-01-01';

-- 입사일이 2015-01-01 이후이거나 급여가 6000 이상인 사원들을 조회
-- ~이거나, ~ 또는 : OR - 두 개의 조건중 하나만 만족해도 조회 가능
SELECT * FROM EMPLOYEE WHERE HIRE_DATE >= '2015-01-01' OR SALARY >= 6000;

-- 입사일이 2015-01-01 이후이고 급여가 6000 이상인 사원들을 조회
-- ~이고 : AND - 두 개의 조건이 모두 만족해야만 조회 가능
SELECT * FROM EMPLOYEE WHERE HIRE_DATE >= '2015-01-01' AND SALARY >= 6000;

-- 특정 기간 : 2015-01-01 ~ 2017-12-31 사이에 입사한 모든 사원 조회
-- 부서기준으로 오름차순 정렬
SELECT * FROM EMPLOYEE WHERE HIRE_DATE >= '2015-01-01' AND HIRE_DATE <= '2017-12-31' ORDER BY DEPT_ID ASC;

-- 급여가 6000 이상 8000 이하인 사원들을 모두 조회
SELECT * FROM EMPLOYEE WHERE SALARY >= 6000 AND SALARY <= 8000;

-- MKT 부서의 사원들의 사번, 사원명, 입사일, 이메일, 급여, 보너스(급여의 20%) 조회
-- 급여가 NULL인 사원의 보너스는 기본 50
-- 보너스가 1000 이상인 사원 조회
-- 보너스가 높은 사원 기준으로 정렬
SELECT EMP_ID, EMP_NAME, HIRE_DATE, EMAIL, SALARY, IFNULL(SALARY*0.2, 50) AS BONUS
FROM EMPLOYEE
WHERE DEPT_ID = 'MKT' AND SALARY*0.2 >= 1000
ORDER BY BONUS DESC;

-- 사원명이 '일지매', '오삼식', '김삼순'인 사원들을 조회
SELECT * FROM EMPLOYEE WHERE EMP_NAME = '일지매' OR EMP_NAME = '오삼식' OR EMP_NAME = '김삼순';

/*************************************************************************************************************************************************
	@@@ 일반 비교연산자는 사용하지 않고 비교연산자보다 더 많이 사용함 @@@
    
	논리곱(AND) : BETWEEN ~ AND
    형식 > SELECT [컬럼리스트]
			FROM [테이블]
			WHERE [조건절] BETWEEN 값1 AND 값2;
            
	논리합(OR) : IN
    형식 > SELECT [컬럼리스트]
			FROM [테이블]
			WHERE [조건절] IN(값1, 값2, 값3 ...);
            
**************************************************************************************************************************************************/
-- BETWEEN ~ AND
-- 특정 기간 : 2015-01-01 ~ 2017-12-31 사이에 입사한 모든 사원 조회
-- 부서기준으로 오름차순 정렬
SELECT * FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '2015-01-01' AND '2017-12-31' ORDER BY DEPT_ID ASC;

-- 급여가 6000 이상 8000 이하인 사원들을 모두 조회
SELECT * FROM EMPLOYEE WHERE SALARY BETWEEN 6000 AND 8000;

-- 사원명이 '일지매', '오삼식', '김삼순'인 사원들을 조회
SELECT * FROM EMPLOYEE WHERE EMP_NAME IN ('일지매', '오삼식', '김삼순');

-- 부서 아이디가 MKT, SYS, STG에 속한 모든 사원 조회
SELECT * FROM EMPLOYEE WHERE DEPT_ID IN ('MKT', 'SYS', 'STG') ORDER BY DEPT_ID;

/*************************************************************************************************************************************************
	특정 문자열 검색 : 와일드 문자(%, _) + LIKE 연산자
					% : 전체, _ : 한글자
    형식 > SELECT [컬럼리스트]
			FROM [테이블]
			WHERE [조건절] LIKE '와일드 문자 포함 검색어';
            
**************************************************************************************************************************************************/
-- '한'씨 성을 가진 모든 사원을 조회
SELECT * FROM EMPLOYEE WHERE EMP_NAME LIKE '한%';

-- 영어 이름이 'f'로 시작하는 모든 사원을 조회
SELECT * FROM EMPLOYEE WHERE ENG_NAME LIKE 'f%';

-- 이메일 이름 중 두번째 자리에 'a'가 들어가는 모든 사원을 조회
SELECT * FROM EMPLOYEE WHERE EMAIL LIKE '_a%';

-- 이메일 아이디가 4자인 모든 사원을 조회
SELECT * FROM EMPLOYEE WHERE EMAIL LIKE '____@%';