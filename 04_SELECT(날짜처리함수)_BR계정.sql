/*
    < 날짜 처리 함수 >
    날짜 데이터를 가지고 연산을 수행해주는 함수로
    반환 값은 날짜 또는 숫자가 될 수 있음
*/

-- 1. SYSDATE : 현재 시스템 날짜 및 시간 반환 
SELECT SYSDATE FROM DUAL;
SELECT SYSDATE - 2 FROM DUAL;
SELECT SYSDATE + 2 FROM DUAL;

/*
    2. MONTHS_BETWEEN
       두 날짜 사이의 개월수를 NUMBER 타입으로 반환 
       
       [표현법]
       MONTHS_BETWEEN(DATE1, DATE2)    => 내부적으로 DATE1-DATE2 후 나누기 30, 31이 진행됨
*/

-- EMPLOYEE에서 사원명, 입사일, 근무일수, 근무개월수
SELECT EMP_NAME, HIRE_DATE
     , CEIL(SYSDATE - HIRE_DATE) "근무일수"
     , CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수"
FROM   EMPLOYEE
ORDER BY 4 DESC;

/*
    3. ADD_MONTHS
       특정 날짜에 특정 개월수를 더한 날짜를 DATE 타입으로 반환
       
       [표현법]
       ADD_MONTHS(DATE, NUMBER)
*/
SELECT ADD_MONTHS(SYSDATE, 5) FROM DUAL;

-- 사원명, 입사일, 입사후 6개월(정규직이 된 날짜)이 된 날짜
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정규직된날짜"
FROM EMPLOYEE;

/*
    4. NEXT_DAY
       특정 날짜 이후에 가까운 요일의 날짜를 DATE 타입으로 반환 
       
       [표현법]
       NEXT_DAY(DATE, 요일(문자|숫자))
       
       [참고]
       일요일:1, 월요일:2, .... 토요일:7
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL; -- 에러 (현재 언어가 KOREAN때문)

-- 언어 변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
ALTER SESSION SET NLS_LANGUAGE = KOREAN;


/*
    5. LAST_DAY
       특정 날짜의 해당 달에 마지막 날짜를 DATE 타입으로 반환 
       
       [표현법]
       LAST_DAY(DATE)
*/
SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- 사원명, 입사한 달의 마지막 날짜, 입사한달에 근무일수
SELECT EMP_NAME, LAST_DAY(HIRE_DATE), LAST_DAY(HIRE_DATE) - HIRE_DATE + 1
FROM EMPLOYEE;

/*
    6. EXTRACT 
       특정 날짜로부터 년도|월|일 값을 추출해서 NUMBER 타입으로 반환 
       
       [표현법]
       EXTRACT(YEAR FROM DATE)
       EXTRACT(MONTH FROM DATE)
       EXTRACT(DAY FROM DATE)
*/
-- 사원명, 입사년도, 입사월, 입사일 조회 
SELECT EMP_NAME
     , EXTRACT(YEAR FROM HIRE_dATE) "입사년도"
     , EXTRACT(MONTH FROM HIRE_DATE) "입사월"
     , EXTRACT(DAY FROM HIRE_DATE) "입사일"
  FROM EMPLOYEE
 ORDER 
    BY 입사년도, 입사월, 입사일;

