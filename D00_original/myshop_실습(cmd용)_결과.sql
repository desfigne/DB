/*
	실습 데이터베이스 연결 : myshop2019
	실습 내용 - 기본적인 데이터 조회 
*/
USE MYSHOP2019;
SELECT DATABASE();

-- Q01) customer 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
DESC CUSTOMER;
SELECT * FROM CUSTOMER;

-- Q02) employee 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
DESC EMPLOYEE;
SELECT * FROM EMPLOYEE;

-- Q03) product 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
DESC PRODUCT;
SELECT * FROM PRODUCT;

-- Q04) order_header 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
DESC ORDER_HEADER;
SELECT * FROM ORDER_HEADER;

-- Q05) order_detail 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
DESC ORDER_DETAIL;
SELECT * FROM ORDER_DETAIL;

-- Q06) 모든 고객의 아이디, 이름, 지역, 성별, 이메일, 전화번호를 조회하세요.
SELECT CUSTOMER_ID, CUSTOMER_NAME, CITY, GENDER, EMAIL, PHONE 
	FROM CUSTOMER;

-- Q07) 모든 직원의 이름, 사원번호, 성별, 입사일, 전화번호를 조회하세요.
SELECT * FROM EMPLOYEE;
SELECT EMPLOYEE_NAME, EMPLOYEE_ID, GENDER, HIRE_DATE, PHONE
	FROM EMPLOYEE;

-- Q08) 이름이 '홍길동'인 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE CUSTOMER_NAME = '홍길동';
    
-- Q09) 여자 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE GENDER = 'F';
    
-- Q10) '울산' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE CITY = '울산';
    
-- Q11) 포인트가 500,000 이상인 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE GENDER = 'F';
    
-- Q12) 이름에 공백이 들어간 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE CUSTOMER_NAME LIKE '% %';
    
-- Q13) 전화번호가 010으로 시작하지 않는 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE PHONE NOT LIKE '010%';
    
-- Q14) 포인트가 500,000 이상 '서울' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE POINT >= 500000 AND CITY = '서울';
    
-- Q15) 포인트가 500,000 이상인 '서울' 이외 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE POINT >= 500000 AND CITY != '서울';
    
-- Q16) 포인트가 400,000 이상인 '서울' 지역 남자 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE POINT >= 400000 AND CITY = '서울' AND GENDER = 'M';
    
-- Q17) '강릉' 또는 '원주' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE CITY IN ('강릉', '원주');
    
-- Q18) '서울' 또는 '부산' 또는 '제주' 또는 '인천' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE CITY IN ('서울', '부산', '제주', '인천');

-- Q19) 포인트가 400,000 이상, 500,000 이하인 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, POINT
	FROM CUSTOMER
    WHERE POINT BETWEEN 400000 AND 500000 ;

-- Q20) 1990년에 출생한 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, BIRTH_DATE, POINT
	FROM CUSTOMER
    WHERE LEFT(BIRTH_DATE,4) = '1990' ; 

-- Q21) 1990년에 출생한 여자 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, BIRTH_DATE, POINT
	FROM CUSTOMER
    WHERE LEFT(BIRTH_DATE,4) = '1990' AND GENDER ='F' ; 

-- Q22) 1990년에 출생한 '대구' 또는 '경주' 지역 남자 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
SELECT CUSTOMER_NAME, CUSTOMER_ID, GENDER, CITY, PHONE, BIRTH_DATE, POINT
	FROM CUSTOMER
    WHERE LEFT(BIRTH_DATE,4) = '1990' AND CITY IN ('대구', '경주') AND GENDER ='M' ; 

-- Q23) 1990년에 출생한 남자 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
--      단, 홍길동(gildong) 형태로 이름과 아이디를 묶어서 조회하세요.
SELECT CONCAT(CUSTOMER_NAME, '(', CUSTOMER_ID, ')') CUSTOMER_NAME, GENDER, CITY, PHONE, BIRTH_DATE, POINT
	FROM CUSTOMER
    WHERE LEFT(BIRTH_DATE,4) = '1990' AND GENDER ='M' ; 

-- Q24) 근무중인 직원의 이름, 사원번호, 성별, 전화번호, 입사일를 조회하세요.
SELECT * FROM EMPLOYEE;
SELECT EMPLOYEE_NAME, EMPLOYEE_ID, GENDER, PHONE, HIRE_DATE
	FROM EMPLOYEE
	WHERE RETIRE_DATE IS NULL;
    
