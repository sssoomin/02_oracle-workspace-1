/*
    < DDL >
    1. Data Definition Language 
    2. 데이터 정의어
    3. 데이터베이스 객체들을 관리(생성, 수정, 삭제)하는 언어 
    4. 종류 
        1) CREATE        : 생성
        2) ALTER         : 수정
        3) DROP|TRUNCATE : 삭제
    
    [참고]
    > 데이터베이스 객체(구조)
      테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스(INDEX),
      패키지(PACKAGE), 트리거(TRIGGER), 프로시져(PROCEDURE), 
      함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)
      
    > 테이블 : 행(ROW)과 열(COL)로 구성되는 가장 기본적인 데이터베이스 객체
               모든 데이터들은 테이블을 통해서 저장됨! 
*/


/*
    1. 테이블 생성 
    
    [표현법]
    CREATE TABLE 테이블명(
        컬럼명 자료형(SIZE) 제약조건,
        컬럼명 자료형(SIZE) 제약조건,
        컬럼명 자료형,
        ...
    );
    
    [자료형,데이터타입]
    1. 숫자
        ㄴ NUMBER[(p,s)] : p-정밀도, s-스케일
            ㄴ 정밀도 p : 전체 유효 숫자
            ㄴ 스케일 s : 소수부의 유효 숫자 
            ㄴ s 생략할 경우 : 정수 타입
            ㄴ p,s 생략할 경우 : 정수, 실수를 구분하지 않고 보관
    2. 문자
        ㄴ CHAR(SIZE)   
            ㄴ 고정문자 : 글자수의 변동이 적은 문자 (ex: 휴대폰번호, 주민번호 등)
                          CHAR(6) - 'ABC   ', 'ABCD  '
            ㄴ 최대 2000BYTE까지 저장 가능 
        ㄴ VARCHAR2(SIZE) 
            ㄴ 가변문자 : 글자수의 변동이 큰 문자 (ex: 이름, 주소 등)
                          VARCHAR2(6) - 'ABC', 'ABCD'
            ㄴ 최대 4000BYTE까지 저장 가능 
        ㄴ CLOB 
            ㄴ VARCHAR2(4000)으로 처리할 수 없는 큰 문자
    3. 날짜
        ㄴ DATE 
            ㄴ 날짜/시간
            ㄴ 년,월,일,시,분,초
        ㄴ TIMESTAMP
            ㄴ 정밀한 날짜/시간
            ㄴ 년,월,일,시,분,초,마이크로초(백만분의1초)
    
*/
-- 1) 회원데이터를 담기위한 테이블 생성 (MEMBER)
CREATE TABLE MEMBER(
    MEM_NO NUMBER,          -- 회원번호
    MEM_ID VARCHAR2(20),    -- 회원아이디
    MEM_PWD VARCHAR2(20),   -- 회원비번
    MEM_NAME VARCHAR2(20),  -- 회원명
    GENDER CHAR(3),         -- 성별
    PHONE VARCHAR2(13),     -- 전화번호
    EMAIL VARCHAR2(40),     -- 이메일
    MEM_DATE DATE           -- 회원가입일
);

SELECT * FROM MEMBER;

-- * 데이터 딕셔너리 : 데이터베이스 객체들의 정보를 저장하고있는 시스템 테이블
-- [참고] USER_TABLES : 계정이 가지고 있는 테이블의 정보를 표현하고 있는 테이블
SELECT * FROM USER_TABLES;
-- [참고] USER_TAB_COLUMNS : 계정이 가지고 있는 테이블 상의 모든 컬럼 정보를 표현
SELECT * FROM USER_TAB_COLUMNS;

/*
    2. 컬럼에 주석 달기 (컬럼에 대한 설명)
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
    
    > 잘못 실행했다면 수정 후에 다시 재실행 
*/
COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원ID';
COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원PWD';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원명';
COMMENT ON COLUMN MEMBER.GENDER IS '성별';
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

-- 테이블에 데이터 추가시키는 구문 (DML:INSERT)
-- INSERT INTO 테이블명 VALUES(값, 값, 값, ... );
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222', 'aaa@naver.com', SYSDATE);
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '홍길녀', '여', null, NULL, '23/12/25');

INSERT INTO MEMBER VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

