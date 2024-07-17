/*
    < NULL 처리 함수 >

    1. NVL(컬럼, 반환값)
       해당 컬럼값이 존재할경우 컬럼값 반환
       해당 컬럼값이 NULL일 경우 반환값 반환 
*/
SELECT EMP_NAME, NVL(BONUS, 0)
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(BONUS, '없음') -- BONUS 컬럼값이 NUMBER 타입이여서 CHARACTER 타입의 반환값 작성시 오류
FROM EMPLOYEE;

SELECT EMP_NAME, NVL(DEPT_CODE, '없음')
FROM EMPLOYEE;

-- 사원명, 보너스포함연봉
SELECT EMP_NAME, (SALARY + SALARY * NVL(BONUS, 0) ) * 12
FROM EMPLOYEE;

/*
    2. NVL2(컬럼, 반환값1, 반환값2)
       컬럼값이 존재할 경우 반환값1 반환
       컬럼값이 NULL일 경우 반환값2 반환
*/

SELECT EMP_NAME, NVL2(BONUS, 0.7, 0), NVL2(DEPT_CODE, '부서있음', '부서없음')
FROM EMPLOYEE;

/*
    3. NULLIF(비교대상1, 비교대상2)
       두 개의 값이 일치하면 NULL 반환
       두 개의 값이 일치하지 않으면 비교대상1 값 반환
*/
SELECT NULLIF('123', '123') FROM DUAL;
SELECT NULLIF('123', '456') FROM DUAL;

-------------------------------------------------------------------------------

/*
    < 선택 함수 >
    
    1. DECODE(비교대상, 비교값1, 결과값1, 비교값2, 결과값2, ...., 결과값N)
       비교대상의 값을 가지고 특정 값과 일치하는지 비교 후 해당 결과값 반환 
       
       switch(비교대상){
       case 비교값1:
       case 비교값2:
        ...
       default:
       }
*/
SELECT EMP_NAME, EMP_NO, DECODE( SUBSTR(EMP_NO,8,1), '1', '남', '2', '여' ) "성별"
FROM EMPLOYEE;

-- 직원 급여조회 각 직급별로 인상시켜 조회 
-- J7인 사원은 급여를 10% 인상 (SALARY * 1.1)
-- J6인 사원은 급여를 15% 인상 (SALARY * 1.15)
-- J5인 사원은 급여를 20% 인상 (SALARY * 1.2)
-- 그 외 사원은 급여를 5% 인상 (SALARY * 1.05)
SELECT EMP_NAME, JOB_CODE, SALARY "기존급여"
     , DECODE(JOB_CODE, 'J7', SALARY * 1.1
                      , 'J6', SALARY * 1.15
                      , 'J5', SALARY * 1.2
                            , SALARY * 1.05) "인상된급여"
  FROM EMPLOYEE;

/*
    2. CASE WHEN THEN END
       함수는 아니지만 선택함수처럼 사용할 수 잇는 문법
       
       [표현법1] - DECODE와 유사
       CASE 비교대상 
       WHEN 비교값1 THEN 결과값1
       WHEN 비교값2 THEN 결과값2
          ....
       [ELSE 결과값N]
       END
       
       
       [표현법2]
       CASE 
       WHEN 조건식1 THEN 결과값1
       WHEN 조건식2 THEN 결과값2
         ....
       [ELSE 결과값N]
       END
       
*/

SELECT EMP_NAME
     , CASE SUBSTR(EMP_NO, 8, 1)
       WHEN '1' THEN '남'
       WHEN '2' THEN '여'
       END "성별"
  FROM EMPLOYEE;

-- 급여가 500만원 이상일 경우 '고급' 
-- 급여가 350만원 이상일 경우 '중급'
--   그외 일 경우 '초급'
SELECT EMP_NAME
     , CASE 
       WHEN SALARY >= 5000000 THEN '고급'
       WHEN SALARY >= 3500000 THEN '중급'
       ELSE '초급'
       END "등급"
  FROM EMPLOYEE;

