/*
    < VIEW 뷰 >
    1. 쿼리문(SELECT문)을 저장해둘 수 있는 데이터베이스 객체
    2. 임시 테이블처럼 활용할 수 있음 (데이터가 존재하는건 아니고 논리적인 테이블)
    3. 단 VIEW를 통해 DML문 수행시 많은 제약이 있으므로 조회용으로만 쓰는걸 권장함
*/

-- '한국'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '한국';

-- '러시아'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '러시아';

-- '일본'에서 근무하는 사원의 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
  FROM EMPLOYEE
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
  JOIN NATIONAL USING (NATIONAL_CODE)
 WHERE NATIONAL_NAME = '일본';
 
/*
    1. VIEW 생성 
    
    [표현법]
    CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW 뷰명 
        AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];
        
    1) OR REPLACE   : 기존에 동일한 뷰가 있을 경우 갱신시키고, 존재하지 않을 경우 생성시키는 옵션 
    2) FORCE|NOFORCE
        ㄴ FORCE  : 서브쿼리에 기술된 테이블이 없는 테이블이여도 뷰가 생성되도록 하는 옵션
        ㄴ NOFORCE: 서브쿼리에 기술된 테이블이 존재해야만 뷰를 생성시키는 옵션 (기본값)
    3) WITH CHECK OPTION : VIEW를 통해 DML시 서브쿼리에 기술된 조건에 부합한 값으로만 DML이 가능하도록 하는 옵션
    4) WITH READ ONLY    : 뷰에 대해 조회만 가능하게 하는 옵션 (DML문 수행불가)
    
    [유의사항]
    CREATE VIEW 권한 필요함 
*/

CREATE OR REPLACE VIEW VW_EMPLOYEE
    AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
         FROM EMPLOYEE
         JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
         JOIN NATIONAL USING (NATIONAL_CODE);

GRANT CREATE VIEW TO BR; -- 관리자계정에서 실행

SELECT *
  FROM VW_EMPLOYEE;
--> 아래와 같은 맥락
SELECT *
  FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
         FROM EMPLOYEE
         JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
         JOIN NATIONAL USING (NATIONAL_CODE));

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '한국';

SELECT *
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '러시아';

SELECT EMP_NAME, NATIONAL_NAME--, JOB_CODE
  FROM VW_EMPLOYEE
 WHERE NATIONAL_NAME = '일본';

-- [참고] USER_VIEWS : 현재 계정이 소유하고있는 뷰에 대한 정보를 표현하는 테이블
SELECT * FROM USER_VIEWS;

-------------------------------------------------------------------------------

-- * 뷰 정의시 서브쿼리에 산술식 또는 함수식이 있을 경우 반드시 별칭 부여해야됨
-- 사번, 이름, 직급명, 성별(남|여), 근무년수를 조회할 수 잇는 SELECT문을 뷰(VW_EMPJOB)로 정의
CREATE OR REPLACE VIEW VW_EMPJOB
    AS SELECT EMP_ID, EMP_NAME, JOB_NAME
            , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')          AS 성별
            , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)   AS 근무년수
         FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE);
         
-- 아래와 같은 방식으로도 가능 (단, 모든 별칭을 써야됨)
CREATE OR REPLACE VIEW VW_EMPJOB(사번, 사원명, 직급명, 성별, 근무년수)
    AS SELECT EMP_ID, EMP_NAME, JOB_NAME
            , DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')          
            , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)  
         FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE);

SELECT *
  FROM VW_EMPJOB; -- 논리적인테이블 (베이스테이블:EMPLOYEE,JOB)

SELECT 사원명, 근무년수
  FROM VW_EMPJOB
 WHERE 성별 = '여';

SELECT *
  FROM VW_EMPJOB
 WHERE 근무년수 >= 20;

-------------------------------------------------------------------------------

-- * 뷰를 통해서 DML(INSERT, UPDATE, DELETE) 사용 가능
--   단, 실제 베이스 테이블에 반영됨 

CREATE OR REPLACE VIEW VW_JOB
    AS SELECT JOB_CODE, JOB_NAME
         FROM JOB;
         
SELECT * FROM VW_JOB; -- 논리적인 테이블 (실제 데이터 X)
SELECT * FROM JOB;    -- 베이스 테이블 (실제 데이터 O)

-- 뷰를 통해 DELETE
DELETE 
  FROM VW_JOB
 WHERE JOB_CODE = 'J9';

-- 뷰를 통해 UPDATE
UPDATE VW_JOB
   SET JOB_NAME = '알바'
 WHERE JOB_CODE = 'J8';

-- 뷰를 통해 INSERT
INSERT INTO VW_JOB VALUES('J9', '인턴');

/*
    * 단, DML로 조작이 불가능한 경우가 더 많음
    
    1) 뷰에 정의되어있지 않은 컬럼을 조작하려고 하는 경우
    2) 뷰에 정의되어있지 않은 컬럼 중에 베이스테이블 상에 
       NOT NULL제약조건이 지정되어있는 경우
    3) 산술연산식 또는 함수식으로 정의되어있는 경우
    4) 그룹함수나 GROUP BY절이 포함된 경우 
    5) DISTINCT 구문이 포함된 경우
    6) JOIN을 이용해서 여러 테이블을 연결시켜놓은 경우 
*/
CREATE OR REPLACE VIEW VW_JOB
    AS SELECT JOB_CODE, JOB_NAME
         FROM JOB
WITH READ ONLY;

SELECT * FROM VW_JOB;

UPDATE VW_JOB
   SET JOB_NAME = '정규직'
 WHERE JOB_CODE = 'J9'; -- 오류
 








