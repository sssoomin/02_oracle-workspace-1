/*
    < TCL >
    1. Transaction Control Language
    2. 트랜잭션 제어어
    3. 트랜잭션이란?
        ㄴ 데이터베이스의 논리적 연산단위(업무단위)
        ㄴ 데이터의 변경사항을 바로 실제 DB에 반영하지 않고 하나의 트랜잭션으로 묶여서 관리됨 
    4. 종류
       1) COMMIT    : 트랜잭션에 포함되어있는 변경사항을 실제 DB에 반영시키고 트랜잭션 소멸
       2) ROLLBACK  : 트랜잭션에 포함되어있는 변경사항을 삭제(취소) 한 후 트랜잭션 소멸
       3) SAVEPOINT : 현재 시점에 특정 포인트명으로 임시저장점을 정의해둠
                      => ROLLBACK시 전체 취소가 아니라 일부만 ROLLBACK 시킬 수 있음 
    5. 트랜잭션 처리 대상이 되는 SQL문 : DML (INSERT, UPDATE, DELETE)
    6. 유의사항
       DDL 문과 같은 정의어를 실행하게 되면 COMMIT이 자동으로 진행됨 
       즉, 변경사항이 발생된 후 COMMIT/ROLLBACK을 처리하지 않고 DDL문 실행시 자동 COMMIT됨
       변경사항을 더이상 취소(ROLLBACK) 시킬수 없음
*/


SELECT * FROM EMP_NEW;

-- 사번이 900인 사원 지우기
DELETE 
  FROM EMP_NEW
 WHERE EMP_ID = 900;

-- 사번이 901인 사원 지우기
DELETE 
  FROM EMP_NEW
 WHERE EMP_ID = 901;

ROLLBACK;

-------------------------------------------------------------------------------
SELECT * FROM EMP_NEW;

-- 201번 사원 지우기
DELETE 
  FROM EMP_NEW
 WHERE EMP_ID = 201;
 
-- 800, 홍길동, '22/12/11', 4000000 추가
INSERT INTO EMP_NEW VALUES(800, '홍길동', '22/12/11', 4000000);

COMMIT;
ROLLBACK;

------------------------------------------------------------------------------

SELECT * FROM EMP_NEW;

-- 202,204,206 사원 지우기
DELETE 
  FROM EMP_NEW
 WHERE EMP_ID IN (202, 204, 206);

SAVEPOINT SP;

-- 801, 김말똥, '23/05/12', 3000000 사원 추가
INSERT INTO EMP_NEW VALUES(801, '김말똥', '23/05/12', 3000000);

-- 211 사원 지우기
DELETE
  FROM EMP_NEW
 WHERE EMP_ID = 211;

ROLLBACK TO SP;

COMMIT;

------------------------------------------------------------------------------

SELECT * FROM EMP_NEW;

-- 900, 901 사원 지우기
DELETE
  FROM EMP_NEW
 WHERE EMP_ID IN (900, 901);

-- 208번 사원의 급여를 100만원으로 수정
UPDATE EMP_NEW
   SET SALARY = 1000000
 WHERE EMP_ID = 208;

-- DDL문
CREATE TABLE TEST(
    TID NUMBER
);

ROLLBACK;

------------------------------------------------------------------
-- 웹 개발시 기능(요청) 단위로 트랜잭션으로 묶어 관리

/*
    EX) 게시글 작성 기능 
    
    INSERT INTO 게시글 VALUES(사용자가입력한 게시글제목, 내용, ...)
    INSERT INTO 첨부파일 VALUES(게시글의 첨부파일 원본명, 수정명, 저장경로, ..)
    
    게시글 INSERT성공 + 첨부파일 INSERT실패 => 작성 기능 실패! => ROLLBACK => 게시글에 들어간 데이터 취소
    게시글 INSERT성공 + 첨부파일 INSERT성공 => 작성 기능 성공! => COMMIT => 실제 DB에 반영
*/