/*
    3. 제약조건 (CONSTRAINT)
       원하는 데이터값(유효한 형식의 값)만 유지하기 위해서 특정 컬럼에 설정하는 제약
       즉, 각 컬럼마다 유효한 데이터만 들어올 수 있도록 제한을 둘 수 있음 
       
       종류 : NOT NULL, UNIQUE, CHECK(조건), PRIMARY KEY, FOREIGN KEY
       
       [표현법1. 컬럼레벨방식]
       CREATE TABLE 테이블명(
            컬럼명 데이터타입 [CONSTRAINT 제약조건명] 제약조건,
            컬럼명 데이터타입 [CONSTRAINT 제약조건명] 제약조건,
            ...
       );
       
       [표현법2. 테이블레벨방식]
       CREATE TABLE 테이블명(
            컬럼명 데이터타입,
            컬럼명 데이터타입, 
            ... 
            [CONSTRAINT 제약조건명] 제약조건(컬럼명),
            [CONSTRAINT 제약조건명] 제약조건(컬럼명)
       );
       
       
*/

/*
    3_1) NOT NULL 제약조건 
         해당 컬럼에 반드시 값이 존재해야만 할 경우 부여하는 제약조건 
         즉, 해당 컬럼에 절대 NULL이 들어와서는 안되는 경우 
         삽입 / 수정시 NULL값을 허용하지 않도록 제한
         
         컬럼레벨방식으로만 부여 가능 
*/
DROP TABLE MEMBER; -- 테이블 삭제 구문 

CREATE TABLE MEMBER(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    MEM_DATE DATE NOT NULL
);

SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222', 'aaa@naver.com', SYSDATE);
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '홍길녀', '여', null, NULL, '23/12/25');

INSERT INTO MEMBER VALUES(3, 'user03', 'pass03', NULL, NULL, NULL, NULL, '23/12/30');
--> 의도했던대로 오류남 ( 오류내용 : cannot insert NULL into 계정명.테이블명.컬럼 )

INSERT INTO MEMBER VALUES(3, 'user01', 'pass03', '김말동', NULL, NULL, NULL, '23/12/30'); --> 아이디가 중복되었음에도 불구하고 추가성공

/*
    3_2) UNIQUE 제약조건 
         해당 컬럼에 중복된 값이 들어가서는 안될 경우 
         컬럼값에 중복값을 제한하는 제약조건 
         삽입/수정시 기존에 있는 데이터값 중 중복값이 있을 경우 오류 유발
*/
DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, -- 컬럼레벨방식
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    MEM_DATE DATE NOT NULL
);

CREATE TABLE MEMBER(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMNM_NN NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    MEM_DATE DATE NOT NULL,
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID)  -- 테이블레벨방식
);

INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222', 'aaa@naver.com', SYSDATE);
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '홍길녀', '여', null, NULL, '23/12/25');
INSERT INTO MEMBER VALUES(3, 'user01', 'pass03', '김말동', NULL, NULL, NULL, '23/12/30');
--> 의도했던 대로 오류 ( 오류내용 : unique constraint(계정명.제약조건명) violated )
--  오류 구문 만으로 어떤 컬럼에 uniquey 제약조건 위배인지 파악하기 어려움 (제약조건명으로 알려줌)
--  제약조건 부여시 제약조건명을 지정해주지 않으면 시스템이 임의로 부여함

SELECT * FROM MEMBER;

INSERT INTO MEMBER VALUES(3, 'user03', 'pass03', '김말똥', 'M', null, null, SYSDATE); --> 성별에 유효한 값(남/여)이 아닌게 들어와도 잘 INSERT됨

/*
    3_3) CHECK(조건식) 제약조건 
         해당 컬럼에 들어올 수 있는 값에 대한 조건을 제시해둘 수 있음
         해당 조건에 만족하는 데이터값만 담길 수 있도록 제한
*/

DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남', '여')), -- 컬럼레벨방식
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    MEM_DATE DATE NOT NULL,
    UNIQUE(MEM_ID)  
    -- , CHECK(GENDER IN ('남', '여')) -- 테이블레벨방식
);


INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222', 'aaa@naver.com', SYSDATE);
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '홍길녀', '여', null, NULL, '23/12/25');
INSERT INTO MEMBER VALUES(3, 'user03', 'pass03', '김말똥', 'M', null, null, SYSDATE); 
--> 의도했던 대로 오류 (오류내용 : check constraint (계정명.제약조건명) violated)

INSERT INTO MEMBER VALUES(3, 'user03', 'pass03', '김말똥', null, null, null, SYSDATE); 
--> null 기본적으로 허용됨 (not null제약조건 부여안했기 때문)

