/*
    < SEQUENCE 시퀀스 >
    1. 일련번호를 생성해주는 데이터베이스 객체 
    2. 주로 기본키 컬럼값으로 사용됨  ex) 회원번호, 사원번호, 게시글번호, ....
*/

/*
    1. 시퀀스 생성 
    
    [표현법]
    
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작숫자]        --> 처음 발생시킬 시작값 지정 (기본값 1)
    [INCREMENT BY 증가값]        --> 몇 씩 증가시킬건지 값 지정 (기본값 1)
    [NOMAXVALUE | MAXVALUE 숫자] --> 상한값 지정 (기본값 겁나큼)
    [NOMINVALUE | MINVALUE 숫자] --> 하한값 지정 (기본값 1)
    [NOCYCLE | CYCLE]            --> 값 순환 여부 지정 (기본값 NOCYCLE)
    [NOCACHE | CACHE 사이즈]     --> 캐시메모리 할당 (기본값 CACHE 20)
    
    * 캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간 
                   매번 호출시마다 새로이 숫자를 생성하는게 아니라 캐시상에 생성되어있는 값을 가져와서 사용
                   => 속도가 빨라짐 
                   단, 다 소진하기 전에 프로그램 종료 및 접속이 해제되면 
                   캐시상에 만들어진 값들은 다 소멸됨 
                   => 다음에 번호 발생시 중간에 값이 건너띄워진채로 보여짐
*/

CREATE SEQUENCE SEQ_TEST;

CREATE SEQUENCE SEQ_EMPNO
    START WITH 300
    INCREMENT BY 5
    MAXVALUE 310
    NOCYCLE
    NOCACHE;

-- [참고] USER_SEQUENCES : 현재 계정이 소유하고 있는 시퀀스의 정보를 표현하는 테이블
SELECT * FROM USER_SEQUENCES;

/*
    2. 시퀀스 사용
    
    [표현법]
    시퀀스명.NEXTVAL : INCREMENT BY 만큼 증가된 값을 매번 생성 
    시퀀스명.CURRVAL : 현재 시퀀스의 값 (마지막으로 성공적으로 수행된 NEXTVAL의 값)
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 오류 (NEXTVAL를 최초 한번은 실행한 후 CURRVAL 수행)
                                    -- 왜? : CURRVAL은 마지막으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값 
                                    
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 300

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310

SELECT * FROM USER_SEQUENCES; --> LAST_NUMBER가 315로 되어있긴 함 

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 오류 (지정한 MAXVALUE값을 초과했기 때문에 오류 발생)
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; -- 310

/*
    3. 시퀀스 변경 
    
    [표현법]
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 증가값]        --> 몇 씩 증가시킬건지 값 지정 (기본값 1)
    [NOMAXVALUE | MAXVALUE 숫자] --> 상한값 지정 (기본값 겁나큼)
    [NOMINVALUE | MINVALUE 숫자] --> 하한값 지정 (기본값 1)
    [NOCYCLE | CYCLE]            --> 값 순환 여부 지정 (기본값 NOCYCLE)
    [NOCACHE | CACHE 사이즈]     --> 캐시메모리 할당 (기본값 CACHE 20)
    
    [유의사항]
    START WITH 는 변경불가
*/

ALTER SEQUENCE SEQ_EMPNO
    INCREMENT BY 10
    MAXVALUE 400;
    
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 310+10 => 320




