-- Q25) 근무중인 남자 직원의 이름, 사원번호, 성별, 전화번호, 입사일를 조회하세요.
SELECT EMPLOYEE_NAME, EMPLOYEE_ID, GENDER, PHONE, HIRE_DATE
	FROM EMPLOYEE
	WHERE RETIRE_DATE IS NULL AND GENDER = 'M';
    
-- Q26) 퇴사한 직원의 이름, 사원번호, 성별, 전화번호, 입사일, 퇴사일를 조회하세요.
SELECT EMPLOYEE_NAME, EMPLOYEE_ID, GENDER, PHONE, HIRE_DATE
	FROM EMPLOYEE
	WHERE RETIRE_DATE IS NOT NULL;

-- Q28) 2019-01-01 ~ 2019-01-07 기간 주문의 주문번호, 고객아이디, 사원번호, 주문일시, 소계, 배송비, 전체금액을 조회하세요.
--      단, 고객아이디를 기준으로 오름차순 정렬해서 조회하세요.
SELECT * FROM ORDER_HEADER;
SELECT ORDER_ID, CUSTOMER_ID, EMPLOYEE_ID, ORDER_DATE, SUB_TOTAL, DELIVERY_FEE, TOTAL_DUE
	FROM ORDER_HEADER
	WHERE ORDER_DATE BETWEEN '2019-01-01' AND '2019-01-07';
    
-- Q29) 2019-01-01 ~ 2019-01-07 기간 주문의 주문번호, 고객아이디, 사원번호, 주문일시, 소계, 배송비, 전체금액을 조회하세요.
--      단, 전체금액을 기준으로 내림차순 정렬해서 조회하세요.
SELECT ORDER_ID, CUSTOMER_ID, EMPLOYEE_ID, ORDER_DATE, SUB_TOTAL, DELIVERY_FEE, TOTAL_DUE
	FROM ORDER_HEADER
	WHERE ORDER_DATE BETWEEN '2019-01-01' AND '2019-01-07'
    ORDER BY TOTAL_DUE DESC;
    
-- Q30) 2019-01-01 ~ 2019-01-07 기간 주문의 주문번호, 고객아이디, 사원번호, 주문일시, 소계, 배송비, 전체금액을 조회하세요.
--      단, 사원번호를 기준으로 오름차순, 같은 사원번호는 주문일시를 기준으로 내림차순 정렬해서 조회하세요.
SELECT ORDER_ID, CUSTOMER_ID, EMPLOYEE_ID, ORDER_DATE, SUB_TOTAL, DELIVERY_FEE, TOTAL_DUE
	FROM ORDER_HEADER
	WHERE ORDER_DATE BETWEEN '2019-01-01' AND '2019-01-07'
    ORDER BY EMPLOYEE_ID ASC, ORDER_DATE DESC;
    
/**
	그룹함수
**/
/** customer 테이블 사용 **/
-- Q01) 고객의 포인트 합을 조회하세요.
SELECT SUM(POINT) FROM CUSTOMER;
SELECT CONCAT(FORMAT(SUM(POINT),0), '원') AS POINT FROM CUSTOMER;

-- Q02) '서울' 지역 고객의 포인트 합을 조회하세요.
SELECT SUM(POINT) FROM CUSTOMER 
	WHERE CITY = '서울';
SELECT CONCAT(FORMAT(SUM(POINT),0), '원') AS POINT 
	FROM CUSTOMER
    WHERE CITY = '서울';

-- Q03) '서울' 지역 고객의 수를 조회하세요.
SELECT COUNT(*) FROM CUSTOMER
	WHERE CITY = '서울';

-- Q04) '서울' 지역 고객의 포인트 합과 평균을 조회하세요.
SELECT SUM(POINT), AVG(POINT) FROM CUSTOMER
	WHERE CITY = '서울';
     
-- Q05) '서울' 지역 고객의 포인트 합, 평균, 최댓값, 최솟값을 조회하세요.
SELECT SUM(POINT), AVG(POINT), MAX(POINT), MIN(POINT)
	FROM CUSTOMER WHERE CITY = '서울';

-- Q06) 남녀별 고객의 수를 조회하세요.
SELECT GENDER, COUNT(GENDER) FROM CUSTOMER GROUP BY GENDER;

SELECT  CASE GENDER
			WHEN 'M'  THEN '남자'
			ELSE '여자'
        END
        AS GENDER
        , COUNT(GENDER) 
FROM CUSTOMER 
GROUP BY GENDER;

-- Q07) 지역별 고객의 수를 조회하세요.
--      단, 지역 이름을 기준으로 오름차순 정렬해서 조회하세요.
SELECT CITY, COUNT(CITY) 
	FROM CUSTOMER 
    GROUP BY CITY;
 
