-- singleline comment (한줄 주석)
/*
    multiline
    comment
    (여러줄 주석)
    
    도구 > 환경설정 > 환경(Environment) > 인코딩 : UTF-8
*/

/*
    < SYS 계정 | SYSTEM 계정 >
    1. 오라클 관리자 계정
    2. 총괄적으로 데이터베이스들 또는 계정들을 관리할 수 있는 권한을 가지고 있음
    3. 관리자 계정을 통해서 "일반 사용자 계정을 생성"할 수 있음 (그 외에 구문들은 실행하지 말것)
    
    < 사용자 계정 생성 및 권한 부여 방법 >
    1. 사용자 계정 생성 방법
       CREATE USER 계정명 IDENTIFIED BY 비밀번호;
    2. 생성된 사용자에게 권한 부여하는 방법
       GRANT 권한, 권한, .. TO 계정명;
       
       * 최소한의 권한 : CONNECT(접속), RESOURCE(자원사용)
    
    < 사용자 계정 삭제 방법 >
    1. 해당 계정이 데이터베이스 객체를 가지고 있는 경우 
       DROP USER 계정명 CASCADE;
    2. 해당 계정이 데이터베이스 객체를 가지고 있지 않을 경우
       DROP USER 계정명;
*/

SELECT * FROM DBA_USERS; -- 현재 존재하는 계정들을 조회하는 명령문(쿼리문)
-- 명령문 하나 실행 (커서를 위치해둔 상태에서 CTRL+ENTER)

-- * 수업용 계정 생성 (BR / BR)
CREATE USER BR IDENTIFIED BY BR;

-- * 최소한의 권한(CONNECT, RESOURCE) 부여 
GRANT CONNECT, RESOURCE TO BR;
















