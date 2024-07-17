/*
    < 숫자 처리 함수 >
    숫자 데이터를 가지고 연산을 수행해주는 함수로
    반환 결과 또한 숫자임
    
    1. ABS
       숫자의 절대값을 NUMBER 타입으로 반환
       
       [표현법]
       ABS(NUMBER) 
*/

SELECT ABS(-10) FROM DUAL;
SELECT ABS(-5.7) FROM DUAL;

/*
    2. MOD
       두 수를 나눈 나머지값을 NUMBER 타입으로 반환 
       
       [표현법]
       MOD(NUMBER, NUMBER)
*/

SELECT 10 / 3 FROM DUAL;
--SELECT 10 % 3 FROM DUAL;

SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;
SELECT MOD(-10.9, 3) FROM DUAL;

/*
    3. ROUND
       반올림한 결과를 NUMBER 타입으로 반환 
       
       [표현법]
       ROUND(NUMBER, [위치])
*/
SELECT ROUND(123.456) FROM DUAL; -- 위치 생략시 기본값 0
SELECT ROUND(123.456, 0) FROM DUAL;
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;

SELECT ROUND(123.456, -1) FROM DUAL;

/*
    4. CEIL 
       올림처리해서 NUMBER 타입으로 반환
       
       [표현법]
       CEIL(NUMBER)
*/
SELECT CEIL(123.123) FROM DUAL;
SELECT CEIL(123.000) FROM DUAL;

/*
    5. FLOOR
       소수점 아래 버림처리해서 NUMBER 타입으로 반환
       
       [표현법]
       FLOOR(NUMBER)
*/
SELECT FLOOR(123.152) FROM DUAL;
SELECT FLOOR(123.999) FROM DUAL;

/*
    6. TRUNC
       위치 지정 가능한 버림처리해주는 함수
       
       [표현법]
       TRUNC(NUMBER, [위치])
*/
SELECT TRUNC(123.456) FROM DUAL;
SELECT TRUNC(123.456, 1) FROM DUAL;
SELECT TRUNC(123.456, -1) FROM DUAL;


-- 사원명, 입사일, 근무일수
SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE - HIRE_DATE) || '일' "근무일수"
FROM EMPLOYEE;