-- Q08) 지역별 고객의 수를 조회하세요.
--      단, 고객의 수가 10명 이상인 행만 지역 이름을 기준으로 오름차순 정렬해서 조회하세요.
SELECT CITY, COUNT(CITY) COUNT
	FROM CUSTOMER 
    GROUP BY CITY
    HAVING COUNT >= 10;
    
-- Q09) 남녀별 포인트 합을 조회하세요.
SELECT GENDER, SUM(POINT) FROM CUSTOMER GROUP BY GENDER;

SELECT CASE GENDER WHEN 'M' THEN '남자'
		ELSE '여자' END AS GENDER, SUM(POINT)
	FROM CUSTOMER
    GROUP BY GENDER;
    
-- Q10) 지역별 포인트 합을 조회하세요.
--      단, 지역 이름을 기준으로 오름차순 정렬해서 조회하세요.
SELECT CITY, SUM(POINT)
	FROM CUSTOMER
    GROUP BY CITY
    ORDER BY CITY;
    
-- Q11) 지역별 포인트 합을 조회하세요.
--      단, 포인트 합이 1,000,000 이상인 행만 포인트 합을 기준으로 내림차순 정렬해서 조회하세요.
SELECT CITY, SUM(POINT) TOT_POINT
	FROM CUSTOMER
    GROUP BY CITY
    HAVING TOT_POINT >= 1000000
    ORDER BY TOT_POINT DESC;
      
-- Q12) 지역별 포인트 합을 조회하세요.
--      단, 포인트 합을 기준으로 내림차순 정렬해서 조회하세요.
  SELECT CITY, SUM(POINT) TOT_POINT
	FROM CUSTOMER
    GROUP BY CITY
    ORDER BY TOT_POINT DESC; 

-- Q13) 지역별 고객의 수, 포인트 합을 조회하세요.
--      단, 지역 이름을 기준으로 오름차순 정렬해서 조회하세요.
SELECT CITY, COUNT(CITY), SUM(POINT)
	FROM CUSTOMER
    GROUP BY CITY
    ORDER BY CITY DESC;

-- Q14) 지역별 포인트 합, 포인트 평균을 조회하세요.
--      단, 포인트가 NULL이 아닌 고객을 대상으로 하며, 지역 이름을 기준으로 오름차순 정렬해서 조회하세요.
SELECT CITY, SUM(POINT), AVG(POINT)
	FROM CUSTOMER
    WHERE POINT IS NOT NULL
    GROUP BY CITY
    ORDER BY CITY DESC;

-- Q15) '서울', '부산', '대구' 지역 고객의 지역별, 남녀별 포인트 합과 평균을 조회하세요.
--      단, 지역 이름을 기준으로 오름차순, 같은 지역은 성별을 기준으로 오름차순 정렬해서 조회하세요.
SELECT CITY, GENDER, SUM(POINT), AVG(POINT)
	FROM CUSTOMER
    WHERE CITY IN ('서울', '부산', '대구')
    GROUP BY CITY, GENDER
    ORDER BY CITY ASC, GENDER ASC;
    

/** order_header 테이블 사용 **/    
-- Q16) 2019년 1월 주문에 대하여 고객아이디별 전체금액 합을 조회하세요.
SELECT * FROM ORDER_HEADER;
SELECT CUSTOMER_ID, SUM(TOTAL_DUE)
	FROM ORDER_HEADER
    WHERE LEFT(ORDER_DATE, 7) = '2019-01'
    GROUP BY CUSTOMER_ID;

-- Q17) 주문연도별 전체금액 합계를 조회하세요.
SELECT LEFT(ORDER_DATE, 4) '주문연도', SUM(TOTAL_DUE) '전체합계'
	FROM ORDER_HEADER
    GROUP BY LEFT(ORDER_DATE, 4);

-- Q18) 2019.01 ~ 2019.06 기간 주문에 대하여 주문연도별, 주문월별 전체금액 합을 조회하세요.
SELECT LEFT(ORDER_DATE, 4) 주문연도, SUBSTRING(ORDER_DATE, 6,2) 주문월, SUM(TOTAL_DUE) 전체금액
	FROM ORDER_HEADER
	WHERE LEFT(ORDER_DATE, 7) BETWEEN '2019-01' AND '2019-06'
    GROUP BY LEFT(ORDER_DATE, 4), SUBSTRING(ORDER_DATE, 6,2);  

