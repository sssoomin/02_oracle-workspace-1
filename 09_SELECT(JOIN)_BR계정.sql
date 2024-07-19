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


-- 복습
-- 전 사원의 이름, 부서명, 직급명 조회
-- > 오라클 구문
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
  FROM EMPLOYEE E, DEPARTMENT, JOB J
 WHERE DEPT_CODE = DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE;
   
-- > ANSI
SELECT EMP_NAME, DEPT_TITLE, JOB_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
  JOIN JOB USING(JOB_CODE);

/*
    2. 포괄 조인 / 외부 조인 (OUTER JOIN)
       두 테이블간에 JOIN시 일치하지 않는 행도 포함시켜서 조회 가능 
*/

-- 사원명, 부서명, 급여, 연봉
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
  FROM EMPLOYEE JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
-- 부서 배치가 아직 안된 사원 2명이 조회 X
-- 부서에 배정된 사원이 없는 부서 3개 조회 X

-- 1) LEFT [OUTER] JOIN : 두 테이블 중 왼편에 기술된 테이블 기준으로 JOIN
--> ANSI 방식
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
  FROM EMPLOYEE 
  LEFT /*OUTER*/ JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
--> 부서 배치를 받지 않은 2명의 사원(하동운, 이오리) 정보도 조회됨

--> ORACLE 방식
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
  FROM DEPARTMENT, EMPLOYEE
 WHERE DEPT_CODE = DEPT_ID(+); -- 기준으로 삼고자하는 테이블의 반대편 컬럼 뒤에 (+) 붙여주면됨
 
-- 2) RIGHT [OUTER] JOIN : 두 테이블 중 오른편에 기술된 테이블을 기준으로 JOIN
--> ANSI 방식
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
  FROM EMPLOYEE 
  RIGHT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;

--> ORACLE 방식
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
  FROM DEPARTMENT, EMPLOYEE
 WHERE DEPT_CODE(+) = DEPT_ID;
 
-- 3) FULL [OUTER] JOIN : 두 테이블이 가진 모든 행을 조회 (단, 오라클 방식 불가능)
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
  FROM EMPLOYEE 
  FULL JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID;
  
/*
    3. 비 등가 조인 (NON EQUAL JOIN)
    매칭시킬 컬럼에 대한 조건 작성시 '=' 사용하지 않는 조인문
*/
SELECT EMP_NAME, SALARY -- SALARY
  FROM EMPLOYEE;

SELECT *                -- MIN_SAL, MAX_SAL
  FROM SAL_GRADE;
  
-- 사원명, 급여, 급여등급
--> ORACLE 방식
SELECT EMP_NAME, SALARY, SAL_LEVEL
  FROM EMPLOYEE, SAL_GRADE
 --WHERE SALARY >= MIN_SAL AND SALARY <= MAX_SAL;
 WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

--> ANSI 방식
SELECT EMP_NAME, SALARY, SAL_LEVEL
  FROM EMPLOYEE
  JOIN SAL_GRADE ON SALARY BETWEEN MIN_SAL AND MAX_SAL;

--> 급여등급이 S5인 사원의 사원명, 급여 조회 
SELECT EMP_NAME, SALARY
  FROM EMPLOYEE
  JOIN SAL_GRADE ON SALARY BETWEEN MIN_SAL AND MAX_SAL
 WHERE SAL_LEVEL = 'S5';
 
/*
    4. 자체 조인 (SELF JOIN)
       같은 테이블을 다시 한번 조인하는 경우
*/
SELECT * FROM EMPLOYEE;

-- 전체 사원들의 사원사번, 사원명, 사원부서명            => EMPLOYEE E, DEPARTMENT ED
--             , 사수사번, 사수명, 사수부서명            => EMPLOYEE M, DEPARTMENT MD
--> ORACLE 방식
SELECT E.EMP_ID "사원사번", E.EMP_NAME "사원명", ED.DEPT_TITLE "사원부서명"
     , M.EMP_ID "사수사번", M.EMP_NAME "사수명", MD.DEPT_TITLE "사수부서명"
  FROM EMPLOYEE E, EMPLOYEE M, DEPARTMENT ED, DEPARTMENT MD
 WHERE E.MANAGER_ID = M.EMP_ID
   AND E.DEPT_CODE = ED.DEPT_ID
   AND M.DEPT_CODE = MD.DEPT_ID;

--> ANSI 방식
SELECT E.EMP_ID "사원사번", E.EMP_NAME "사원명", ED.DEPT_TITLE "사원부서명"
     , M.EMP_ID "사수사번", M.EMP_NAME "사수명", MD.DEPT_TITLE "사수부서명"
  FROM EMPLOYEE E
  JOIN EMPLOYEE M ON E.MANAGER_ID = M.EMP_ID
  JOIN DEPARTMENT ED ON E.DEPT_CODE = ED.DEPT_ID
  JOIN DEPARTMENT MD ON M.DEPT_CODE = MD.DEPT_ID;
  
/*
    5. 카테시안 곱 (CARTESIAN PRODUCT) / 교차조인 (CROSS JOIN)
       모든 테이블의 각 행들이 서로서로 매핑된 데이터 조회 (곱집합)
       => 방대한 데이터 출력
       => 과부화의 위험
*/
--> ORACLE 방식
SELECT EMP_NAME, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT; -- 23 * 9 => 207행

--> ANSI 방식
SELECT EMP_NAME, DEPT_TITLE
  FROM EMPLOYEE
 CROSS 
  JOIN DEPARTMENT;
  
-----------------------------------------------------------------------------

-- * 다중 조인 연습
-- 사번, 사원명, 부서명, 지역명, 직급명
SELECT * FROM EMPLOYEE;     -- DEPT_CODE
SELECT * FROM DEPARTMENT;   -- DEPT_ID      LOCATION_ID
SELECT * FROM LOCATION;     --              LOCAL_CODE

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
  FROM EMPLOYEE, DEPARTMENT, LOCATION
 WHERE DEPT_CODE = DEPT_ID 
   AND LOCATION_ID = LOCAL_CODE;

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB USING (JOB_CODE)
  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
  JOIN LOCATION ON LOCATION_ID = LOCAL_CODE;
--> ANSI 구문은 조인 순서 중요!


-- 사번, 사원명, 부서명, 지역명, 국가명, 급여등급, 직급명
--> ORACLE 방식
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , LOCAL_NAME
     , NATIONAL_NAME
     , SAL_LEVEL
     , JOB_NAME
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
     , NATIONAL N
     , SAL_GRADE S
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND L.NATIONAL_CODE = N.NATIONAL_CODE
   AND E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL
   AND E.JOB_CODE = J.JOB_CODE
;

--> ANSI 방식
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , LOCAL_NAME
     , NATIONAL_NAME
     , SAL_LEVEL
     , JOB_NAME
  FROM EMPLOYEE E
  LEFT JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
  LEFT JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE)
  LEFT JOIN NATIONAL N ON (L.NATIONAL_CODE = N.NATIONAL_CODE)
  JOIN SAL_GRADE S ON (E.SALARY BETWEEN S.MIN_SAL AND S.MAX_SAL)
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE);












 
 





