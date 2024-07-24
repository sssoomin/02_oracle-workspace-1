/*
    < DML >
    1. Data Manipulation Language 
    2. 데이터 조작어
    3. 데이터값을 관리(삽입, 수정, 삭제)하는 언어
    4. 종류
       1) INSERT    : 삽입
       2) UPDATE    : 수정
       3) DELETE    : 삭제
       
*/

/*
    1. INSERT
       테이블에 새로운 행을 추가하는 구문 
       
    1_1) 테이블의 모든 컬럼값을 제시해서 한 행 추가 
    
    [표현법]
    INSERT INTO 테이블명 VALUES(값, 값, 값, ...);
    
    [유의사항]
    테이블에 존재하는 컬럼순번대로 모든 값을 작성해야됨
    ㄴ 부족하게 값 제시시  => not enough value 오류
    ㄴ 값을 더 많이 제시시 => too many values 오류 
*/

-- EMPLOYEE 테이블에 새로운 사원 추가
INSERT INTO EMPLOYEE
VALUES(900, '장채현', '980918-2222211', 'jang_ch@br.com', '01011112222',
       'D1', 'J7', 4000000, 0.2, 200, SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

/*
    1_2) 특정 컬럼만 선택한 후 값을 제시해서 한 행 추가 
    
    [표현법]
    INSERT INTO 테이블명(컬럼명, 컬럼명) VALUES(값, 값);
    
    [유의사항]
    한 행 단위로 추가되기때문에 선택되지 않은 컬럼에도 값이 자동으로 들어감
    기본적으로 NULL로 들어감. 단, DEFAULT값이 있다면 DEFAULT값이 기록됨
    => NOT NULL제약조건이 부여되어있는 컬럼에 DEFAULT값이 등록되어있지 않을 경우 
       반드시 선택해서 값을 제시해야됨
    
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES(901, '강람보', '870123-2233412', 'J7', SYSDATE);

-- [참고] INSERT 작성 스타일
INSERT 
  INTO EMPLOYEE
  (
    EMP_ID
  , EMP_NAME
  , EMP_NO
  , JOB_CODE
  , HIRE_DATE
  )
VALUES
  (
    ?
  , ?
  , ?
  , ?
  , ?
  );

/*
    1_3) 서브쿼리 수행 결과값을 통채로 추가하기
    
    [표현법]
    INSERT INTO 테이블명[(컬럼명, 컬럼명)]
        서브쿼리;
*/

-- 실습을 위한 테이블 생성
CREATE TABLE EMP_01(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(20),
    DEPT_TITLE VARCHAR2(20)
);

SELECT * FROM EMP_01;

-- 전체 사원들의 사번, 이름, 부서명 조회해서 EMP_01 테이블에 일괄등록
INSERT INTO EMP_01
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
      FROM EMPLOYEE
      LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

/*
    1_4) 서브쿼리의 결과값을 두개 이상의 테이블에 추가하기 
    
    [표현법]
    INSERT ALL 
      INTO 테이블1[(컬럼명, 컬럼명, ..)] [VALUES(서브쿼리결과값컬럼, ..)]
      INTO 테이블2[(컬럼명, 컬럼명, ..)] [VALUES(서브쿼리결과값컬럼, ..)]
    서브쿼리;
*/
-- 실습용 테이블 생성 
CREATE TABLE EMP_DEPT
    AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
         FROM EMPLOYEE
        WHERE 1=0;
        
CREATE TABLE EMP_MANAGER
    AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
         FROM EMPLOYEE
        WHERE 1=0;

SELECT * FROM EMP_DEPT;     -- EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE (4컬럼)
SELECT * FROM EMP_MANAGER;  -- EMP_ID, EMP_NAME, MANAGER_ID           (3컬럼)

-- 부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D1'; -- 4명

INSERT ALL
  INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
  INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
  FROM EMPLOYEE
 WHERE DEPT_CODE = 'D1';
 
/*
    1_5) 서브쿼리 결과값 중 특정 조건에 만족하는 값만을 각 테이블 추가하기
    
    [표현법]
    INSERT ALL
        WHEN 조건1 THEN INTO 테이블1[(컬럼명, 컬럼명, ..)] [VALUES(서브쿼리결과값컬럼, ..)]
        WHEN 조건2 THEN INTO 테이블2[(컬럼명, 컬럼명, ..)] [VALUES(서브쿼리결과값컬럼, ..)]
    서브쿼리;
*/

-- 실습용 테이블 생성 
CREATE TABLE EMP_OLD
    AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
         FROM EMPLOYEE
        WHERE 1=0;

CREATE TABLE EMP_NEW
    AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
         FROM EMPLOYEE
        WHERE 1=0;
        
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

INSERT ALL
  WHEN HIRE_DATE < '2000/01/01' THEN INTO EMP_OLD
  WHEN HIRE_DATE >= '2000/01/01' THEN INTO EMP_NEW
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
  FROM EMPLOYEE;

/*
    1_번외) INSERT할 컬럼값으로 서브쿼리 결과값 작성 가능 
    
    [표현법]
    INSERT ~~~~ VALUES(값, 값, .., 서브쿼리)
*/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SALARY)
VALUES(500, '김말순', '900711-2233445', 'J7', (SELECT MAX(SALARY) FROM EMPLOYEE));

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, SALARY)
VALUES(501, '김개똥', '870411-2233445', 'J7', (SELECT MAX(SALARY) FROM EMPLOYEE)+5000000);

---------------------------------------------------------------------------------

