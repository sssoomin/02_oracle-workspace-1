/*
    < 함수 FUNCTION >
    
    1. 전달된 값을 가지고 특정 연산 수행 후 결과를 반환해줌
    2. 전달된 값의 수와 반환된 값의 수를 통해 종류가 나뉨
        ㄴ 단일행 함수 : N개의 값을 읽어들여 N개의 결과값 반환 (매 행마다 함수 실행 결과 반환)
        ㄴ 그룹 함수   : N개의 값을 읽어들여 1개의 결과값 반환 (그룹을 지어 그룹별로 함수 실행 결과 반환)
       따라서 단일행 함수와 그룹함수는 함께 사용할 수 없음 (결과의 행 수가 다르기 때문에)
    3. SELECT절, WHERE절, ORDER BY절, GROUP BY절, HAVING절, DML구문 등 다양한 곳에서 작성 가능
    
*/

/*
    < 문자 처리 함수 >
    문자 데이터를 가지고 연산을 해주는 함수로
    반환 결과는 문자 또는 숫자가 될 수 있음
    
    1. LENGTH | LENGTHB
       문자열의 글자수 및 바이트 수를 NUMBER 타입으로 반환
       
       [표현법]
       LENGTH('문자열값'|컬럼)    : 전달된 문자열값의 글자수 반환 
       LENGTHB('문자열값'|컬럼)   : 전달된 문자열값의 바이트수 반환 
       
       [참고]
       'ㄱ', 'ㅏ', '가' 한글 한글자당 3BYTE
       영문자, 숫자, 특수문자 한글자당 1BYTE
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
     , LENGTH('ORACLE'), LENGTHB('ORACLE')
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME)
     , EMAIL, LENGTH(EMAIL), LENGTHB(EMAIL)
  FROM EMPLOYEE;

-- 이메일이 13글자인 사원들 모든 컬럼 조회
SELECT * 
FROM EMPLOYEE
WHERE LENGTH(EMAIL) = 13;

/*
    2. INSTR
       문자열로부터 특정 문자의 시작위치를 찾아서 NUMBER 타입으로 반환
       
       [표현법]
       INSTR('문자열값'|컬럼, '찾고자하는문자', [찾을위치의 시작값, [순번]])
*/

SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL; -- 찾을위치의시작값 1 기본값, 순번도 1 기본값
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', -1, 2) FROM DUAL;
SELECT INSTR('AABAACAABBAA', 'B', 4, 2) FROM DUAL;

SELECT EMAIL, INSTR(EMAIL, '_', 1, 1) "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;

-- _ 기준으로 앞에 3글자인 사원 조회
SELECT *
FROM EMPLOYEE
--WHERE EMAIL LIKE '___$_%' ESCAPE '$';
WHERE INSTR(EMAIL, '_') = 4;

/*
    3. SUBSTR
       문자열에서 특정 문자열을 추출해서 CHARACTER 타입으로 반환 
       
       [표현법]
       SUBSTR(STRING, POSITION, [LENGTH])
       
        ㄴ STRING : 문자타입컬럼 또는 '문자열값'
        ㄴ POSITION : 문자열을 추출할 시작위치 
        ㄴ LENGTH : 추출할 문자 갯수 (생략시 끝까지 의미)
*/
SELECT SUBSTR('SHOWMETHEMONEY', 7) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 6) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, 3) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', -8, -3) FROM DUAL; -- 부적절하게 제시시 오류X, NULL 반환

-- 사원들의 성별 유추
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1) "성별" -- '1' '2'
FROM EMPLOYEE;

-- 여자 사원들만 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '2' OR SUBSTR(EMP_NO, 8, 1) = '4';

-- 남자 사원들만 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('1', '3');

-- * 응용 (함수 중첩 사용가능)
--   전 사원의 이름, 이메일, 아이디 
--   ex) 선동일, sun_di@br.com, sun_di
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') - 1)
FROM EMPLOYEE;

-- 전 사원의 이름, 주민번호(ex) 900815-2****** 형식) 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 8) || '******' "EMP_NO"
FROM EMPLOYEE;

/*
    4. LPAD | RPAD
       문자열에 특정 문자를 왼쪽 또는 오른쪽에 덧붙여서 CHARACTER 타입으로 반환 
       
       [표현법]
       LPAD|RPAD(STRING, 최종적으로반환할문자의길이, [덧붙이고자하는문자])
*/

SELECT EMP_NAME, LPAD(EMAIL, 16) "EMAIL" -- 덧붙이고자하는 문자 생략시 공백
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL, 16, '#') "EMAIL"
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL, 16, '#') "EMAIL"
FROM EMPLOYEE;

-- 주민번호 (900815-1******)
SELECT EMP_NAME, RPAD(SUBSTR(EMP_NO, 1, 8), 14, '*')
FROM EMPLOYEE;

/*
    5. LTRIM | RTRIM 
       문자열에서 왼쪽 또는 오른쪽에 특정 문자들을 제거한 나머지 문자열을 CHARACTER 타입으로 반환 
       
       [표현법]
       LTRIM|RTRIM(STRING, [제거하고자하는문자들])
*/
SELECT LTRIM('   B R  ') FROM DUAL; -- 제거하고자하는 문자 생략시 공백문자
SELECT LTRIM('123123BR123', '132') FROM DUAL;
SELECT RTRIM('572834BR1235462', '0123456789') FROM DUAL;

/*
    6. TRIM
       문자열의 앞/뒤/양쪽에 있는 지정한 문자를 제거한 나머지 문자열을 CHARACTER 타입으로 반환 
       
       [표현법]
       TRIM( [ [LEADING|TRAILING|BOTH] 제거하고자하는문자 FROM ] STRING)
       
       [유의사항]
       LTRIM, RTRIM과 다르게 제거하고자하는문자를 한개만 써야됨
*/

SELECT TRIM('   B R   ') FROM DUAL; -- 기본적으로 양쪽에 공백문자 제거
SELECT TRIM('Z' FROM 'ZZZBRZZZ') FROM DUAL;

SELECT TRIM(LEADING 'Z' FROM 'ZZZBRZZZ') FROM DUAL;
SELECT TRIM(TRAILING 'Z' FROM 'ZZZBRZZZ') FROM DUAL;
SELECT TRIM(BOTH 'Z' FROM 'ZZZBRZZZ') FROM DUAL;

-- 전 사원의 이름, 아이디 형식 조회 
SELECT EMP_NAME, LPAD(RTRIM(EMAIL, '@br.com'), 10) "아이디"
FROM EMPLOYEE;

/*
    7. LOWER | UPPER | INITCAP
       문자열을 소문자|대문자|앞글자만대문자로 변경한 문자열을 CHARACTER 타입으로 반환 
       
       [표현법]
       LOWER|UPPER|INITCAP(STRING)
*/
SELECT LOWER('Welcome To MyWorld!') FROM DUAL;
SELECT UPPER('Welcome To MyWorld!') FROM DUAL;
SELECT INITCAP('welcome to myworld!') FROM DUAL;

/*
    8. CONCAT
       문자열 두개를 전달받아 하나로 합쳐서 CHARACTER 타입으로 반환
       
       [표현법]
       CONCAT(STRING, STRING)
*/
SELECT CONCAT('가나다', 'ABC') FROM DUAL;

/*
    9. REPLACE
       문자열의 일부를 다른 문자열로 치환한 문자열을 CHARACTER 타입으로 반환
       
       [표현법]
       REPLACE(STRING, STR1, STR2)
*/
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'br.com', 'gmail.com')
FROM EMPLOYEE;




