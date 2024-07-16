/*
    < SELECT >
    1. DQL (DATA QUERY LANGUAGE) 명령문
    2. 데이터 조회시 사용 (조회결과물을 RESULT SET이라함)
    3. 데이터의 변경은 발생되지 않음
    4. 표현법
        SELECT 조회할컬럼, 컬럼, .., 산술식, 함수식, .. AS "별칭"
          FROM 조회할테이블
         WHERE 조회할 데이터의 조건식
         GROUP BY 그룹핑시킬 컬럼, 컬럼, ..
        HAVING 그룹에 대한 조건식
         ORDER BY 정렬기준 
*/

-- EMPLOYEE 테이블에 전사원의 모든 컬럼(*) 조회
SELECT * FROM EMPLOYEE;

-- EMPLOYEE 테이블에 전사원의 사번, 이름, 급여만 조회
SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE;

select emp_id, emp_name, salary
from employee;
-- oracle 예약어(키워드), 테이블명, 컬럼명 들은 대소문자 가리지 않음 (단, 실제 담겨잇는 데이터값은 대소문자 가림!)
-- 테이블명 또는 컬럼명 여러단어로 조합할 경우 낙타표현법 불가능 => 단어들마다 주로 _로 구분함

--------------- 실습 -----------------
-- 1. JOB 테이블에 모든 컬럼 조회
SELECT * 
FROM JOB;
-- 2. JOB 테이블에 직급명 컬럼만 조회
SELECT JOB_NAME 
FROM JOB;
-- 3. DEPARTMENT 테이블 모든 컬럼 조회
SELECT * 
FROM DEPARTMENT;
-- 4. DEPARTMENT 테이블에 부서코드, 부서명 컬럼만 조회 
SELECT DEPT_ID, DEPT_TITLE 
FROM DEPARTMENT;
-- 5. EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회 
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM EMPLOYEE;

/*
    1. 컬럼값을 통한 산술연산
       SELECT절에 산술연산식 작성시 해당 컬럼을 통한 산술연산 결과가 조회됨
*/

-- EMPLOYEE에 사원명, 사원의 연봉(급여*12) 조회
SELECT EMP_NAME, SALARY * 12
FROM EMPLOYEE;

-- EMPLOYEE에 사원명, 급여, 보너스, 연봉, 보너스포함된연봉((급여 + 보너스*급여)*12) 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + SALARY*BONUS) * 12
FROM EMPLOYEE;
--> 산술연산과정 중 NULL이 포함될 경우 산술연산결과 마저도 NULL로 조회

-- EMPLOYEE에 사원명, 입사일, 근무일수(오늘날짜-입사일)
-- DATE 형식간에 산술연산 가능 
-- * SYSDATE : 현재 시스템의 날짜 및 시간 
SELECT SYSDATE FROM DUAL; -- DUAL테이블 == DUMMY테이블 : 테이블이 필요없는 경우 작성하는 가상의 테이블

SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
FROM EMPLOYEE;
-- DATE - DATE : 결과값은 일 단위로 나옴
-- 단, 값이 지저분한 이유는 시간까지도 연산이 수행되었기 때문 

/*
    2. 컬럼에 별칭 부여하기
       조회시 보여질 컬럼명에 별칭을 부여할 수 있음
       
       [표현법]
       컬럼명|산술식 [AS] 별칭|"별칭"
       
       [유의사항]
       부여할 별칭에 띄어쓰기 혹은 특수문자가 포함될 경우
       반드시 ""로 별칭을 표현해야됨
*/

SELECT EMP_ID 사번, EMP_NAME AS 사원명
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY, 
       SALARY * 12 "연봉(원)", 
       (SALARY + BONUS*SALARY) * 12 AS "총 소득" 
FROM EMPLOYEE;

/*
    3. 리터럴 
       임의로 지정한 문자('')값을 리터럴이라고 함 
       SELECT절에 리터럴값을 제시하면 마치 존재하는 데이터처럼 같이 조회 가능
*/
-- 사원의 사번, 사원명, 급여, 단위 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위
FROM EMPLOYEE;

/*
    4. 연결연산자 : ||
       여러 컬럼값들을 마치 하나의 컬럼인것처럼 연결해서 조회하거나
       또는 컬럼값과 리터럴값을 연결해서 조회할 때 사용
       
       System.out.println("num : " + num); // 여기서의 +와 같은 느낌
*/

SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

-- XXX의 월급은 XXX원입니다.
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원입니다.'
FROM EMPLOYEE;

/*
    5. DISTINCT 
       조회되는 컬럼값들 중에 중복된 값은 한번씩만 조회
       
       [유의사항]
       DISTINCT는 SELECT 절에 딱 한번만 기술 가능
*/
-- 사원들이 어떤 직급에 분포되어있는지 
SELECT JOB_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE
FROM EMPLOYEE;

-- 사원들이 어떤 부서에 분포되어있는지
SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE;

-- 오류나는 구문
SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE
FROM EMPLOYEE;

SELECT DISTINCT JOB_CODE, DEPT_CODE
FROM EMPLOYEE;
-- (JOB_CODE, DEPT_CODE) 쌍으로 묶어서 중복 판별

-- ============================================================================

/*
    < WHERE 절 >
    
    1. 특정 조건에 만족하는 데이터만을 조회할 때 조건식을 작성하는 구문
    2. 다양한 연산자를 통해 참/거짓이 나오도록 조건식 작성
    3. 작성위치는 FROM절 뒤에 작성
    4. 표현법
        SELECT 컬럼, 산술식, 함수식, .. [AS] 별칭
          FROM 테이블
         WHERE 조건식;
*/

/*
    1. 비교연산자
    
       대소비교 : >, <, >=, <=
       동등비교 : =, !=, ^=, <>
*/

-- 사원들 중 부서가 'D9'부서인 사원들만 조회 
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 사원들 중 부서가 'D1'부서인 사원들의 사번, 사원명, 급여, 부서코드만 조회 
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';







