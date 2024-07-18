/*
    < 그룹함수 >
    N개의 값을 읽어들여 1개의 결과를 반환하는 함수
    
    1. SUM(NUMBER)
       전달된 컬럼값들의 총 합계를 구해 NUMBER타입으로 반환 
*/

-- EMPLOYEE 전 사원의 총급여합
SELECT SUM(SALARY)
  FROM EMPLOYEE; -- 전체사원이 한 그룹으로 묶임
  
-- 남자 사원들의 총급여합
SELECT SUM(SALARY)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3'); -- 남자사원들이 한 그룹으로 묶임
 
-- 부서코드가 D5인 사원들의 총 연봉 합
SELECT SUM(SALARY*12)
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D5';
 
/*
    2. AVG(NUMBER)
       전달된 컬럼값들의 평균을 구해 NUMBER 타입으로 반환 
*/

-- 전체 사원의 평균급여
SELECT SUM(SALARY) / 23
     , AVG(SALARY)
     , TO_CHAR( ROUND( AVG(SALARY) ), 'L999,999,999' )
  FROM EMPLOYEE;
  
/*
    3. MIN(ANY)
       전달된 컬럼값들 중 최소값을 구해 해당 타입으로 반환
*/

SELECT MIN(EMP_NAME)
     , MIN(SALARY)
     , MIN(HIRE_DATE)
  FROM EMPLOYEE;
  
/*
    4. MAX(ANY)
       전달된 컬럼값들 중 최대값을 구해 해당 타입으로 반환
*/
SELECT MAX(EMP_NAME)
     , MAX(SALARY)
     , MAX(HIRE_DATE)
  FROM EMPLOYEE;

/*
    5. COUNT(* | [DISTINCT] ANY)
       전달된 행의 갯수 | 컬럼 값의 갯수를 세서 NUMBER타입으로 반환 
       
       [표현법]
       COUNT(*)             : 조회된 결과의 모든 행 갯수를 세서 반환
       COUNT(컬럼)          : 조회된 컬럼의 값들의 갯수를 세서 반환 (단, NULL은 제외)
       COUNT(DISTINCT 컬럼) : 해당 컬럼값 중복을 제거한 후 갯수를 세서 반환 
*/

-- 전체 사원 수 
SELECT COUNT(*)
  FROM EMPLOYEE;
  
-- 여자 사원 수
SELECT COUNT(*)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4'); -- 8명
 
-- 여자 사원들 중 보너스를 받는 사원 수
SELECT COUNT(*)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4')
   AND BONUS IS NOT NULL; -- 4명

SELECT COUNT(BONUS)
  FROM EMPLOYEE
 WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4'); -- 4명
 
-- 부서배치를 받은 사원수 (21명)
SELECT COUNT(DEPT_CODE)
  FROM EMPLOYEE;
  
-- 현재 사원들이 총 몇개의 부서에 분포되어있는지 
SELECT DISTINCT DEPT_CODE -- 7개
  FROM EMPLOYEE;

SELECT COUNT(DISTINCT DEPT_CODE) -- 6 (NULL인건 세어지지 않음)
  FROM EMPLOYEE;

SELECT COUNT(DISTINCT NVL(DEPT_CODE, '없음')) -- 7
  FROM EMPLOYEE;

 
