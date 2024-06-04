/*유저 ---------------------------------------- */
CREATE TABLE GGHJ_USER
(
    USER_ID       NUMBER,--PK
    USER_NAME     VARCHAR2(20)  NOT NULL,
    USER_PASSWORD VARCHAR2(255) NOT NULL,
    USER_EMAIL    VARCHAR2(255) NOT NULL UNIQUE,
    USER_NICKNAME VARCHAR2(20)  NOT NULL UNIQUE,
    USER_BIRTH    DATE          NOT NULL,
    CONSTRAINT PK_USER PRIMARY KEY (USER_ID)
);
SELECT *FROM GGHJ_BOARD ;
SELECT * FROM GGHJ_USER gu ;
-- 유저 소개글 추가해야됨 
=======


SELECT * FROM GGHJ_USER gu ;

/*카카오 유저 ---------------------------------------- */
CREATE TABLE GGHJ_KAKAO
(
    KAKAO_ID       NUMBER,--PK
    KAKAO_PASSWORD VARCHAR2(255),
    KAKAO_EMAIL    VARCHAR2(255) NOT NULL UNIQUE,
    KAKAO_NICKNAME VARCHAR2(20)  UNIQUE,
    KAKAO_BIRTH    DATE          NOT NULL,
    CONSTRAINT PK_KAKAO_USER PRIMARY KEY (KAKAO_ID)
);

/*통합회원 --------------------------------------------*/
CREATE TABLE GGHJ_UNI(
    UNI_ID NUMBER, 
    UNI_STATUS VARCHAR2(20) DEFAULT '일반' NOT NULL,
    UNI_ABOUT VARCHAR2(255), 
    USER_ID NUMBER, 
    KAKAO_ID NUMBER, 
    CONSTRAINT PK_UNI PRIMARY KEY (UNI_ID),
    CONSTRAINT FK_UNI_USER FOREIGN KEY(USER_ID) REFERENCES GGHJ_USER(USER_ID),
    CONSTRAINT FK_UNI_KAKAO FOREIGN KEY(KAKAO_ID) REFERENCES GGHJ_KAKAO(KAKAO_ID), 
    CONSTRAINT CHECK_UNI_STATUS CHECK (UNI_STATUS IN ('일반', '정지', '탈퇴'))
);

-- 정지회원 댓글, 글 작성 불가 



/*유저 사진 -----------------------------------*/
CREATE TABLE GGHJ_USER_FILE(    
   USER_FILE_ID             NUMBER,--PK
    USER_FILE_PROFILE_NAME   VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_FILE_PROFILE_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_FILE_BACK_NAME      VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_FILE_BACK_SOURCE    VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    USER_FILE_PROFILE_UUID   VARCHAR2(255),
    USER_FILE_BACK_UUID   VARCHAR2(255),
    USER_ID              NUMBER,--FK
    CONSTRAINT PK_USER_FILE PRIMARY KEY (USER_FILE_ID),
    CONSTRAINT FK_FILE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);


/*팔로우 ----------------------------------------*/
CREATE TABLE GGHJ_FOLLOW
(
    FOLLOW_ID        NUMBER,--PK
    FOLLOW_TO_USER   NUMBER NOT NULL,-- FK
    FOLLOW_FROM_USER NUMBER NOT NULL,-- FK
    CONSTRAINT PK_FOLLOW PRIMARY KEY (FOLLOW_ID),
    CONSTRAINT FK_FOLLOW_TO FOREIGN KEY (FOLLOW_TO_USER) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT FK_FOLLOW_FROM FOREIGN KEY (FOLLOW_FROM_USER) REFERENCES GGHJ_UNI (UNI_ID)
);


