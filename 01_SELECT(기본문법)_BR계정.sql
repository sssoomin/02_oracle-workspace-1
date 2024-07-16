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
WHERE DEPT_CODE = 'D1'; -- 3명 

-- 사원들 중 'D1'부서가 아닌 사원들의 사번, 사원명, 부서코드만 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE
--WHERE DEPT_CODE != 'D1'; -- 18명 
--WHERE DEPT_CODE ^= 'D1';
WHERE DEPT_CODE <> 'D1';

-- 사원들 중 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여 조회 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= 4000000;

-------------------- 실습 --------------------
-- 1. 현재 재직중인 사원들의 사번, 이름, 입사일 조회 
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE ENT_YN = 'N';
-- 2. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회 
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY*12
FROM EMPLOYEE
WHERE SALARY >= 3000000;
-- 3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드, 퇴사여부 조회 
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE != 'J3';
-- 4. 연봉이 5000만원 이상인 사원들의 사원명, 급여, 연봉, 부서코드 조회 
SELECT EMP_NAME, SALARY, SALARY*12 "연봉", DEPT_CODE
FROM EMPLOYEE
--WHERE 연봉 >= 50000000; -- 오류(WHERE절에서 SELECT절에서 부여한 별칭 사용불가)
WHERE SALARY*12 >= 50000000;
-- 실행순서 : FROM절(테이블 전체데이터 다가져옴) --> WHERE절(조건에 만족하는 행들 추려짐) --> SELECT절(컬럼들이 골라져서 조회)

--------------------------------------------------------------

/*
    2. 논리 연산자 
       여러개의 조건을 엮어서 하나로 제시하고자 할 때 사용
       
       [표현법]
       A조건 AND B조건 : 두 조건 모두 참이여야만 최종 결과도 참 (자바에서의 &&)
       A조건 OR  B조건 : 두 조건 중 하나만 참이여도 최종 결과는 참 (자바에서의 ||)
*/

-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원들의 사원명, 부서코드, 급여
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' 
  AND SALARY >= 5000000;

-- 부서코드가 'D6'이거나 또는 급여가 300만원 이상인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' 
   OR SALARY >= 3000000;

-- 급여가 350만원 이상 600만원 이하를 받는 사원들의 사원명, 급여 조회 
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

/*
    3. BETWEEN AND 연산자
       몇 이상 몇 이하의 범위인지에 대한 조건을 제시할 때 사용되는 연산자
       
       [표현법]
       비교대상컬럼 BETWEEN 하한값 AND 상한값
*/
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY BETWEEN 3500000 AND 6000000; -- 6명

-- 그 외의 사원
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
--WHERE NOT SALARY BETWEEN 3500000 AND 6000000; -- 17행
WHERE SALARY NOT BETWEEN 3500000 AND 6000000;

-- * NOT : 논리부정연산자 (자바에서의 !같은 존재)
--         컬럼명 앞 또는 BETWEEN 앞에 기입 가능

-- 입사일이 90년대인 (90/01/01 ~ 99/12/31) 사원들의 모든 컬럼 조회
SELECT *
FROM EMPLOYEE
--WHERE HIRE_DATE >= '90/01/01' AND HIRE_DATE <= '99/12/31'; -- DATE 형식은 대소비교 가능
WHERE HIRE_DATE BETWEEN '90/01/01' AND '99/12/31';

/*
    4. LIKE 연산자 
       비교하고자하는 컬럼값이 내가 제시한 "특정 패턴"에 "만족"하는지를 비교할 때 사용
       
       [표현법]
       비교대상컬럼 LIKE '특정패턴'
       
       [참고사항]
       특정패턴 작성시 %, _를 와일드 카드로 사용할 수 있음
        ㄴ % : 0글자 이상
        ㄴ _ : 1글자
       
*/

-- 사원들 중 성이 전씨인 사원들의 사원명, 급여, 입사일 조회 
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

-- 이름 중에 하가 포함되어있는 사원들의 사원명, 주민번호, 전화번호 조회 
SELECT EMP_NAME, EMP_NO, PHONE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 이름이 세글자인 사원들 중 가운데글자가 하인 사원들의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
--WHERE EMP_NAME LIKE '_하_';
WHERE EMP_NAME LIKE '__하'; -- 하로 끝나는 사원 조회

-- 전화번호의 3번째 자리가 1인 사원들의 사번, 사원명, 전화번호, 이메일 조회
SELECT EMP_ID, EMP_NAME, PHONE, EMAIL
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

-- 이메일 중 _ 앞글자가 3글자인 사원들의 사번, 이름, 이메일 조회
-- ex) sim_bs@br.com, sun_di@br.com, ...
SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '____%'; -- 와일드 카드랑 컬럼값이 동일하기 때문에 발생되는 문제 (다 와일드카드_로 인식하고 있음)
--> 어떤게 와일드 카드고 어떤게 데이터값인지 구분지어야됨
--> 데이터값으로 취급하고자 하는 값 앞에 나만의 와일드 카드를 제시하고 해당 와일드 카드를 등록

SELECT EMP_ID, EMP_NAME, EMAIL
FROM EMPLOYEE
WHERE EMAIL LIKE '___!_%' ESCAPE '!';

--------------------- 실습 ---------------------
-- 1. 이름이 연으로 끝나는 사원들의 사원명, 입사일 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';
-- 2. 사원들 중 전화번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회 (NOT 적절히이용)
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
-- 3. 이름에 하가 포함되어있고 급여가 240만원 이상인 사원들의 사원명, 급여 조회 
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%'
  AND SALARY >= 2400000;
