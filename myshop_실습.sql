/******************************************************
		실습 데이터베이스 연결 : myshop2019
		실습 내용 - 기본적인 데이터 조회 	 
******************************************************/

show databases;
use myshop2019;
select database();
show tables;

/* ======================================================================================================== */

-- Q01) customer 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
select * from customer;
-- : customer_id / customer_name / gender
-- > 고객 아이디 / 고객 이름 / 고객 성별

-- : phone / email
-- > 고객 핸드폰 번호 / 고객 이메일

-- : city / birth_date / register_date
-- > 고객 거주 도시 / 고객 생일 / 고객 등록일

-- : point
-- > 고객 포인트

/* ======================================================================================================== */

-- Q02) employee 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
select * from employee;
-- : employee_id / employee_name / gender
-- > 직원 번호 / 직원 이름 / 직원 성별

-- : phone / email
-- > 직원 핸드폰 번호 / 직원 이메일

-- : hire_date / retire_date
-- > 직원 입사일 / 직원 퇴사일

/* ======================================================================================================== */

-- Q03) product 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
select * from product;
-- : product_id / product_name
-- > 제품 코드 / 제품 이름

-- : sub_category_id
-- > 하위 카테고리 코드

/* ======================================================================================================== */

-- Q04) order_header 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
select * from order_header;
-- : order_id / customer_id / employee_id
-- > 주문 번호 / 고객 아이디 / 직원 번호

-- : order_date
-- > 주문 일시

-- : sub_total / delivery_fee / total_due
-- > 제품 금액(왜 서브가 붙어있는지...?) / 배송비 / 총합 금액

/* ======================================================================================================== */

-- Q05) order_detail 테이블 모든 행과 열을 조회하고 어떤 열들이 있는지, 데이터 형식은 어떻게 되는지 살펴보세요.
select * from order_detail;
-- : order_id / order_detail_id (현재 오타로 order가 아닌 drder로 되어있는 것으로 추정) / product_id
-- > 주문 번호 / 주문 상세 번호 / 제품 코드

-- : order_qty / unit_price / discount / line_total
-- > 제품 주문 수량 / 제품 금액 / 할인가(총합 금액에서 1회 단일 할인) / 할인 제외 종합 금액

/* ======================================================================================================== */

-- Q06) 모든 고객의 아이디, 이름, 지역, 성별, 이메일, 전화번호를 조회하세요.
select * from customer;
select customer_id, customer_name, gender, email, phone from customer;

/* ======================================================================================================== */

-- Q07) 모든 직원의 이름, 사원번호, 성별, 입사일, 전화번호를 조회하세요.
select * from employee;
select employee_name, employee_id, gender, hire_date, phone from employee;

/* ======================================================================================================== */

-- Q08) 이름이 '홍길동'인 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where customer_name ='홍길동';

/* ======================================================================================================== */

-- Q09) 여자 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where gender = 'F';

/* ======================================================================================================== */

-- Q10) '울산' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where city = '울산';

/* ======================================================================================================== */

-- Q11) 포인트가 500,000 이상인 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where point >= 500000;

/* ======================================================================================================== */

-- Q12) 이름에 공백이 들어간 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where customer_name = null; -- 조회 안됨
select customer_name, customer_id, gender, city, phone, point from customer where customer_name is null;

/* ======================================================================================================== */

-- Q13) 전화번호가 010으로 시작하지 않는 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where phone not like '010%';

/* ======================================================================================================== */

-- Q14) 포인트가 500,000 이상 '서울' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where point >= 500000 and city = '서울';

/* ======================================================================================================== */

-- Q15) 포인트가 500,000 이상인 '서울' 이외 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where point >= 500000 and city not like '서울';

/* ======================================================================================================== */

-- Q16) 포인트가 400,000 이상인 '서울' 지역 남자 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where point >= 400000 and city = '서울' and gender ='M';

/* ======================================================================================================== */

-- Q17) '강릉' 또는 '원주' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where city = '강릉' or city = '원주';

/* ======================================================================================================== */

-- Q18) '서울' 또는 '부산' 또는 '제주' 또는 '인천' 지역 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where city = '서울' or city = '부산' or city = '제주' or city = '인천';

/* ======================================================================================================== */