/*일대기(게시판) -----------------------------------*/
CREATE TABLE GGHJ_BOARD
(
    BOARD_ID           NUMBER,--PK
    BOARD_TITLE        VARCHAR2(50)           NOT NULL,
    BOARD_CONTENT      VARCHAR2(2000)         NOT NULL,
    BOARD_PUBLIC       VARCHAR2(20)  DEFAULT 'O',--DEFAULT, CHECK
    BOARD_CREATED_DATE DATE   DEFAULT SYSDATE,
    BOARD_UPDATED_DATE DATE   DEFAULT SYSDATE,
    BOARD_VIEW_COUNT   NUMBER DEFAULT 0, --default
    BOARD_LIFE_CYCLE   VARCHAR2(20) DEFAULT '청소년기',--DEFAULT 청소년기, CHECK
    BOARD_LIKE_COUNT   NUMBER DEFAULT 0,
    BOARD_YEAR         VARCHAR2(4)  NOT NULL, -- 연도를 나타내므로 VARCHAR2로 변경
    USER_ID            NUMBER,-- FK
    CONSTRAINT PK_BOARD PRIMARY KEY (BOARD_ID),
    CONSTRAINT FK_BOARD_UNI FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT CHECK_LIFE_CYCLE CHECK (BOARD_LIFE_CYCLE IN('유아기','유년기','아동기','청소년기','청년기','중년기','노년기')),
    CONSTRAINT CHECK_BOARD_PUBLIC CHECK(BOARD_PUBLIC IN('O', 'X'))
);

drop TABLE GGHJ_BOARD;
/*일대기 파일 ------------------------------------------------------------*/
CREATE TABLE GGHJ_BOARD_FILE(
    BOARD_FILE_ID          NUMBER,--PK
    BOARD_FILE_NAME        VARCHAR2(255) DEFAULT '' ,-- DEFAULT : 사진 경로
    BOARD_FILE_SOURCE_NAME VARCHAR2(255) DEFAULT '',-- DEFAULT : 사진 경로
    BOARD_FILE_UUID VARCHAR2(255) DEFAULT '',
    BOARD_ID           NUMBER,--FK
    CONSTRAINT PK_BOARD_FILE PRIMARY KEY (BOARD_FILE_ID),
    CONSTRAINT FK_BOARD_ID FOREIGN KEY (BOARD_ID) REFERENCES GGHJ_BOARD (BOARD_ID)
);
drop TABLE GGHJ_BOARD_FILE;
   
/*좋아요 -------------------------------------------------------------------*/
CREATE TABLE GGHJ_LIKE(
    LIKE_ID  NUMBER,--PK
    BOARD_ID NUMBER,--FK
    USER_ID  NUMBER,--FK
    LIKE_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_LIKE_ID PRIMARY KEY (LIKE_ID),
    CONSTRAINT FK_LIKE_BOARD FOREIGN KEY (BOARD_ID) REFERENCES GGHJ_BOARD (BOARD_ID),
    CONSTRAINT FK_LIKE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI(UNI_ID)
);

drop table
    GGHJ_Like;


/*댓글 ----------------------------------------------------------------------*/
CREATE TABLE GGHJ_COMMENT(
    COMMENT_ID           NUMBER,--PK
    COMMENT_CONTENT      VARCHAR2(255)        NOT NULL,
    COMMENT_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    BOARD_ID             NUMBER,--FK
    USER_ID              NUMBER,--FK
    CONSTRAINT PK_COMMENT PRIMARY KEY (COMMENT_ID),
    CONSTRAINT FK_COMMENTBOARD FOREIGN KEY (BOARD_ID) REFERENCES GGHJ_BOARD (BOARD_ID),
    CONSTRAINT FK_COMMENTUSER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);
drop table
    GGHJ_COMMENT;

/*대댓글 ------------------------------------------------------------------------*/
CREATE TABLE GGHJ_REPLY(
    REPLY_ID           NUMBER,--PK
    REPLY_CONTENT      VARCHAR2(255)        NOT NULL,
    REPLY_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    COMMENT_ID         NUMBER,--FK
    CONSTRAINT PK_REPLY PRIMARY KEY (REPLY_ID),
    CONSTRAINT FK_REPLY_COMMENT FOREIGN KEY (COMMENT_ID) REFERENCES GGHJ_COMMENT (COMMENT_ID)
);
drop table
    GGHJ_REPLY;