-- 4. DEPARTMENT에서 해외영업부인 부서들의 부서코드, 부서명 조회 
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%';

------------------------------------------------------------------

/*
    5. IS NULL | IS NOT NULL
       NULL값 비교에 사용되는 연산자 
*/

-- 보너스를 받지 않는 사원들의 사번, 사원명, 급여, 보너스 조회 
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
--WHERE BONUS = NULL; -- 정상적으로 조회 안됨
WHERE BONUS IS NULL; -- 14개

-- 보너스를 받는 사원들의 사번, 사원명, 급여, 보너스 조회 
SELECT EMP_ID, EMP_NAME, SALARY, BONUS
FROM EMPLOYEE
--WHERE NOT BONUS IS NULL; -- 9명
--WHERE BONUS NOT IS NULL; -- 오류
WHERE BONUS IS NOT NULL;

-- 사수가 없는 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

-- 부서배치를 아직 받지 않고 근데 보너스는 받는 사원들의 이름, 보너스, 부서코드 조회 
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL
  AND BONUS IS NOT NULL;
  
/*
    6. IN 
       비교대상컬럼값이 내가 제시한 목록중에 일치하는 값이 있는지 비교
       
       [표현법]
       비교대상컬럼 IN (값1, 값2, 값3, ..)
*/

-- 부서코드가 D6이거나 D8이거나 D5인 사원들의 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE = 'D6' OR DEPT_CODE = 'D8' OR DEPT_CODE = 'D5';
WHERE DEPT_CODE IN ('D6', 'D8', 'D5'); -- 12명 

-- 그 외의 사원들 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE NOT DEPT_CODE IN ('D6', 'D8', 'D5');
WHERE DEPT_CODE NOT IN ('D6', 'D8', 'D5'); -- 9명
-- OR DEPT_CODE IS NULL;

/*
    < 연산자 우선순위 >
    0. ()
    1. 산술연산자
    2. 연결연산자
    3. 비교연산자
    4. IS NULL | LIKE '특정패턴' | IN
    5. BETWEEN AND 
    6. NOT(논리연산자)
    7. AND(논리연산자)
    8. OR(논리연산자)
*/

-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회 (4개행)
-- 송종기, 박나라, 윤은해, 이오리 
SELECT *
FROM EMPLOYEE
WHERE (JOB_CODE = 'J7' OR JOB_CODE ='J2') AND SALARY >= 2000000;

-- ============================================================================

/*
    < ORDER BY 절 >
    1. 조회되는 데이터를 정렬시켜서 조회 
    2. SELECT문의 가장 마지막 줄에 작성
    3. 실행순서 또한 가장 마지막에 진행됨 
    
    [표현법]
    SELECT 조회할컬럼, 산술식, 함수식, .. AS "별칭"
      FROM 조회할테이블
     WHERE 조건식
     ORDER BY 정렬기준의컬럼명|별칭|컬럼순번  [ASC|DESC]  [NULLS FIRST|NULLS LAST]
     
     ㄴ ASC  : 오름차순 정렬 (생략시 기본값)
     ㄴ DESC : 내림차순 정렬
     
     ㄴ NULLS FIRST : 정렬하고자하는 컬럼값에 NULL이 있을 경우 맨 앞에 배치 (DESC일때의 기본값)
     ㄴ NULLS LAST  :                    "                 맨 뒤에 배치 (ASC일때의 기본값)
*/

SELECT *
FROM EMPLOYEE
--ORDER BY BONUS; -- 기본적으로 오름차순
--ORDER BY BONUS ASC; -- 오름차순일 때 기본적으로 NULLS LAST 임
--ORDER BY BONUS ASC NULLS FIRST;
--ORDER BY BONUS DESC; -- 내림차순일 때 기본적으로 NULLS FIRST 임
ORDER BY BONUS DESC, SALARY ASC; -- 정렬기준 여러개 제시 가능 (첫번째 기준의 컬럼값이 동일할 경우 두번째 컬럼기준으로 정렬)

-- 전체 사원의 사원명, 연봉 조회 (연봉별 내림차순 정렬 조회)
SELECT EMP_NAME, SALARY * 12 "연봉"
FROM EMPLOYEE
--ORDER BY SALARY * 12 DESC; -- 산술연산식 작성 가능
--ORDER BY 연봉 DESC; -- 별칭 작성 가능
ORDER BY 2 DESC; -- 컬럼순번(조회되는컬럼순서) 작성 가능

/*
    * 실행 순서 *
    3:SELECT절
    1:  FROM절
    2: WHERE절
    4: ORDER BY절
*/

----------------------------- 실습 -------------------------------
-- 1. 사수가 없고 부서배치도 받지 않은 사원들의 (사원명, 사수사번, 부서코드) 조회

-- 2. 연봉(보너스포함X)이 3000만원 이상이고 보너스를 받지 않는 사원들의 (사번, 사원명, 급여, 보너스) 조회

-- 3. 입사일이 '95/01/01'이상이고 부서배치를 받은 사원들의 (사번, 사원명, 입사일, 부서코드) 조회

-- 4. 급여가 200만원 이상 500만원 이하이면서 입사일이 '01/01/01'이상이고 보너스를 받지 않는 사원들의 (사번, 사원명, 급여, 입사일, 보너스) 조회

-- 5. 보너스포함연봉이 NULL이 아니고 이름에 '하'가 포함되어있는 사원들의 (사번, 사원명, 급여, 보너스포함연봉) 조회

------------------------------------------------------------------
