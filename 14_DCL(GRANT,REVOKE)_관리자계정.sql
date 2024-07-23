/*
    < DCL >
    1. Data Control Language
    2. 데이터 제어어
    3. 특정 계정의 권한을 관리(권한부여,권한회수)하는 구문
    4. 종류
       1) GRANT : 권한부여
       2) REVOKE: 권한회수
    5. 권한종류
       1) 시스템권한
            ㄴ CREATE SESSION : 접속할 수 있는 권한 
            ㄴ CREATE TABLE   : 테이블을 생성할 수 있는 권한
            ㄴ CREATE VIEW    : 뷰를 생성할 수 있는 권한
            ㄴ CREATE SEQUENCE: 시퀀스를 생성할 수 있는 권한
               ...
       2) 객체 권한 : 특정 객체에 접근해서 조작할 수 있는 권한
          권한종류 |    특정객체
          ---------------------------------
           SELECT  | TABLE, VIEW, SEQUENCE
           INSERT  | TABLE, VIEW
           UPDATE  | TABLE, VIEW
           DELETE  | TABLE, VIEW
            ...
    
       
    < GRANT > 
    권한 부여하는 구문
    
    [표현법]
    GRANT 권한종류, 권한종류, 롤, .. TO 계정명;    => 시스템권한
    GRANT 권한종류 ON 특정객체 TO 계정명;          => 객체권한
           
*/

SELECT DISTINCT PRIVILEGE 
  FROM ROLE_SYS_PRIVS;
  
-- 계정생성 (SAMPLE/SAMPLE)
CREATE USER SAMPLE IDENTIFIED BY SAMPLE;
-- 1) 접속을 위해 CREATE SESSION 권한 부여
GRANT CREATE SESSION TO SAMPLE;
-- 2) 테이블을 생성할 수 있는 CREATE TABLE 권한 부여
GRANT CREATE TABLE TO SAMPLE;
--    추가로 TABLESPACE 할당 
ALTER USER SAMPLE QUOTA 2M ON SYSTEM;

-- 3) BR계정의 EMPLOYEE을 조회할수 있는 권한 부여
GRANT SELECT ON BR.EMPLOYEE TO SAMPLE;
-- 4) BR계정의 DEPARTMENT에 데이터를 추가할 수 있는 권한 부여
GRANT INSERT ON BR.DEPARTMENT TO SAMPLE;

/*
    < REVOKE >
    권한 회수하는 구문
    
    [표현법]
    REVOKE 권한 FROM 계정명;
*/
REVOKE SELECT ON BR.EMPLOYEE FROM SAMPLE;



