/*신고 ----------------------------------------------------------*/
CREATE TABLE GGHJ_REPORT(
    REPORT_ID           NUMBER,--PK
    REPORT_REASON       VARCHAR2(50)         NOT NULL,
    REPORT_CREATED_DATE DATE DEFAULT SYSDATE NOT NULL,
    REPORT_COUNT       NUMBER DEFAULT 0 NOT NULL,
    USER_ID             NUMBER,-- FK
    REPLY_ID            NUMBER,-- FK
    COMMENT_ID          NUMBER,-- FK
    CONSTRAINT PK_REPORT PRIMARY KEY (REPORT_ID),
    CONSTRAINT FK_REPORT_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER (USER_ID),
    CONSTRAINT FK_REPORT_REPLY FOREIGN KEY (REPLY_ID) REFERENCES GGHJ_REPLY (REPLY_ID),
    CONSTRAINT FK_REPORT_COMMENT FOREIGN KEY (COMMENT_ID) REFERENCES GGHJ_COMMENT (COMMENT_ID),
    CONSTRAINT UK_REPORT_USER_COMMENT UNIQUE (USER_ID, COMMENT_ID)
);

ALTER TABLE GGHJ_REPORT ADD CONSTRAINT UK_REPORT_USER_COMMENT UNIQUE (USER_ID, COMMENT_ID);

   /*문의 ------------------------------------------------------*/
CREATE TABLE GGHJ_INQUIRY(
    INQUIRY_ID            NUMBER,--PK
    INQUIRY_TITLE         VARCHAR2(255)            NOT NULL,
    INQUIRY_CONTENT VARCHAR2(2000) NOT NULL,
    INQUIRY_RESPONSE VARCHAR2(2000),
    INQUIRY_CREATED_DATE DATE           DEFAULT SYSDATE NOT NULL,
    INQUIRY_PUBLIC        VARCHAR2(20)  DEFAULT 'O' NOT NULL,-- DEFAULT
    USER_ID               NUMBER,--FK
    CONSTRAINT PK_INQUIRY PRIMARY KEY (INQUIRY_ID),
    CONSTRAINT FK_INQUIRY_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT CHECK_INQUIRY_PUBLIC CHECK(INQUIRY_PUBLIC IN('O', 'X'))
);

/*공지 ------------------------------------------------------------*/
CREATE TABLE GGHJ_NOTICE(
    NOTICE_ID            NUMBER,--PK
    NOTICE_TITLE         VARCHAR2(255)            NOT NULL,
    NOTICE_CONTENT VARCHAR2(2000) NOT NULL,
    NOTICE_CREATED_DATE DATE           DEFAULT SYSDATE NOT NULL,
    USER_ID              NUMBER, -- 관리자때문에 있는듯
    CONSTRAINT PK_NOTICE PRIMARY KEY (NOTICE_ID),
    CONSTRAINT FK_NOTICE_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);

/*배너 ------------------------------*/
CREATE TABLE GGHJ_BANNER(
    BANNER_ID     NUMBER,--PK
    BANNER_NAME   VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    BANNER_SOURCE VARCHAR2(255) DEFAULT '' NOT NULL,-- default : 사진 경로
    BANNER_UUID VARCHAR2(255),
    USER_ID       NUMBER,--FK
    CONSTRAINT PK_BANNER PRIMARY KEY (BANNER_ID),
    CONSTRAINT FK_BANNER_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_UNI (UNI_ID)
);

DROP TABLE GGHJ_MAIN_BANNER CASCADE CONSTRAINTS;

--CREATE TABLE GGHJ_AUTHORITY (
--   AUTHORITY_ID NUMBER PRIMARY KEY,
--   AUTHORITY_NICKNAME VARCHAR(20) NOT NULL UNIQUE
--);

--CREATE TABLE GGHJ_authorization (
--   AUTHENTIC_ID NUMBER PRIMARY KEY,
--   USER_ID NUMBER,
--   AUTHORITY_ID NUMBER,
--   CONSTRAINT FK_AUTHENTIC_USER FOREIGN KEY (USER_ID) REFERENCES GGHJ_USER(USER_ID),
--   CONSTRAINT FK_AUTHORITY_ID FOREIGN KEY (AUTHORITY_ID) REFERENCES GGHJ_AUTHORITY(AUTHORITY_ID)
--);

--권한있는 사람 테이블 삭제
-- DROP TABLE GGHJ_AUTHORITY CASCADE CONSTRAINTS;

--권한 부여테이블 삭제
-- DROP TABLE GGHJ_authorization CASCADE CONSTRAINTS;

/*CREATE TABLE GGHJ_ALARM(
   ALARM_ID NUMBER, --PK
   USER_ID NUMBER, --FK
   REPORT_ID NUMBER, --FK
);*/


