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

-- > ANSI
SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_TITLE
  FROM EMPLOYEE
  JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '전지연')
   AND EMP_NAME != '전지연';


-- 6) 부서별 급여합이 가장 큰 부서 (부서코드)
-- 6_1) 부서별 급여합 => 급여합 중에서 가장 큰 값
SELECT MAX(SUM(SALARY))
  FROM EMPLOYEE
 GROUP BY DEPT_CODE; -- 17660000원

-- 6_2) 부서별 급여합이 17660000과 일치하는 부서
SELECT DEPT_CODE
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING SUM(SALARY) = 17660000;

--> 서브쿼리
SELECT DEPT_CODE
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                        FROM EMPLOYEE
                       GROUP BY DEPT_CODE);

/*
    < 다중행 서브쿼리 (MULTI ROW SUBQUERY) >
    1. 서브쿼리의 결과값이 여러 행일 때 (여러행 한열)
    2. 서브쿼리를 가지고 일반 비교연산자와 함께 사용 불가
       IN, ANY, ALL 사용 
       
       ㄴ IN 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면 조회
       
       ㄴ > ANY 서브쿼리 :       "             "한개라도" 클 경우 조회
       ㄴ < ANY 서브쿼리 :       "             "한개라도" 작을 경우 조회 
       
            비교대상 > ANY (값1, 값2, 값3, ..)
            비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상 > 값3
            
       ㄴ > ALL 서브쿼리 :       "              "모든" 값보다 클 경우 조회
       ㄴ < ALL 서브쿼리 :       "              "모든" 값보다 작을 경우 조회
       
            비교대상 > ALL (값1, 값2, 값3, ...)
            비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3 
       
*/
-- 1) 유재식 또는 윤은해 사원과 같은 직급인 사원 (사번, 사원명, 직급코드, 급여)
-- 1_1) 유재식 또는 윤은해 사원의 직급코드 조회 
SELECT JOB_CODE
  FROM EMPLOYEE
 WHERE EMP_NAME IN ('유재식', '윤은해'); -- J3, J7
 
-- 1_2) 직급코드가 J3 또는 J7인 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE IN ('J3', 'J7');

--> 하나의 쿼리
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE IN (SELECT JOB_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME IN ('유재식', '윤은해'));

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE = ANY (SELECT JOB_CODE
                         FROM EMPLOYEE
                        WHERE EMP_NAME IN ('유재식', '윤은해'));

-- 2) 사수가 D9부서인 사원 (사번, 이름, 사수사번)
SELECT EMP_ID, EMP_NAME, MANAGER_ID
  FROM EMPLOYEE
 WHERE MANAGER_ID IN (SELECT EMP_ID
                       FROM EMPLOYEE
                      WHERE DEPT_CODE = 'D9');

-- 사원 < 대리 < 과장 < 차장 < 부장 
-- 3) 대리 직급임에도 불구하고 과장 직급 급여들 중 최소급여보다 더 많이 받는 직원 조회 (사번, 이름, 직급, 급여)
-- 3_1) 과장 직급 사원들의 급여 조회
SELECT SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '과장'; -- 2200000, 2500000, 3760000
 
-- 3_2) 직급이 대리이면서 급여값이 위의 목록들 값 중에 하나라도 큰 사원 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리'
   AND SALARY > ANY (2200000, 2500000, 3760000);

--> 하나의 쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '대리'
   AND SALARY > ANY (SELECT SALARY
                      FROM EMPLOYEE
                      JOIN JOB USING(JOB_CODE)
                     WHERE JOB_NAME = '과장');


-- 3) 차장직급임에도 불구하고 모든 부장들의 급여보다 더 많이 받는 사원 (사번, 사원명, 직급, 급여)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE)
 WHERE JOB_NAME = '차장'
   AND SALARY > ALL(SELECT SALARY
                      FROM EMPLOYEE
                      JOIN JOB USING (JOB_CODE)
                     WHERE JOB_NAME = '부장');


/*
    < 다중열 서브쿼리 >
    1. 서브쿼리의 결과값이 한 행이지만 나열된 컬럼수가 여러개일 경우 (한행 여러열)
    2. 여러 컬럼과 동시에 비교할 수 있음 
       일반 비교연산자 사용 가능
*/

-- 1) 하이유 사원과 같은 부서, 같은 직급인 사원 (사원명, 부서코드, 직급코드, 입사일)
--> 단일행 서브쿼리 방식
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE DEPT_CODE = (SELECT DEPT_CODE
                      FROM EMPLOYEE
                     WHERE EMP_NAME = '하이유') -- D5
   AND JOB_CODE = (SELECT JOB_CODE
                     FROM EMPLOYEE
                    WHERE EMP_NAME = '하이유'); -- J5 

--> 다중열 서브쿼리
SELECT EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
                                  FROM EMPLOYEE
                                 WHERE EMP_NAME = '하이유'); -- D5, J5

-- 2) 박나라 사원과 같은 직급, 같은 사수를 가지고 있는 사원 (사원명, 직급코드, 사수사번)
SELECT EMP_NAME, JOB_CODE, MANAGER_ID
  FROM EMPLOYEE
 WHERE (JOB_CODE, MANAGER_ID) = (SELECT JOB_CODE, MANAGER_ID
                                   FROM EMPLOYEE
                                  WHERE EMP_NAME = '박나라');

-- 3) 송종기 사원과 같은 부서, 같은 입사년도인 사원 (사원명, 부서코드, 입사일)
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
  FROM EMPLOYEE
 WHERE ( DEPT_CODE, EXTRACT(YEAR FROM HIRE_DATE) ) = (SELECT DEPT_CODE, EXTRACT(YEAR FROM HIRE_DATE)
                                                        FROM EMPLOYEE
                                                       WHERE EMP_NAME = '송종기');


/*
    < 다중행 다중열 서브쿼리 >
    1. 서브쿼리의 결과값이 여러행 여러열일 경우 
    2. 여러 컬럼과 동시에 비교 가능, 단 일반 비교연산자 사용 불가 
*/
-- 1) 각 직급별 최소급여를 받는 사원 (사번, 사원명, 직급코드, 급여)
-- 1_1) 각 직급별 최소급여 조회
SELECT JOB_CODE, MIN(SALARY)
  FROM EMPLOYEE
 GROUP BY JOB_CODE;

-- 1_2) 사원 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE JOB_CODE = 'J2' AND SALARY = 1800000
    OR JOB_CODE = 'J7' AND SALARY = 1380000
    OR JOB_CODE = 'J3' AND SALARY = 2800000
    ...;
    
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY) = ('J2', 1800000)
    OR (JOB_CODE, SALARY) = ('J7', 1380000)
    OR (JOB_CODE, SALARY) = ('J3', 2800000)
    ...;
    
--> 서브쿼리 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE
 WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY)
                                FROM EMPLOYEE
                               GROUP BY JOB_CODE);

-- 2) 각 부서별 최고급여를 받는 사원 (사번, 사원명, 부서코드, 급여)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE (NVL(DEPT_CODE, '없음'), SALARY) IN (SELECT NVL(DEPT_CODE, '없음'), MAX(SALARY)
                                             FROM EMPLOYEE
                                            GROUP BY DEPT_CODE);
/*
    DEPT_CODE = '없음' AND SALARY = 2890000
 OR DEPT_CODE = 'D1' AND SALARY = 3660000
     ....
*/







 