-- Q19) 2019.01 ~ 2019.06 기간 주문에 대하여 주문연도별, 주문월별 전체금액 합과 평균을 조회하세요.
SELECT 	LEFT(ORDER_DATE, 4) 주문연도, 
		SUBSTRING(ORDER_DATE, 6,2) 주문월, 
        SUM(TOTAL_DUE) 전체금액,
        AVG(TOTAL_DUE) 평균
	FROM ORDER_HEADER
	WHERE LEFT(ORDER_DATE, 7) BETWEEN '2019-01' AND '2019-06'
    GROUP BY LEFT(ORDER_DATE, 4), SUBSTRING(ORDER_DATE, 6,2);  

-- Q20) 주문연도별, 주문월별 전체금액 합과 평균을 조회하고, rollup 함수를 이용하여 소계와 총계를 출력해주세요.
SELECT  if(grouping(YEAR), '연도별 총합계', ifnull(YEAR, '-')) 주문연도,
		IF(GROUPING(MONTH), '월별 총합계',  IFNULL(MONTH, '-')) 주문월,
        SUM(TOTAL_DUE),
        AVG(TOTAL_DUE)
FROM	(SELECT LEFT(ORDER_DATE, 4) YEAR, 
				SUBSTRING(ORDER_DATE, 6,2) MONTH,
                TOTAL_DUE
			FROM ORDER_HEADER
		) T
            GROUP BY YEAR, MONTH WITH ROLLUP
;  



/**
	테이블 조인
*/
-- Q01) 전체금액이 8,500,000 이상인 주문의 주문번호, 고객아이디, 사원번호, 주문일시, 전체금액을 조회하세요.
-- Q02) 위에서 작성한 쿼리문을 복사해 붙여 넣은 후 고객이름도 같이 조회되게 수정하세요.
-- Q03) Q01 쿼리를 복사해 붙여 넣은 후 직원이름도 같이 조회되게 수정하세요.
-- Q04) 위에서 작성한 쿼리문을 복사해 붙여 넣은 후 고객이름, 직원이름도 같이 조회되게 수정하세요.
-- Q05) 위에서 작성한 쿼리문을 복사해 붙여 넣은 후 전체금액이 8,500,000 이상인 '서울' 지역 고객만 조회되게 수정하세요.
-- Q06) 위에서 작성한 쿼리문을 복사해 붙여 넣은 후 전체금액이 8,500,000 이상인 '서울' 지역 '남자' 고객만 조회되게 수정하세요.
-- Q07) 주문수량이 30개 이상인 주문의 주문번호, 상품코드, 주문수량, 단가, 지불금액을 조회하세요.
-- Q08) 위에서 작성한 쿼리문을 복사해서 붙여 넣은 후 상품이름도 같이 조회되도록 수정하세요.
-- Q09) 상품코드, 상품이름, 소분류아이디를 조회하세요.
-- Q10) 위에서 작성한 쿼리문을 복사해서 붙여 넣은 후 소분류이름, 대분류아이디가 조회되게 수정하세요.
-- Q11) 다정한 사원이 2019년에 주문한 상품명을 모두 출력해주세요.
-- Q12) 청소기를 구입한 고객아이디, 사원번호, 주문번호, 주문일시를 조회하세요.
    

/**
	서브쿼리
*/
-- Q13) 'mtkim', 'odoh', 'soyoukim', 'winterkim' 고객 주문의 주문번호, 고객아이디, 주문일시, 전체금액을 조회하세요.    
-- Q14) '전주' 지역 고객의 아이디를 조회하세요.    
-- Q15) 위 두 쿼리문을 조합해서 하위 쿼리를 사용해 '전주' 지역 고객 주문의 주문번호, 고객아이디, 주문일시, 전체금액을 조회하세요.
-- Q16) 고객의 포인트 최댓값을 조회하세요.
-- Q17) 하위 쿼리를 사용해 가장 포인트가 많은 고객의 이름, 아이디, 등록일, 포인트를 조회하세요.
-- Q18) 하위 쿼리를 사용해 홍길동(gdhong) 고객보다 포인트가 많은 고객 이름, 아이디, 등록일, 포인트를 조회하세요.
-- Q19) 하위 쿼리를 사용해 홍길동(gdhong) 고객과 같은 지역의 고객 이름, 아이디, 지역, 등록일, 포인트를 조회하세요.
--      단, 고객 이름을 기준으로 오름차순 정렬해서 조회하세요.
-- Q20) 하위 쿼리를 사용해 홍길동(gdhong) 고객보다 포인트가 많은 고객 이름, 아이디, 등록일, 포인트를 조회하고, 행번호를 추가하여 출력하세요.

    