/*
    3_4) PRIMARY KEY(기본키) 제약조건
         테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건
         식별자의 역할을 수행 (NULL 허용안됨, 중복 허용안됨)
         
         ex) 회원번호, 사원번호, 부서id, 직급코드, 주문번호, 예약번호, 운송장번호, 학번, 교수번호, ... 
         
         [유의사항]
         한 테이블당 오로지 한개만 설정 가능
*/
DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY, -- 컬럼레벨방식
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남', '여')), 
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    MEM_DATE DATE NOT NULL,
    UNIQUE(MEM_ID)  
    -- , PRIMARY KEY(MEM_NO) -- 테이블레벨방식
);

INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', null, null, null, SYSDATE);
INSERT INTO MEMBER VALUES(1, 'user02', 'pass02', '강개순', null, null, null, sysdate);
--> 기본키 컬럼에 중복값을 넣으려고 할때 (unique 제약조건 위배 오류)
INSERT INTO MEMBER VALUES(NULL, 'user02', 'pass02', '강개순', null, null, null, sysdate);
--> 기본키 컬럼에 NULL을 넣으려고 할때 (not null 제약조건 위배 오류)
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '강개순', null, null, null, sysdate);

-- * 복합키 : 여러컬럼을 묶어서 PRIMARY KEY로 지정
--   복합키 사용예시) 어떤 회원이 어떤 상품을 찜했는지에 대한 데이터를 보관하는 테이블
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(50),
    LIKE_DATE DATE,
    PRIMARY KEY(MEM_NO, PRODUCT_NAME) --> 복합키는 반드시 테이블레벨 방식으로만 가능
);

/*
    1번회원이 A상품 오늘날짜 찜
    1번회원이 B상품 오늘날짜 찜
    2번회원이 A상품 오늘날짜 찜
    1번회원이 A상품 오늘날짜 찜 => 들어오면 안됨
*/
INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES(1, 'B', SYSDATE);
INSERT INTO TB_LIKE VALUES(2, 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES(1, 'A', SYSDATE);

------------------------------------------------------------------------

-- 회원 등급에 대한 데이터를 따로 보관하는 테이블 생성 
CREATE TABLE GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL UNIQUE
);

INSERT INTO GRADE VALUES(10, '일반회원');
INSERT INTO GRADE VALUES(20, '우수회원');
INSERT INTO GRADE VALUES(30, '특별회원');

SELECT * FROM GRADE;

-- 회원 테이블 다시 생성 
DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY, 
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남', '여')), 
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    GRADE_ID NUMBER, -- 회원등급번호(GRADE 테이블에 존재하는 등급코드)를 보관할 컬럼
    MEM_DATE DATE NOT NULL,
    UNIQUE(MEM_ID)  
);

INSERT INTO MEMBER
VALUES(1, 'user01', 'pass01', '홍길순', '여', null, null, null, sysdate);

INSERT INTO MEMBER
VALUES(2, 'user02', 'pass02', '김말똥', null, null, null, 10, sysdate);

INSERT INTO MEMBER
VALUES(3, 'user03', 'pass03', '강개순', '여', null, null, 40, sysdate);
--> 유효한 회원등급번호(GRADE.GRADE_CODE)가 아님에도 불구하고 INSERT 성공

/*
    3_5) FOREIGN KEY(외래키) 제약조건 
         다른 테이블에 존재하는 값만 들어와야되는 특정 컬럼에 부여하는 제약조건
         => 다른 테이블을 참조한다 라고 표현함 
         => 주로 외래키 제약조건의 컬럼을 가지고 테이블간의 JOIN을 진행함
         
         [표현법1. 컬럼레벨방식]
         컬럼명 데이터타입 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명[(참조할컬럼명)]
         
         [표현법2. 테이블레벨방식]
         [CONSTRAINT 제약조건명] FOREIGN KEY(컬럼명) REFERENCES 참조할테이블명[(참조할컬럼명)]
         
         >> 참조할컬럼명 생략시 참조할테이블의 PRIMARY KEY 컬럼으로 자동 잡힘
*/
DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY, 
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남', '여')), 
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    GRADE_ID NUMBER REFERENCES GRADE/*(GRADE_CODE)*/, -- 컬럼레벨방식
    MEM_DATE DATE NOT NULL,
    UNIQUE(MEM_ID)  
    -- , FOREIGN KEY(GRADE_ID) REFERENCES GRADE -- 테이블레벨방식 
);

INSERT INTO MEMBER
VALUES(1, 'user01', 'pass01', '홍길순', '여', null, null, null, sysdate);
--> 외래키 컬럼에 기본적으로 NULL 허용

INSERT INTO MEMBER
VALUES(2, 'user02', 'pass02', '김말똥', null, null, null, 10, sysdate);

