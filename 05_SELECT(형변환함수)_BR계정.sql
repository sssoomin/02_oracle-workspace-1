/*
    < 형변환 함수 >
    날짜|숫자|문자 데이터를 다른 타입으로 변환시켜주는 함수
    
    
    1. TO_CHAR **
       NUMBER타입 또는 DATE타입의 값들을 CHARACTER 타입으로 변환시켜 반환
       
       [표현법]
       TO_CHAR(NUMBER|DATE, [포맷])
*/

-- * 숫자 => 문자
SELECT TO_CHAR(1234) FROM DUAL; -- '1234'
SELECT TO_CHAR(1234, '99999') FROM DUAL; -- 5자리 문자열로 변환, 빈자리는 공백으로 채움 ' 1234'
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- 5자리 문자열로 변환, 빈자리는 0으로 채움    '01234'

SELECT TO_CHAR(1234, 'L999999999999') FROM DUAL; -- 현재 설정된 나라(LOCAL)의 화폐단위
SELECT TO_CHAR(1234, '$999999999999') FROM DUAL;

SELECT TO_CHAR(1212334, 'L999,999,999') FROM DUAL;

SELECT EMP_NAME, TO_CHAR(SALARY*12, 'L999,999,999')
FROM EMPLOYEE;

-- * 날짜 => 문자
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE) FROM DUAL; -- '24/07/17'
SELECT TO_CHAR(SYSDATE, 'AM HH:MI:SS') FROM DUAL;   -- HH : 12시간형식 (01~12)
SELECT TO_CHAR(SYSDATE, 'PM HH24:MI:SS') FROM DUAL; -- HH24 : 24시간형식 (00~23)

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY') FROM DUAL;

-- 2024년 7월 17일
SELECT TO_CHAR(SYSDATE, 'YYYY YY RRRR RR YEAR') -- '2024' '24' '2024' '24' 'TWENTY TWENTY-FOUR'
     , TO_CHAR(SYSDATE, 'MM MON MONTH RM') -- '07' '7월' '7월' 'VII (로마숫자)'
     , TO_CHAR(SYSDATE, 'DDD DD D') -- '199(년 기준 몇일째)' '17(월 기준 몇일째)' '4(주 기준 몇일째)' 
     , TO_CHAR(SYSDATE, 'DAY DY') -- '수요일' '수'
  FROM DUAL;
  
  
-- EX) 1990년 02월 06일 (수)
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YYYY"년" MM"월" DD"일" (DY)')
FROM EMPLOYEE;


/*
    2. TO_DATE **
       NUMBER 타입 또는 CHARACTER 타입 데이터를 DATE타입으로 변환시켜서 반환 
       
       [표현법]
       TO_DATE(NUMBER|CHARACTER, [포맷])
*/
SELECT TO_DATE(20100101) FROM DUAL; -- 8자리숫자 제시시 (4자리=년도 2자리=월 2자리=일)
SELECT TO_DATE(20101255) FROM DUAL; -- 오류 55일 없음
SELECT TO_DATE(100101) FROM DUAL;   -- 6자리숫자 제시시 (2자리=년도 2자리=월 2자리=일)
SELECT TO_DATE(070101) FROM DUAL;   -- 오류, 70101로 인식됨 

SELECT TO_DATE('070101') FROM DUAL;
SELECT TO_DATE('20070101') FROM DUAL;

SELECT TO_DATE('041030 143030', 'YYMMDD HH24MISS') FROM DUAL;

SELECT TO_DATE('140630', 'YYMMDD') -- 2014년도
     , TO_DATE('980630', 'YYMMDD') -- 2098년도
FROM DUAL;
-- YY : 무조건 현재세기로 반영

SELECT TO_DATE('140630', 'RRMMDD') -- 2014년도
     , TO_DATE('980630', 'RRMMDD') -- 1998년도
FROM DUAL;
-- RR : 두자리년도값이 50미만일 경우 현재세기 반영, 50이상일 경우 이전세기 반영


/*
    3. TO_NUMBER
       CHARACTER 타입의 데이터를 NUMBER타입으로 변환해서 반환 
       
       [표현법]
       TO_NUMBER(CHARACTER, [포맷])
*/

SELECT TO_NUMBER('01234') FROM DUAL;

SELECT '1000000' + '5500000' FROM DUAL; --> 자동형변환 진행되서 덧셈연산됨 

SELECT '1,000,000' + '5,500,000' FROM DUAL; -- 오류

SELECT TO_NUMBER('1,000,000', '9,999,999') + TO_NUMBER('5,500,000', '9,999,999') FROM DUAL;