/*
    2. UPDATE
       테이블에 기록되어있는 기존의 데이터를 수정하는 구문
       
       [표현법]
       UPDATE 테이블명 
          SET 컬럼명 = 바꿀값
            , 컬럼명 = 바꿀값
            ,  ...
        [WHERE 조건]; --> 생략시 전체행의 데이터가 변경됨
*/

-- 실습용 테이블 생성
CREATE TABLE DEPT_COPY
    AS SELECT *
         FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- D9 부서의 부서명을 '전략기획팀' 으로 수정
UPDATE DEPT_COPY
   SET DEPT_TITLE = '전략기획팀';

ROLLBACK; -- 실수했을 경우 변경사항을 취소

UPDATE DEPT_COPY
   SET DEPT_TITLE = '전략기획팀'
 WHERE DEPT_ID = 'D9';
 
-- 실습용 테이블 생성
CREATE TABLE EMP_SALARY
    AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
         FROM EMPLOYEE;

SELECT * FROM EMP_SALARY;

-- 노옹철 사원의 급여를 100만원으로 변경
UPDATE EMP_SALARY
   SET SALARY = 1000000
 WHERE EMP_NAME = '노옹철';

-- 선동일 사원의 급여를 700만원으로, 보너스는 0.2로 변경
UPDATE EMP_SALARY
   SET SALARY = 7000000
     , BONUS = 0.2
 WHERE EMP_NAME = '선동일';

-- 전체 사원의 급여를 기존의 급여에 10프로 인상한 금액으로 변경 (기존급여*1.1)
UPDATE EMP_SALARY
   SET SALARY = SALARY * 1.1;

/*
    번외) 서브쿼리 활용
    
    [표현법]
    UPDATE 테이블명
       SET 컬럼명 = (서브쿼리)
     WHERE 조건식에 서브쿼리도 가능
*/

-- 방명수 사원의 급여와 보너스값을 유재식사원의 급여와 보너스값으로 변경
UPDATE EMP_SALARY
   SET SALARY = (SELECT SALARY
                   FROM EMP_SALARY
                  WHERE EMP_NAME = '유재식')
     , BONUS = (SELECT BONUS
                  FROM EMP_SALARY
                 WHERE EMP_NAME = '유재식') -- 단일행서브쿼리
 WHERE EMP_NAME = '방명수';
 
UPDATE EMP_SALARY
   SET (SALARY, BONUS) = (SELECT SALARY, BONUS
                            FROM EMP_SALARY
                           WHERE EMP_NAME = '유재식') -- 다중열서브쿼리
 WHERE EMP_NAME = '방명수';

SELECT * FROM EMP_SALARY;

-- ASIA 지역에서 근무하는 사원들의 보너스를 0.3으로 변경
UPDATE EMP_SALARY
   SET BONUS = 0.3
 WHERE EMP_ID IN (SELECT EMP_ID
                   FROM EMP_SALARY
                   JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
                   JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
                  WHERE LOCAL_NAME LIKE 'ASIA%');

-- * UPDATE 시 제약조건 유의할것
-- EMPLOYEE 에 사번이 200인 사원의 이름을 NULL로 변경
UPDATE EMPLOYEE
   SET EMP_NAME = NULL
 WHERE EMP_ID = 200; --> NOT NULL 제약조건 위배
 
-- 노옹철 사원의 직급을 J9로 변경
UPDATE EMPLOYEE
   SET JOB_CODE = 'J9'
 WHERE EMP_NAME = '노옹철'; --> 외래키 제약조건 위배
 
---------------------------------------------------------------------------------

/*
    3. DELETE
       테이블에 기록된 데이터를 삭제하는 구문 
       
       [표현법]
       DELETE 
         FROM 테이블명
        [WHERE 조건];  --> 생략시 전체 행 다 삭제됨
*/

-- EMPLOYEE 장채현 사원 삭제 
DELETE 
  FROM EMPLOYEE
 WHERE EMP_NAME = '장채현';

ROLLBACK;

-- EMPLOYEE에 901, 500, 501 사원 삭제
DELETE
  FROM EMPLOYEE
 WHERE EMP_ID IN ('901', '500', '501');

COMMIT;

-- DEPT_ID가 D1인 부서를 삭제
DELETE 
  FROM DEPARTMENT
 WHERE DEPT_ID = 'D1'; -- D1값을 가져다 쓰고있는 자식데이터가 있기 때문에 삭제 불가능

-- DEPARTMENT(부모) -|--------<- EMPLOYEE(자식)
--       1                :           N

-- 삭제시 외래키 제약조건으로 데이터 삭제 불가능시
-- 제약조건(SYS_C007130)을 비활성화 시킬 수 있음 
ALTER TABLE EMPLOYEE DISABLE CONSTRAINT SYS_C007130 CASCADE;

DELETE 
  FROM DEPARTMENT
 WHERE DEPT_ID = 'D1'; 
 
SELECT * FROM DEPARTMENT;

ROLLBACK;

INSERT INTO DEPARTMENT VALUES ('D1', '인사관리부', 'L1');

-- 활성화
ALTER TABLE EMPLOYEE ENABLE CONSTRAINT SYS_C007130;

/*
    4. TRUNCATE 
       테이블의 전체 행을 삭제할 때 사용되는 구문 (DDL)
       DELETE 보다 수행속도가 더 빠름
       별도의 조건 제시 불가, ROLLBACK 불가능
       
       [표현법]
       TRUNCATE TABLE 테이블명;
*/
SELECT * FROM EMP_SALARY;

TRUNCATE TABLE EMP_SALARY;
ROLLBACK;