-- 배너 테이블 삭제
DROP TABLE GGHJ_BANNER CASCADE CONSTRAINTS;
-- 공지 테이블 삭제
DROP TABLE GGHJ_NOTICE CASCADE CONSTRAINTS;
-- 문의 테이블 삭제
DROP TABLE GGHJ_INQUIRY CASCADE CONSTRAINTS;
-- 신고 테이블 삭제
DROP TABLE GGHJ_REPORT CASCADE CONSTRAINTS;
-- 대댓글 테이블 삭제
DROP TABLE GGHJ_REPLY CASCADE CONSTRAINTS;
-- 댓글 테이블 삭제
DROP TABLE GGHJ_COMMENT CASCADE CONSTRAINTS;
-- 좋아요 테이블 삭제
DROP TABLE GGHJ_LIKE CASCADE CONSTRAINTS;
-- 게시판 파일 테이블 삭제
DROP TABLE GGHJ_BOARD_FILE CASCADE CONSTRAINTS;
-- 게시판 테이블 삭제
DROP TABLE GGHJ_BOARD CASCADE CONSTRAINTS;
-- 팔로우 테이블 삭제
DROP TABLE GGHJ_FOLLOW CASCADE CONSTRAINTS;
-- 유저 사진 테이블 삭제
DROP TABLE GGHJ_USER_FILE CASCADE CONSTRAINTS;
-- 유니(통합) 테이블 삭제
DROP TABLE GGHJ_UNI CASCADE CONSTRAINTS;
-- 유저 테이블 삭제
DROP TABLE GGHJ_USER CASCADE CONSTRAINTS;
-- 카카오 테이블 삭제
DROP TABLE GGHJ_KAKAO CASCADE CONSTRAINTS;

--CREATE SEQUENCE SEQ_AUTHENTIC;
--
--CREATE SEQUENCE SEQ_AUTHORITY;

CREATE SEQUENCE SEQ_USER;

CREATE SEQUENCE SEQ_KAKAO;

CREATE SEQUENCE SEQ_UNI;

CREATE SEQUENCE SEQ_USER_FILE;

CREATE SEQUENCE SEQ_FOLLOW;

CREATE SEQUENCE SEQ_BOARD;

CREATE SEQUENCE SEQ_BOARD_FILE;

CREATE SEQUENCE SEQ_COMMENT;

CREATE SEQUENCE SEQ_REPLY;

CREATE SEQUENCE SEQ_REPORT;

CREATE SEQUENCE SEQ_NOTICE;

CREATE SEQUENCE SEQ_INQUIRY;

CREATE SEQUENCE SEQ_LIKE;

CREATE SEQUENCE SEQ_BANNER;



-- 시퀀스 삭제 --

DROP SEQUENCE SEQ_AUTHORITY;
DROP SEQUENCE SEQ_USER;
DROP SEQUENCE SEQ_KAKAO;
DROP SEQUENCE SEQ_UNI;
DROP SEQUENCE SEQ_FILE;
DROP SEQUENCE SEQ_FOLLOW;
DROP SEQUENCE SEQ_BOARD;
DROP SEQUENCE SEQ_BOARD_FILE;
DROP SEQUENCE SEQ_COMMENT;
DROP SEQUENCE SEQ_REPLY;
DROP SEQUENCE SEQ_REPORT;
DROP SEQUENCE SEQ_NOTICE;
DROP SEQUENCE SEQ_INQUIRY;
DROP SEQUENCE SEQ_LIKE;
DROP SEQUENCE SEQ_BANNER;




-- 조회수 게시판(정렬) --
   
SELECT -- 네모칸 안에 뜨는것만 -- 
    u.USER_NICKNAME, b.BOARD_TITLE , b.BOARD_TITLE  
FROM 
    GGHJ_BOARD b JOIN GGHJ_USER u
    ON u.user_id = b.USER_ID 
ORDER BY 
   BOARD_VIEW_COUNT DESC;

-- 최신 게시판(정렬) --
   
SELECT -- 네모칸 안에 뜨는것만 -- 
    u.USER_NICKNAME, b.BOARD_TITLE , b.BOARD_TITLE  
FROM 
    GGHJ_BOARD b JOIN GGHJ_USER u
    ON u.user_id = b.USER_ID 
ORDER BY 
   b.BOARD_CREATED_DATE DESC;

