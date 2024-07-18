/*
    < JOIN >
    1. 두 개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문
    2. 조회 결과는 하나의 결과물로 조회됨
    3. 매칭되는 컬럼을 가지고 조건을 작성하여 조인해야됨
    4. 오라클 전용 구문 방식있고 ANSI(미국국립표준협회)에서 표준화해둔 구문있음
    5. 종류 
                    오라클전용               |               ANSI
    ================================================================================
                    등가 조인                |      내부조인 (INNER JOIN)
                  (EQUAL JOIN)               |      자연조인 (NATURAL JOIN)
    --------------------------------------------------------------------------------
                    포괄 조인                |   왼쪽 외부조인 (LEFT OUTER JOIN)
                  (LEFT  OUTER)              |  오른쪽 외부조인 (RIGHT OUTER JOIN)
                  (RIGHT OUTER)              |   전체 외부조인 (FULL OUTER JOIN)
    --------------------------------------------------------------------------------              
            자체 조인 (SELF JOIN)            |              JOIN ON
          비등가 조인 (NON EQUAL JOIN)       |
    ---------------------------------------------------------------------------------
          카테시안 곱 (CARTESIAN PRODUCT)    |       교차 조인 (CROSS JOIN)
          
          
*/

-- 전 사원들의 사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE -- DEPT_CODE
  FROM EMPLOYEE;

SELECT DEPT_ID, DEPT_TITLE         -- DEPT_ID
  FROM DEPARTMENT;

-- 전 사원들의 사번, 사원명, 직급코드, 직급명을 조회 
SELECT EMP_ID, EMP_NAME, JOB_CODE   -- JOB_CODE
  FROM EMPLOYEE;

SELECT JOB_CODE, JOB_NAME           -- JOB_CODE
  FROM JOB;
  
/*
    1. 등가조인(EQUAL JOIN) / 내부조인(INNER JOIN)
    
       테이블간에 컬럼을 가지고 동등비교 수행해서 조회 
       조건 : A테이블의 컬럼 = B테이블의 컬럼 
       
       매칭시키는 컬럼의 값이 "일치하는 행들만" 조인되서 조회 (일치하는 값이 없는 행은 조회에서 제외)
*/
-- > 오라클 전용 구문 
--   FROM절에 조회하고자 하는 테이블들을 나열 (,로)
--   WHERE절에 매칭시킬 컬럼에 대한 조건 작성

-- 1) 연결할 두 컬럼명이 다를 경우 (EMPLOYEE:DEPT_CODE / DEPARTMENT:DEPT_ID)
--    사번, 사원명, 부서코드, 부서명을 조회
SELECT EMP_ID, EMP_NAME, DEPT_ID, DEPT_TITLE 
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID;
--> DEPT_CODE가 NULL인 사원 조회 X, DEPT_ID가 D3,D4,D7인 부서 조회X

-- 2) 연결할 두 컬럼명이 같을 경우 (EMPLOYEE:JOB_CODE / JOB:JOB_CODE)
--    사번, 사원명, 직급코드, 직급명을 조회 
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE, JOB
 WHERE JOB_CODE = JOB_CODE; -- 오류
-- ambiguously : 애매하다, 모호하다

-- 해결방법1. 테이블명을 이용하는 방법
SELECT EMP_ID, EMP_NAME, JOB.JOB_CODE, JOB_NAME
  FROM EMPLOYEE, JOB
 WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 해결방법2. 테이블에 별칭을 부여해서 이용하는 방법
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME
  FROM EMPLOYEE "E", JOB J
 WHERE E.JOB_CODE = J.JOB_CODE;
 
-- > ANSI구문 
--   FROM절에 기준이되는 테이블 하나 기술
--   JOIN절에 같이 조회하고자하는 테이블 기술 + 매칭시킬 컬럼에 대한 조건
--   JOIN ON, JOIN USING

-- 1) 연결할 두 컬럼명이 다를 경우 (EMPLOYEE:DEPT_CODE / DEPARTMENT:DEPT_ID)
--    >> JOIN ON 방식만 이용 가능 
--    사번, 사원명, 부서코드, 부서명
SELECT EMP_ID, EMP_NAME, DEPT_ID, DEPT_TITLE
  FROM EMPLOYEE
/*INNER*/ JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 2) 연결할 두 컬럼명이 같을 경우 (EMPLOYEE:JOB_CODE / JOB:JOB_CODE)
--    >> JOIN ON, JOIN USING 둘 다 가능
--    사번, 사원명, 직급코드, 직급명
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB ON (JOB_CODE = JOB_CODE);  -- 오류
-- ambiguously

-- 해결방법1. 테이블명 이용
SELECT EMP_ID, EMP_NAME, JOB.JOB_CODE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB ON (EMPLOYEE.JOB_CODE = JOB.JOB_CODE);

-- 해결방법2. 테이블의 별칭 이용
SELECT EMP_ID, EMP_NAME, J.JOB_CODE, JOB_NAME
  FROM EMPLOYEE E
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);

-- 해결방법3. JOIN USING 구문 이용 (컬럼명이 일치할때만 사용 가능)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE);
  
-- [참고] 자연조인(NATURAL JOIN) : 조인할 두 테이블간에 동일한 이름의 컬럼이 단 한 개만 존재할 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
NATURAL 
  JOIN JOB;
  

-- 직급이 대리인 사원의 사번, 이름, 급여 조회 
-- > 오라클 방식
SELECT EMP_ID, EMP_NAME, SALARY
  FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND JOB_NAME = '대리';
-- > ANSI 방식
SELECT EMP_ID, EMP_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리';
 
----------------------------- 실습 -------------------------------
-- 1. 부서가 인사관리부인 사원들의 사번, 이름, 보너스 조회 
-- > 오라클
SELECT EMP_ID, EMP_NAME, BONUS --, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID
   AND DEPT_TITLE = '인사관리부';
-- > ANSI 
SELECT EMP_ID, EMP_NAME, BONUS
  FROM EMPLOYEE
  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID 
 WHERE DEPT_TITLE = '인사관리부';

-- 2. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회 
-- > 오라클
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE BONUS IS NOT NULL
   AND DEPT_CODE = DEPT_ID;
-- > ANSI
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
 WHERE BONUS IS NOT NULL;

-- 3. 부서가 총무부가 아닌 사원들의 사원명, 급여 조회 
-- > 오라클
SELECT EMP_NAME, SALARY
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID
   AND DEPT_TITLE != '총무부';
-- > ANSI
SELECT EMP_NAME, SALARY
  FROM EMPLOYEE
  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
 WHERE DEPT_TITLE != '총무부';

-- 4. DEPARTMENT과 LOCATION을 참고해서 전체 부서들의 부서코드, 부서명, 지역코드, 지역명 조회 
SELECT * FROM DEPARTMENT; -- LOCATION_ID
SELECT * FROM LOCATION;   -- LOCAL_CODE    => LOCAL_NAME

-- > 오라클
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
  FROM DEPARTMENT, LOCATION
 WHERE LOCATION_ID = LOCAL_CODE;
-- > ANSI
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
  FROM DEPARTMENT
  JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;

-- > ASIA1 지역에 있는 부서 
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME
  FROM DEPARTMENT
  JOIN LOCATION ON LOCATION_ID = LOCAL_CODE 
 WHERE LOCAL_NAME = 'ASIA1';


 
 
 





