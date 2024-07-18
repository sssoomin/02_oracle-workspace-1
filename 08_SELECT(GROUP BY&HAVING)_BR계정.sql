/*
    < GROUP BY 절 >
    1. 같은 값을 가진 데이터들을 하나의 그룹으로 묶어서 처리
    2. 주로 그룹 함수와 함께 사용함
    3. 표현법
       SELECT 컬럼, 산술식, 함수식, .. AS "별칭"
         FROM 테이블명
        WHERE 조건식
        GROUP BY 그룹기준의컬럼, 컬럼, ..
    4. 유의사항
       GROUP BY 절에 명시한 컬럼만 SELECT절에 작성 가능
*/

-- 전체 사원의 급여합
SELECT SUM(SALARY)
  FROM EMPLOYEE;
  
-- 각 부서별 총 급여합, 사원수
SELECT DEPT_CODE, SUM(SALARY), COUNT(*)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE; -- 7그룹
 
-- 실행순서
SELECT DEPT_CODE, SUM(SALARY)   -- 3
  FROM EMPLOYEE                 -- 1
 GROUP BY DEPT_CODE             -- 2
 ORDER BY DEPT_CODE;            -- 4
 
-- 각 직급별 사원수, 보너스를받는사원수, 급여합, 평균급여
SELECT JOB_CODE
     , COUNT(*) "사원수"
     , COUNT(BONUS) "보너스를받는사원수"
     , SUM(SALARY) "급여합"
     , ROUND( AVG(SALARY) ) "평균급여"
  FROM EMPLOYEE
 GROUP BY JOB_CODE;
 
-- 각 부서별 사원수, 최저급여, 최대급여, 가장최근입사일, 가장오래된입사일
SELECT DEPT_CODE        "부서"
     , COUNT(*)         "사원수"
     , MIN(SALARY)      "최저급여"
     , MAX(SALARY)      "최대급여"
     , MAX(HIRE_DATE)   "가장최근입사일"
     , MIN(HIRE_DATE)   "가장오래된입사일"
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 

-- * GROUP BY절에 함수식 기술가능
-- 성별별 사원수
SELECT DECODE( SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여' ) "성별", COUNT(*)
  FROM EMPLOYEE
 GROUP BY SUBSTR(EMP_NO, 8, 1);

-- 입사년도별 사원수
SELECT EXTRACT(YEAR FROM HIRE_DATE) "입사년도"
     , COUNT(*) "사원수"
  FROM EMPLOYEE
 GROUP BY EXTRACT(YEAR FROM HIRE_DATE)
 ORDER BY 1;

-- * GROUP BY절에 컬럼 여러개 작성 가능
--   부서와 직급이 일치하는 사원들을 그룹으로 묶기
SELECT DEPT_CODE, JOB_CODE, COUNT(*)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE, JOB_CODE
 ORDER BY 1, 2;
 
--------------------------------------------------------------------------------

/*
    < HAVING 절 >
    1. GROUP BY 절과 함께 사용됨 
    2. 그룹함수에 대한 조건을 제시할 때 주로 사용
    3. 표현법
       SELECT 컬럼, 산술식, 함수식
         FROM 테이블명
        WHERE 조건식
        GROUP BY 그룹기준의컬럼|함수식, 컬럼, ..
       HAVING 그룹함수식을통한조건|그룹컬럼을통한조건
*/

-- 각 부서별 평균 급여 조회 (부서코드, 평균급여)
SELECT DEPT_CODE, AVG(SALARY)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE;
 
-- 부서별 평균급여가 300만원이상인 부서만을 조회 
SELECT DEPT_CODE, AVG(SALARY)
  FROM EMPLOYEE
 WHERE AVG(SALARY) >= 3000000  -- 오류 발생 (그룹함수식을 가지고 WHERE 조건작성 불가)
 GROUP BY DEPT_CODE;

SELECT DEPT_CODE, AVG(SALARY)   -- 4
  FROM EMPLOYEE                 -- 1
 GROUP BY DEPT_CODE             -- 2
HAVING AVG(SALARY) >= 3000000;  -- 3

-- 직급별 급여합이 1000만원 이상인 직급만을 조회 
SELECT JOB_CODE, SUM(SALARY)
  FROM EMPLOYEE
 GROUP BY JOB_CODE
 HAVING SUM(sALARY) >= 10000000;

-- 부서별 보너스를받는사원이 없는 부서만을 조회 
SELECT DEPT_CODE, COUNT(BONUS)
  FROM EMPLOYEE
 GROUP BY DEPT_CODE
HAVING COUNT(BONUS) = 0;

/*
    < SELECT 실행순서 >
    5: SELECT      * | 조회하고자하는 컬럼 AS 별칭 | 산술식 "별칭" | 함수식 AS "별칭"
    1:   FROM      조회하고자하는 테이블명
    2:  WHERE      조건식 (연산자들 가지고 기술)
    3:  GROUP BY   그룹기준으로 삼을 컬럼 | 함수식
    4: HAVING      조건식 (그룹함수를 가지고 기술)
    6:  ORDER BY   컬럼|별칭|순번  [ASC|DESC]  [NULLS FIRST|NULLS LAST]
*/

-- 남자사원들 중 부서별로 보너스를 받는 사원이 없는 부서 
SELECT DEPT_CODE
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) = '1'   -- 남자사원들만 추려짐
 GROUP BY DEPT_CODE                 -- 남자사원들가지고 부서별 그룹으로 묶임