-- Q19) 포인트가 400,000 이상, 500,000 이하인 고객의 이름, 아이디, 성별, 지역, 전화번호, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, point from customer where point >= 400000 and point <= 500000;

/* ======================================================================================================== */

-- Q20) 1990년에 출생한 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, birth_date, point from customer where birth_date like '1990-%';

/* ======================================================================================================== */

-- Q21) 1990년에 출생한 여자 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, birth_date, point from customer where gender = 'F' and birth_date like '1990-%';

/* ======================================================================================================== */

-- Q22) 1990년에 출생한 '대구' 또는 '경주' 지역 남자 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
select * from customer;
select customer_name, customer_id, gender, city, phone, birth_date, point from customer where gender = 'M' and birth_date like '1990-%' and (city ='대구' or city = '경주');

/* ======================================================================================================== */

-- Q23) 1990년에 출생한 남자 고객의 이름, 아이디, 성별, 지역, 전화번호, 생일, 포인트를 조회하세요.
--      단, 홍길동(gildong) 형태로 이름과 아이디를 묶어서 조회하세요.
select * from customer;
select concat(customer_name, '(', customer_id, ')') as '이름(아이디)', gender, city, phone, birth_date, point from customer where gender = 'M' and birth_date like '1990-%';

/* ======================================================================================================== */

-- Q24) 근무중인 직원의 이름, 사원번호, 성별, 전화번호, 입사일를 조회하세요.
select * from employee;
select employee_name, employee_id, gender, phone, hire_date from employee where retire_date is null;

/* ======================================================================================================== */

-- Q25) 근무중인 남자 직원의 이름, 사원번호, 성별, 전화번호, 입사일를 조회하세요.
select * from employee;
select employee_name, employee_id, gender, phone, hire_date from employee where gender = 'M' and retire_date is null;

/* ======================================================================================================== */

-- Q26) 퇴사한 직원의 이름, 사원번호, 성별, 전화번호, 입사일, 퇴사일를 조회하세요.
select * from employee;
select employee_name, employee_id, gender, phone, hire_date from employee where retire_date is not null;

/* ======================================================================================================== */

-- Q28) 2019-01-01 ~ 2019-01-07 기간 주문의 주문번호, 고객아이디, 사원번호, 주문일시, 소계, 배송비, 전체금액을 조회하세요.
--      단, 고객아이디를 기준으로 오름차순 정렬해서 조회하세요.
select * from order_header;
select order_id, customer_id, employee_id, order_date, sub_total, delivery_fee, total_due from order_header where order_date >= '2019-01-01' and order_date <= '2019-01-07' order by customer_id asc;
select order_id, customer_id, employee_id, order_date, sub_total, delivery_fee, total_due from order_header where order_date between '2019-01-01' and '2019-01-07' order by customer_id asc;

/* ======================================================================================================== */
    
-- Q29) 2019-01-01 ~ 2019-01-07 기간 주문의 주문번호, 고객아이디, 사원번호, 주문일시, 소계, 배송비, 전체금액을 조회하세요.
--      단, 전체금액을 기준으로 내림차순 정렬해서 조회하세요.
select * from order_header;
select order_id, customer_id, employee_id, order_date, sub_total, delivery_fee, total_due from order_header where order_date >= '2019-01-01' and order_date <= '2019-01-07' order by total_due desc;
select order_id, customer_id, employee_id, order_date, sub_total, delivery_fee, total_due from order_header where order_date between '2019-01-01' and '2019-01-07' order by total_due desc;


/* ======================================================================================================== */

-- Q30) 2019-01-01 ~ 2019-01-07 기간 주문의 주문번호, 고객아이디, 사원번호, 주문일시, 소계, 배송비, 전체금액을 조회하세요.
--      단, 사원번호를 기준으로 오름차순, 같은 사원번호는 주문일시를 기준으로 내림차순 정렬해서 조회하세요.
select * from order_header;
select order_id, customer_id, employee_id, order_date, sub_total, delivery_fee, total_due from order_header where order_date >= '2019-01-01' and order_date <= '2019-01-07' order by employee_id asc, order_date desc;
select order_id, customer_id, employee_id, order_date, sub_total, delivery_fee, total_due from order_header where order_date between '2019-01-01' and '2019-01-07' order by employee_id asc, order_date desc;