-- 인기 게시판(정렬) --

SELECT 
    u.USER_NICKNAME, b.BOARD_TITLE, b.BOARD_TITLE 
FROM 
    GGHJ_BOARD b JOIN GGHJ_USER u
    ON u.user_id = b.USER_ID 
ORDER BY 
    b.BOARD_LIKE_COUNT DESC;
   
<<<<<<< HEAD
   
SELECT *
FROM 
    GGHJ_BOARD b JOIN GGHJ_USER u
    ON u.user_id = b.USER_ID 
ORDER BY 
    b.BOARD_LIKE_COUNT DESC;
   
   
   
=======
>>>>>>> main
   CREATE TABLE GGHJ_FOLLOW
(
    FOLLOW_ID        NUMBER PRIMARY KEY,
    FOLLOW_TO_USER   NUMBER NOT NULL,
    FOLLOW_FROM_USER NUMBER NOT NULL,
    CONSTRAINT FK_FOLLOW_TO FOREIGN KEY (FOLLOW_TO_USER) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT FK_FOLLOW_FROM FOREIGN KEY (FOLLOW_FROM_USER) REFERENCES GGHJ_UNI (UNI_ID),
    CONSTRAINT UNIQUE_FOLLOW_USERS UNIQUE (FOLLOW_TO_USER, FOLLOW_FROM_USER)
);

CREATE TABLE GGHJ_KAKAO
(
    KAKAO_ID          NUMBER,--PK
    NAME          VARCHAR2(255) NOT NULL,
    PROFILE_PIC       VARCHAR2(255),
    PROVIDER       VARCHAR2(20),
    PROVIDER_ID     VARCHAR2(20) UNIQUE NOT NULL,
    CREATE_AT       DATE,
    UPDATE_AT       DATE,
    CONSTRAINT PK_KAKAO_USER PRIMARY KEY (KAKAO_ID)
);
   
-- follow 더미
INSERT INTO GGHJ_FOLLOW (
    FOLLOW_ID,
    FOLLOW_TO_USER,
    FOLLOW_FROM_USER
) VALUES (
    1,
    2,
    1
);

INSERT INTO GGHJ_FOLLOW (
    FOLLOW_ID,
    FOLLOW_TO_USER,
    FOLLOW_FROM_USER
) VALUES (
    2,
    3,
    1
);

INSERT INTO GGHJ_FOLLOW (
    FOLLOW_ID,
    FOLLOW_TO_USER,
    FOLLOW_FROM_USER
) VALUES (
    3,
    4,
    2
);

INSERT INTO GGHJ_FOLLOW (
    FOLLOW_ID,
    FOLLOW_TO_USER,
    FOLLOW_FROM_USER
) VALUES (
    4,
    5,
    3
);

INSERT INTO GGHJ_FOLLOW (
    FOLLOW_ID,
    FOLLOW_TO_USER,
    FOLLOW_FROM_USER
) VALUES (
    5,
    1,
    4
);

 SELECT *
 FROM GGHJ_BOARD G
    JOIN GGHJ_UNI U
       ON G.USER_ID = U.UNI_ID
 WHERE G.BOARD_ID = #{userId};

   
<<<<<<< HEAD


SELECT * FROM gghj_kakao;
=======
   








>>>>>>> main







<<<<<<< HEAD
            SELECT BOARD_TITLE, BOARD_CREATED_DATE, BOARD_VIEW_COUNT, BOARD_CONTENT,
                   COALESCE(U.USER_NICKNAME, K.NAME) AS NICKNAME,
                   F.USER_FILE_PROFILE_NAME,
                   F.USER_FILE_PROFILE_SOURCE,
                   F.USER_FILE_PROFILE_UUID,
                   B.BOARD_ID,
                   B.USER_ID
            FROM GGHJ_BOARD B
            JOIN GGHJ_UNI UNI ON B.USER_ID = UNI.UNI_ID
            LEFT JOIN GGHJ_USER U ON UNI.USER_ID = U.USER_ID
            LEFT JOIN GGHJ_KAKAO K ON UNI.KAKAO_ID = K.KAKAO_ID
            LEFT JOIN GGHJ_USER_FILE F ON U.USER_ID = F.USER_ID;

           
           SELECT COUNT(*)FROM GGHJ_BOARD; 
=======
>>>>>>> main


