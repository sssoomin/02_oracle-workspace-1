/*
    < ALTER >
    데이터베이스 객체(구조)를 변경하는 언어 (DDL)
    
    [표현법]
    ALTER 데이터베이스객체 객체명 변경할내용;
    
    > 테이블 변경일 경우
      ALTER TABLE 테이블명 변경할내용;
      
    [변경할내용]
    1) 컬럼 추가/수정/삭제
    2) 제약조건 추가/삭제
    3) 컬럼명/제약조건명/테이블명 변경
    
*/

/*
    1. 컬럼 추가/수정/삭제
*/

-- 1_1) 컬럼 추가(ADD) : ADD 컬럼명 데이터타입 [DEFAULT 기본값]
-- DEPT_COPY 에 CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
--> 새로운 컬럼이 만들어지고 기본적으로 NULL로 채워짐

-- LNAME 컬럼 추가 (기본값 설정)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';
--> 새로운 컬럼 추가 => DEFAULT으로 채워짐

-- 1_2) 컬럼 수정(MODIFY) 
--      ㄴ 데이터타입수정 : MODIFY 컬럼명 바꾸고자하는데이터타입
--      ㄴ DEFAULT값 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자하는기본값

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER; -- 오류발생
ALTER TABLE DEPT_COPY MODIFY CNAME NUMBER;
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10); -- 오류발생

-- DEPT_TITLE => VARCHAR2(40)
-- LOCATION_ID => VARCHAR2(2)
-- LNAME => DEFAULT '미국'
ALTER TABLE DEPT_COPY 
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';

-- 1_3) 컬럼 삭제 (DROP COLUMN) : DROP COLUMN 삭제할컬럼명
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;

ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;

ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME; -- 오류발생
-- 최소 한개의 컬럼은 존재해야됨

------------------------------------------------------------------

/*
    2. 제약조건 추가/삭제
    
    2_1) 제약조건 추가
    PRIMARY KEY : ADD PRIMARY KEY(컬럼명)
    FOREIGN KEY : ADD FOREIGN KEY(컬럼명) REFERENCES 참조할테이블
    UNIQE       : ADD UNIQUE(컬럼명)
    CHECK       : ADD CHECK(컬럼에 대한 조건식)
    
    NOT NULL    : MODIFY 컬럼명 NULL|NOT NULL
    
    제약조건명을 지정하고자 한다면 [CONSTRAINT 제약조건명] 제약조건
*/
DROP TABLE DEPT_COPY;
CREATE TABLE DEPT_COPY
    AS SELECT * FROM DEPARTMENT;
    
SELECT * FROM DEPT_COPY;

-- DEPT_ID에 PRIMARY KEY 제약조건 추가
-- DEPT_TITLE에 UNIQUE 제약조건 추가 
-- DEPT_TITLE에 NOT NULL 제약조건 추가 
ALTER TABLE DEPT_COPY
    ADD CONSTRAINT DCOPY_PK PRIMARY KEY(DEPT_ID)
    ADD CONSTRAINT DCOPY_UQ UNIQUE(DEPT_TITLE)
    MODIFY DEPT_TITLE CONSTRAINT DCOPY_NN NOT NULL;

-- 이부분 강의 듣기  
-- 2_2) 제약조건 삭제 : DROP CONSTRAINT 제약조건명 / MODIFY 컬럼명 NULL
ALTER TABLE DEPT_COPY DROP CONSTRAINT DCOPY_PK;

ALTER TABLE DEPT_COPY
    DROP CONSTRAINT DCOPY_UQ
    MODIFY DEPT_TITLE NULL;


---------------------------------------------------------------------------------

-- 3. 컬럼명/제약조건명/테이블명 변경 (RENAME)

-- 3_1) 컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀컬럼명
--      DEPT_TITLE => DEPT_NAME
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

-- 3_2) 제약조건명 변경 : RENAME CONSTRAINT 기존제약조건명 TO 바꿀제약조건명
--      SYS_C007139 => DCOPY_LID_NN 
ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C007139 TO DCOPY_LID_NN;

-- 3_3) 테이블명 변경 : RENAME [기존테이블명] TO 바꿀테이블명
--      DEPT_COPY => DEPT_TEST
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;

--------------------------------------------------------------------------------

/*
    < DROP >
    데이터베이스 객체를 삭제시키는 구문 
    
    [표현법]
    DROP 데이터베이스객체 객체명;
    
    > 테이블 삭제시
      DROP TABLE 테이블명 [CASCADE CONSTRAINT];
      
      부모테이블일 경우 함부로 삭제 안됨! 
      방법1. 자식테이블 먼저 삭제한 후 부모테이블 삭제 
      방법2. 부모테이블을 바로 지우고자 할 경우 제약조건까지 같이 삭제
             => CASCADE CONSTRAINT
*/

-- DEPT_TEST 테이블 삭제
DROP TABLE DEPT_TEST;



















