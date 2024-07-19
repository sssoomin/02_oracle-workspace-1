/*
    < 서브쿼리 (SUBQUERY) >
    1. 하나의 쿼리문 안에 포함되어있는 또다른 쿼리문
    2. 메인 쿼리를 위해 보조 역할을 수행 
    3. 기본 실행순서
       서브쿼리 -> 메인쿼리 
    4. 종류 
       1) SELECT절 : 스칼라 서브쿼리
       2)   FROM절 : 인라인뷰 (INLINE VIEW)
       3)  WHERE절 : 단일행|다중행|다중열|다중행다중열 서브쿼리
*/

-- 간단 서브쿼리 예시1. 
-- 노옹철 사원과 같은 부서에 속한 사원들 조회

-- 1) 노옹철 사원의 부서코드 조회
SELECT DEPT_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME = '노옹철'; -- D9
 
 -- 2) 부서코드가 D9인 사원들 조회 
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D9';
 
--> 위의 2단계를 하나의 쿼리 
SELECT EMP_NAME
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '노옹철');
 
-- 간단 서브쿼리 예시2. 
-- 전 사원의 평균급여보다 더 많은 급여를 받는 사원들 조회

--> 1) 전 사원의 평균 급여 조회
SELECT AVG(SALARY)
  FROM EMPLOYEE; -- 대략 3047663원 조회

--> 2) 급여가 3047663원 이상인 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY >= 3047663;
 
--> 위의 2단계를 하나의 쿼리로 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY >= (SELECT AVG(SALARY)
                    FROM EMPLOYEE);


/*
    < 단일행 서브쿼리 (SINGLE ROW SUBQUERY) >
    1. 서브쿼리의 결과값이 오로지 1개일 때 (한행 한열)
    2. 서브쿼리를 가지고 일반 비교연산자 사용 가능 
       = != ^= <> < >=, ..
*/

-- 1) 전사원의 평균급여보다 급여를 더 적게 받는 사원 (사원명, 직급코드, 급여)
SELECT EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY < (SELECT AVG(SALARY)
                   FROM EMPLOYEE)
 ORDER BY SALARY ASC;

-- 2) 최저급여를 받는 사원 (사번, 사원명, 급여, 입사일)
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE
  FROM EMPLOYEE
 WHERE SALARY = (SELECT MIN(sALARY)
                   FROM EMPLOYEE);

-- 3) 노옹철 사원의 급여보다 더 많이 받는 사원 (사번, 이름, 부서코드, 급여, 부서명)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '노옹철'); -- 20명 

-- > ORACLE 방식
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, NVL(DEPT_TITLE, '부서없음')
  FROM EMPLOYEE, DEPARTMENT
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '노옹철')
   AND DEPT_CODE = DEPT_ID(+); 

-- > ANSI
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, NVL(DEPT_TITLE, '부서없음')
  FROM EMPLOYEE
  LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
 WHERE SALARY > (SELECT SALARY
                   FROM EMPLOYEE
                  WHERE EMP_NAME = '노옹철');


-- 4) 사수가 선동일인 사원 (사번, 이름, 사수사번)
--    SELF JOIN 방식
SELECT E.EMP_ID, E.EMP_NAME, E.MANAGER_ID
  FROM EMPLOYEE E, EMPLOYEE M
 WHERE E.MANAGER_ID = M.EMP_ID
   AND M.EMP_NAME = '선동일';
   
--    SUBQUERY 방식
SELECT EMP_ID, EMP_NAME, MANAGER_ID 
  FROM EMPLOYEE
 WHERE MANAGER_ID = (SELECT EMP_ID
                       FROM EMPLOYEE
                      WHERE EMP_NAME = '선동일');
 
-- 5) 전지연 사원과 같은 부서원 (사번, 사원명, 전화번호, 입사일, 부서명)
--    단, 전지연은 제외 
-- > ORACLE 
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
  FROM EMPLOYEE, DEPARTMENT
 WHERE DEPT_CODE = DEPT_ID
   --AND DEPT_TITLE = 전지연사원의부서명
   AND DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '전지연')
   AND EMP_NAME != '전지연';




-- 6) 부서별 급여합이 가장 큰 부서 (부서코드)




 