HAVING COUNT(BONUS) = 0;            -- 남자사원들 부서별 보너스를받는사원수가 0인 것들만 추려짐

-- 보너스별 사원수 
SELECT BONUS, COUNT(*)
  FROM EMPLOYEE
 GROUP BY BONUS;
 
-- 사수별 사원수(후임수) => 후임이 3명 이상인 사수 => MANAGER_ID가 NULL인건 제외
SELECT MANAGER_ID, COUNT(*)
  FROM EMPLOYEE
 WHERE MANAGER_ID IS NOT NULL   -- 가능
 GROUP BY MANAGER_ID
HAVING COUNT(*) >= 3;
  -- AND MANAGER_ID IS NOT NULL; -- 가능
  
-- 급여 등급(고급/중급/초급)별 사원수 
SELECT CASE 
       WHEN SALARY >= 5000000 THEN '고급'
       WHEN SALARY >= 3500000 THEN '중급'
       ELSE '초급'
       END "등급"
     , COUNT(*) "사원수"
  FROM EMPLOYEE
 GROUP BY CASE 
          WHEN SALARY >= 5000000 THEN '고급'
          WHEN SALARY >= 3500000 THEN '중급'
          ELSE '초급'
          END;
          

SELECT '고급', COUNT(*)  -- 고급 등급 사원수
  FROM EMPLOYEE
 WHERE SALARY >= 5000000

UNION

SELECT '중급', COUNT(*)  -- 중급 등급 사원수
  FROM EMPLOYEE
 WHERE SALARY < 5000000 
   AND SALARY >= 3500000

UNION

SELECT '초급', COUNT(*)  -- 초급 등급 사원수 
  FROM EMPLOYEE
 WHERE SALARY < 3500000;

--------------------------------------------------------------------------------

/*
    < 집합 연산자 SET OPERATION >
    여러개의 쿼리문을 가지고 하나의 결과물로 조회하는 연산자
    
    1. UNION     : OR | 합집합 (두 쿼리의 결과값을 더함, 중복된 값은 한번만)
    2. INTERSECT : AND|교집합 (두 쿼리의 결과값의 중복된 값)
    3. UNION ALL : 합집합+교집합 (두 쿼리의 결과값을 무조건 더함, 중복된 값 여러번)
    4. MINUS     : 차집합 (선행 쿼리 결과에 후행 쿼리 결과를 뺀 나머지값)
    
    [유의사항]
    1. 각 쿼리문의 SELECT절에 작성되는 컬럼 갯수 동일
    2.              "                  컬럼 타입 동일 
    3. ORDER BY절은 마지막 쿼리에 작성
    
*/

-- 1. UNION
--    부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회 

--   > 부서코드가 D5인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5' -- 6명("박나라", 하이유, 김해술, "심봉선", 윤은해, "대북혼")
 --ORDER BY EMP_NAME 
 
 UNION
--   > 급여가 300만원 초과인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000 -- 8명(선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 전지연)
 ORDER BY EMP_NAME; 


-- WHERE 절에 OR 연산자 활용 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
    OR SALARY > 3000000;


-- 2. INTERSECT
--    부서코드가 D5이면서 급여가 300만원 초과인 사원 

--   > 부서코드가 D5인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5' -- 6명("박나라", 하이유, 김해술, "심봉선", 윤은해, "대북혼")

 INTERSECT
--   > 급여가 300만원 초과인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000; -- 8명(선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 전지연)

-- WHERE 절에 AND 활용
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5'
   AND SALARY > 3000000;


-- 3. UNION ALL 

--   > 부서코드가 D5인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5' -- 6명("박나라", 하이유, 김해술, "심봉선", 윤은해, "대북혼")

 UNION ALL
--   > 급여가 300만원 초과인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000; -- 8명(선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 전지연)

-- 4. MINUS
--    부서코드가 D5인 사원들 중 급여가 300만원 초과인 사원들은 제외해서 조회 

--   > 부서코드가 D5인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5' -- 6명("박나라", 하이유, 김해술, "심봉선", 윤은해, "대북혼")

 MINUS
--   > 급여가 300만원 초과인 사원
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
  FROM EMPLOYEE
 WHERE SALARY > 3000000; -- 8명(선동일, 송종기, 송은희, 유재식, "박나라", "심봉선", "대북혼", 전지연)

 
 
 
 
 