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

-----------------------------------------------------------------------------

/*
    < 인라인 뷰 (INLINE-VIEW) >
    1. FROM절에 작성된 서브쿼리
    2. 서브쿼리 수행 결과를 마치 하나의 테이블(임시테이블) 처럼 사용 가능
    3. 주로 TOP-N 분석시 많이 사용됨
*/

-- 사번, 이름, 보너스포함연봉(별칭부여), 부서코드 조회 
SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "연봉", DEPT_CODE
  FROM EMPLOYEE;

-- 단, 보너스 포함 연봉이 3000만원 이상인 사원들만 조회 
SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "연봉", DEPT_CODE
  FROM EMPLOYEE
 WHERE (SALARY + SALARY * NVL(BONUS, 0)) * 12 >= 30000000;

-- 인라인뷰 적용 => 별칭을 가져다가 메인쿼리의 조건으로 활용 가능
SELECT EMP_NAME, 연봉--, MANAGER_ID
  FROM (SELECT EMP_ID, EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0)) * 12 "연봉", DEPT_CODE
          FROM EMPLOYEE)
 WHERE 연봉 >= 30000000;
 
--> TOP-N 분석
-- 1) 전 사원 중 급여가 가장 높은 상위 5명(선동일, 송종기, 송은희, 대북혼, 박나라)만 조회 
-- * ROWNUM : 오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번을 부여해주는 컬럼
SELECT ROWNUM, EMP_NAME, SALARY
  FROM EMPLOYEE
 ORDER BY SALARY DESC;
-- 실행 순서 : FROM절 => SELECT절 (순번부여) => ORDER BY절 

SELECT ROWNUM, EMP_NAME, SALARY
  FROM EMPLOYEE
 WHERE ROWNUM <= 5
 ORDER BY SALARY DESC;
--> 정상적인 결과가 조회되지 않음 (정렬이 되기도 전에 5명이 추려져버림)

--> ORDER BY절이 수행된 후에 순번이 부여되야됨 => ROWNUM이 5이하인 추려내야됨
SELECT ROWNUM, E.*
  FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
          FROM EMPLOYEE
         ORDER BY SALARY DESC) E
 WHERE ROWNUM <= 5;

-- 2) 가장 최근에 입사한 사원 3명 조회 (사원명, 급여, 입사일)
SELECT EMP_NAME, SALARY, HIRE_DATE
  FROM (SELECT *
          FROM EMPLOYEE
         ORDER BY HIRE_DATE DESC)
 WHERE ROWNUM <= 3;
 
-- 3) 각 부서별 평균급여가 높은 3개의 부서 조회 (부서코드, 평균급여)
SELECT DEPT_CODE, FLOOR(평균급여)
  FROM (SELECT DEPT_CODE, AVG(SALARY) 평균급여
          FROM EMPLOYEE
         GROUP BY DEPT_CODE
         ORDER BY 2 DESC)
 WHERE ROWNUM <= 3;
 
--> ROWNUM 특성상 1부터 시작되는 범위만 조회 가능함 
SELECT DEPT_CODE, FLOOR(평균급여)
  FROM (SELECT DEPT_CODE, AVG(SALARY) 평균급여
          FROM EMPLOYEE
         GROUP BY DEPT_CODE
         ORDER BY 2 DESC)
 WHERE ROWNUM BETWEEN 2 AND 4; --> 정상적으로 조회되지 않음
 
/*
    < WINDOW FUNCTION >
    1) ROWNUM처럼 순번을 부여해주는 함수 : ROW_NUMBER() OVER(정렬기준)
    2) 순위를 매겨주는 함수
        ㄴ RANK() OVER(정렬기준)         : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너띄고 순위계산 (ex) 공동1위 2명, 그다음순위 3위)
        ㄴ DENSE_RANK() OVER(정렬기준)   : 동일한 순위 이후의 등수를 무조건 1씩 증가 순위 계산 (ex) 공동1위 2명, 그다음순위 2위)
    
    [유의사항]
    SELECT절에만 작성 가능 (즉, WHERE절에 사용 불가)
*/
-- 급여가 가장 높은 상위 5명 조회
SELECT EMP_NAME, SALARY, ROW_NUMBER() OVER(ORDER BY SALARY DESC) "순번"
  FROM EMPLOYEE
 WHERE ROW_NUMBER() OVER(ORDER BY SALARY DESC) <= 5; -- 오류

SELECT *
  FROM (SELECT EMP_NAME, SALARY, ROW_NUMBER() OVER(ORDER BY SALARY DESC) "순번"
          FROM EMPLOYEE)
 WHERE 순번 BETWEEN 1 AND 5;

-- 2위부터 7위 조회 (1부터의 범위가 아니여도 정상조회)
SELECT *
  FROM (SELECT EMP_NAME, SALARY, ROW_NUMBER() OVER(ORDER BY SALARY DESC) "순번"
          FROM EMPLOYEE)
 WHERE 순번 BETWEEN 2 AND 7;

