--
-- WDX_USER_OPTIONS  (Table) 
--
--  Dependencies: 
--   WDX_USERS (Table)
--   WDX_APPLICATIONS (Table)
--
CREATE TABLE WDX_USER_OPTIONS
(
  USERNAME       VARCHAR2(50 BYTE)              NOT NULL,
  APPID          VARCHAR2(50 BYTE)              NOT NULL,
  KEY            VARCHAR2(30 BYTE)              NOT NULL,
  VALUE          VARCHAR2(4000 BYTE)            NOT NULL,
  DESCRIPTION    VARCHAR2(2000 BYTE)                NULL,
  CREATED_BY     VARCHAR2(100 BYTE)             DEFAULT -1                    NOT NULL,
  CREATED_DATE   DATE                           DEFAULT SYSDATE               NOT NULL,
  MODIFIED_BY    VARCHAR2(100 BYTE)             DEFAULT -1                    NOT NULL,
  MODIFIED_DATE  DATE                           DEFAULT SYSDATE               NOT NULL
);


--
-- WDX_USER_OPTIONS_PK  (Index) 
--
--  Dependencies: 
--   WDX_USER_OPTIONS (Table)
--
CREATE UNIQUE INDEX WDX_USER_OPTIONS_PK ON WDX_USER_OPTIONS
(APPID, USERNAME, KEY);


-- 
-- Non Foreign Key Constraints for Table WDX_USER_OPTIONS 
-- 
ALTER TABLE WDX_USER_OPTIONS ADD (
  CONSTRAINT WDX_USER_OPTIONS_PK
 PRIMARY KEY
 (APPID, USERNAME, KEY));


-- 
-- Foreign Key Constraints for Table WDX_USER_OPTIONS 
-- 
ALTER TABLE WDX_USER_OPTIONS ADD (
  CONSTRAINT WDX_USER_OPTIONS_APPID_FK 
 FOREIGN KEY (APPID) 
 REFERENCES WDX_APPLICATIONS (APPID));

ALTER TABLE WDX_USER_OPTIONS ADD (
  CONSTRAINT WDX_USER_OPTIONS_USERNAME_FK 
 FOREIGN KEY (USERNAME) 
 REFERENCES WDX_USERS (USERNAME));