INSERT INTO MEMBER
VALUES(3, 'user03', 'pass03', '강개순', '여', null, null, 40, sysdate);
--> 의도했던 대로 오류 (오류 내용 : 데이터 무결성 (계정명.제약조건명) 위배 - parent key not found) 

-- GRADE(부모테이블) -|--------<- MEMBER(자식테이블)
--         1               :             N  

INSERT INTO MEMBER
VALUES(3, 'user03', 'pass03', '강개순', '여', null, null, 20, sysdate);

INSERT INTO MEMBER
VALUES(4, 'user04', 'pass04', '홍길동', null, null, null, 10, sysdate);


-- * 외래키 제약조건을 설정했을 경우 부모데이터 삭제시 문제 발생
--   데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;
--   GRADE 테이블(부모테이블)로부터 10번 등급 삭제
DELETE FROM GRADE WHERE GRADE_CODE = 10;
--> 자식테이블에서 해당 10번등급 값을 사용하고 있기 때문에 삭제 불가능

DELETE FROM GRADE WHERE GRADE_CODE = 30; -- 삭제 성공 

ROLLBACK;

/*
    [참고] 외래키 제약조건 설정시 삭제옵션 지정
    * 삭제옵션 : 부모데이터 삭제시 그 데이터를 사용하고 있는 자식데이터를 어떻게 처리할건지
    
    1) ON DELETE RESTRICTED (기본값) : 삭제제한옵션, 자식데이터로 쓰이는 부모데이터는 삭제 불가능 
    2) ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터 값을 NULL로 변경
    3) ON DELETE CASCADE  : 부모데이터 삭제시 해당 데이터를 쓰고 있는 자식데이터도 같이 삭제 
    
*/
DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER CONSTRAINT MEMNO_PK PRIMARY KEY, 
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK (GENDER IN ('남', '여')), 
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(40),
    GRADE_ID NUMBER REFERENCES GRADE ON DELETE CASCADE,
    MEM_DATE DATE NOT NULL,
    UNIQUE(MEM_ID)  
);

INSERT INTO MEMBER
VALUES(1, 'user01', 'pass01', '홍길순', '여', null, null, null, sysdate);

INSERT INTO MEMBER
VALUES(2, 'user02', 'pass02', '김말똥', null, null, null, 10, sysdate);

INSERT INTO MEMBER
VALUES(3, 'user03', 'pass03', '강개순', '여', null, null, 20, sysdate);

INSERT INTO MEMBER
VALUES(4, 'user04', 'pass04', '홍길동', null, null, null, 10, sysdate);

-- 10번 등급 삭제
DELETE FROM GRADE WHERE GRADE_CODE = 10; 
-- 자식데이터로 사용되고 있어도 부모데이터 삭제됨 
-- => ON DELETE SET NULL일 경우 자식데이터 값은 NULL로 변경
-- => ON DELETE CASCADE 일 경우 자식데이터도 같이 삭제됨

ROLLBACK;

/*
    4. DEFAULT(기본값) 설정하기
       INSERT시 NULL이 아닌 기본값이 INSERT되도록 지정 
       
       [표현법]
       CREATE TABLE 테이블명(
            컬럼명 데이터타입 [CONSTRAINT 제약조건명] 제약조건,
            컬럼명 데이터타입 DEFAULT 기본값 제약조건, 
                ...
            [CONSTRAINT 제약조건명] 제약조건(컬럼명)
       );
*/
DROP TABLE MEMBER;

CREATE TABLE MEMBER(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_NAME VARCHAR2(20) NOT NULL,
    MEM_AGE NUMBER,
    HOBBY VARCHAR2(20) DEFAULT '없음',
    MEM_DATE DATE DEFAULT SYSDATE NOT NULL
);

-- INSERT INTO 테이블명 VALUES(모든 컬럼에 넣고자하는 값들);
INSERT INTO MEMBER VALUES(1, '강길동', 20, '운동', '20/12/03');
INSERT INTO MEMBER VALUES(2, '홍길순', NULL, NULL, SYSDATE);
INSERT INTO MEMBER VALUES(3, '김말똥', DEFAULT, DEFAULT, DEFAULT);
-- MEM_AGE 컬럼에는 DEFAULT값이 없음 => NULL로 기록됨

-- INSERT INTO 테이블명(컬럼명, 컬럼명) VALUES(값, 값);
-- 선택하지 않는 컬럼의 값으로는 NULL | DEFAULT값이 기록됨 
INSERT INTO MEMBER(MEM_NO, MEM_NAME) VALUES(4, '강개순');

COMMIT;