-- 급여가 가장 높은 상위 5명 조회
SELECT *
  FROM (SELECT EMP_NAME, SALARY, RANK() OVER(ORDER BY SALARY DESC) "순위"
          FROM EMPLOYEE)
 WHERE 순위 <= 5;

SELECT *
  FROM (SELECT EMP_NAME, SALARY, DENSE_RANK() OVER(ORDER BY SALARY DESC) "순위"
          FROM EMPLOYEE)
 WHERE 순위 <= 5;
 
---------------------------------------------------------------------------------

/*
    < 상관 서브쿼리 >
    일반적인 서브쿼리 방식은 서브쿼리의 결과값을 가지고 메인쿼리 활용 (서브쿼리 => 메인쿼리)
    단, 상관 서브쿼리는 반대로 메인쿼리의 값을 가져다가 서브쿼리에서 활용 
    즉, 메인쿼리의 값이 변경되면 서브쿼리의 결과값도 변경됨
*/
-- 1) 본인 직급의 평균급여보다 더 많이 받는 사원 이름, 직급코드, 급여 조회 
SELECT EMP_NAME, JOB_CODE, SALARY
  FROM EMPLOYEE;

SELECT EMP_NAME, E.JOB_CODE, SALARY
  FROM EMPLOYEE E
 WHERE SALARY > 해당사원직급(E.JOB_CODE)의평균급여;

SELECT EMP_NAME, E.JOB_CODE, SALARY
  FROM EMPLOYEE E
 WHERE SALARY > (SELECT AVG(SALARY)
                   FROM EMPLOYEE
                  WHERE JOB_CODE = E.JOB_CODE); -- E.JOB_CODE 자리는 메인쿼리의 매행 스캔시마다 매번 달라짐 => 서브쿼리 결과값도 매번 다름

-- 2) 보너스가 본인 부서의 평균보너스보다 더 많이 받는 사원 (사원명, 부서코드, 급여, 보너스 조회)
SELECT EMP_NAME, DEPT_CODE, SALARY, BONUS
  FROM EMPLOYEE E
 WHERE BONUS > (SELECT AVG(BONUS)
                  FROM EMPLOYEE
                 WHERE DEPT_CODE = E.DEPT_CODE);

-- * 상관서브쿼리면서 SELECT절에 작성된 서브쿼리 : 스칼라 서브쿼리 
-- 3) 전 사원의 사번, 이름, 직급코드, 직급명 조회 
-- > JOIN 활용
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
  FROM EMPLOYEE
  JOIN JOB USING(JOB_CODE);

-- > 스칼라 서브쿼리 활용 
SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE, JOB테이블로부터 JOB_CODE값이 E.JOB_CODE와 일치하는 JOB_NAME
  FROM EMPLOYEE E;

SELECT E.EMP_ID, E.EMP_NAME, E.JOB_CODE
     , (SELECT JOB_NAME
          FROM JOB
         WHERE JOB_CODE = E.JOB_CODE) "JOB_NAME"
  FROM EMPLOYEE E;

/*
    * JOIN VS 서브쿼리 
      존재하는 데이터 수량에 따라서 효율/비효율적 판단됨 
      
    * 스칼라 서브쿼리 특징 
      입력값(메인쿼리값)과 출력값(서브쿼리값)을 내부 캐시라는 공간에 저장해둠
      서브쿼리 수행 전에 캐시로부터 먼저 찾아보고 거기에 없으면 서브쿼리를 수행 있으면 출력값을 바로 반환 
      => 수행 속도가 빨라짐
*/

-- 4) 전 사원의 사번, 사원명, 부서명
SELECT EMP_ID, EMP_NAME
     , (SELECT DEPT_TITLE
          FROM DEPARTMENT
         WHERE DEPT_ID = E.DEPT_CODE) "DEPT_TITLE"
  FROM EMPLOYEE E;
  
-- 5) 전 사원의 사번, 사원명, 사수명(단, 사수가 없을 경우 "없음"으로)
SELECT EMP_ID, EMP_NAME
     , NVL((SELECT EMP_NAME
              FROM EMPLOYEE
             WHERE EMP_ID = E.MANAGER_ID), '없음') "MANAGER_NAME"
  FROM EMPLOYEE E;

-- 6) 전 사원의 사번, 사원명, 급여, 본인부서부서원수, 본인부서평균급여 
SELECT EMP_ID, EMP_NAME, SALARY
     , (SELECT COUNT(*), AVG(SALARY)
          FROM EMPLOYEE
         WHERE DEPT_CODE = E.DEPT_CODE) --> 오류. 스칼라 서브쿼리는 무조건 1개값만 조회되도록
  FROM EMPLOYEE E;


SELECT EMP_ID, EMP_NAME, SALARY
     , (SELECT COUNT(*)
          FROM EMPLOYEE
         WHERE DEPT_CODE = E.DEPT_CODE) "부서원수"
     , ROUND((SELECT AVG(SALARY)
               FROM EMPLOYEE
              WHERE DEPT_CODE = E.DEPT_CODE)) "부서평균급여"
  FROM EMPLOYEE E;


 