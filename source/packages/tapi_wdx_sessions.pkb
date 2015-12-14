--
-- TAPI_WDX_SESSIONS  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY      tapi_wdx_sessions IS

   /**
   -- # TAPI_wdx_sessions
   -- Generated by: tapiGen2 - DO NOT MODIFY!
   -- Website: github.com/osalvador/tapiGen2
   -- Created On: 24-NOV-2015 17:26
   -- Created By: DBAX
   */


   --GLOBAL_PRIVATE_CURSORS
   --By PK
   CURSOR wdx_sessions_cur (
                       p_appid IN wdx_sessions.appid%TYPE,
                       p_session_id IN wdx_sessions.session_id%TYPE
                       )
   IS
      SELECT
            appid,
            session_id,
            username,
            expired,
            last_access,
            cgi_env,
            session_variable,
            created_by,
            created_date,
            modified_by,
            modified_date,
            tapi_wdx_sessions.hash(appid,session_id),
            ROWID
      FROM wdx_sessions
      WHERE
           appid = wdx_sessions_cur.p_appid AND 
           session_id = wdx_sessions_cur.p_session_id
      FOR UPDATE;

    --By Rowid
    CURSOR wdx_sessions_rowid_cur (p_rowid IN VARCHAR2)
    IS
      SELECT
             appid,
             session_id,
             username,
             expired,
             last_access,
             cgi_env,
             session_variable,
             created_by,
             created_date,
             modified_by,
             modified_date,
             tapi_wdx_sessions.hash(appid,session_id),
             ROWID
      FROM wdx_sessions
      WHERE ROWID = p_rowid
      FOR UPDATE;


    FUNCTION hash (
                  p_appid IN wdx_sessions.appid%TYPE,
                  p_session_id IN wdx_sessions.session_id%TYPE
                  )
      RETURN varchar2
   IS
      l_retval hash_t;
      l_string CLOB;
      l_date_format VARCHAR2(64);
   BEGIN


     --Get actual NLS_DATE_FORMAT
     SELECT   VALUE
       INTO   l_date_format
       FROM   v$nls_parameters
      WHERE   parameter = 'NLS_DATE_FORMAT';

      --Alter session for date columns
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''YYYY/MM/DD hh24:mi:ss''';

      SELECT
            appid||
            session_id||
            username||
            expired||
            last_access||
            cgi_env||
            session_variable||
            created_by||
            created_date||
            modified_by||
            modified_date
      INTO l_string
      FROM wdx_sessions
      WHERE
           appid = hash.p_appid AND 
           session_id = hash.p_session_id
           ;

      --Restore NLS_DATE_FORMAT to default
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''' || l_date_format|| '''';

      l_retval := DBMS_CRYPTO.hash(l_string, DBMS_CRYPTO.hash_sh1);

      RETURN l_retval;

   END hash;

    FUNCTION hash_rowid (p_rowid IN varchar2)
      RETURN varchar2
   IS
      l_retval hash_t;
      l_string CLOB;
      l_date_format varchar2(64);
   BEGIN

      --Get actual NLS_DATE_FORMAT
      SELECT VALUE INTO l_date_format  FROM v$nls_parameters WHERE parameter ='NLS_DATE_FORMAT';

      --Alter session for date columns
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''YYYY/MM/DD hh24:mi:ss''';

      SELECT
            appid||
            session_id||
            username||
            expired||
            last_access||
            cgi_env||
            session_variable||
            created_by||
            created_date||
            modified_by||
            modified_date
      INTO l_string
      FROM wdx_sessions
      WHERE  ROWID = hash_rowid.p_rowid;

      --Restore NLS_DATE_FORMAT to default
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''' || l_date_format|| '''';

      l_retval := DBMS_CRYPTO.hash(l_string, DBMS_CRYPTO.hash_sh1);

      RETURN l_retval;

   END hash_rowid;

   FUNCTION rt (
               p_appid IN wdx_sessions.appid%TYPE,
               p_session_id IN wdx_sessions.session_id%TYPE
               )
      RETURN wdx_sessions_rt RESULT_CACHE
   IS
      l_wdx_sessions_rec wdx_sessions_rt;
   BEGIN

      SELECT a.*,
             tapi_wdx_sessions.hash(appid,session_id),
             rowid
      INTO l_wdx_sessions_rec
      FROM wdx_sessions a
      WHERE
           appid = rt.p_appid AND 
           session_id = rt.p_session_id
           ;


      RETURN l_wdx_sessions_rec;

   END rt;

   FUNCTION rt_for_update (
                          p_appid IN wdx_sessions.appid%TYPE,
                          p_session_id IN wdx_sessions.session_id%TYPE
                          )
      RETURN wdx_sessions_rt RESULT_CACHE
   IS
      l_wdx_sessions_rec wdx_sessions_rt;
   BEGIN


      SELECT a.*,
             tapi_wdx_sessions.hash(appid,session_id),
             rowid
      INTO l_wdx_sessions_rec
      FROM wdx_sessions a
      WHERE
           appid = rt_for_update.p_appid AND 
           session_id = rt_for_update.p_session_id
      FOR UPDATE;


      RETURN l_wdx_sessions_rec;

   END rt_for_update;

    FUNCTION tt (
                p_appid IN wdx_sessions.appid%TYPE DEFAULT NULL,
                p_session_id IN wdx_sessions.session_id%TYPE DEFAULT NULL
                )
       RETURN wdx_sessions_tt
       PIPELINED
    IS
       l_wdx_sessions_rec   wdx_sessions_rt;
    BEGIN

       FOR c1 IN (SELECT   a.*, ROWID
                    FROM   wdx_sessions a
                   WHERE
                        appid = NVL(tt.p_appid,appid) AND 
                        session_id = NVL(tt.p_session_id,session_id)
                        )
       LOOP
              l_wdx_sessions_rec.appid := c1.appid;
              l_wdx_sessions_rec.session_id := c1.session_id;
              l_wdx_sessions_rec.username := c1.username;
              l_wdx_sessions_rec.expired := c1.expired;
              l_wdx_sessions_rec.last_access := c1.last_access;
              l_wdx_sessions_rec.cgi_env := c1.cgi_env;
              l_wdx_sessions_rec.session_variable := c1.session_variable;
              l_wdx_sessions_rec.created_by := c1.created_by;
              l_wdx_sessions_rec.created_date := c1.created_date;
              l_wdx_sessions_rec.modified_by := c1.modified_by;
              l_wdx_sessions_rec.modified_date := c1.modified_date;
              l_wdx_sessions_rec.hash := tapi_wdx_sessions.hash( c1.appid, c1.session_id);
              l_wdx_sessions_rec.row_id := c1.ROWID;
              PIPE ROW (l_wdx_sessions_rec);
       END LOOP;

       RETURN;

    END tt;


    PROCEDURE ins (p_wdx_sessions_rec IN OUT wdx_sessions_rt)
    IS
        l_rowtype     wdx_sessions%ROWTYPE;
        l_user_name   wdx_sessions.created_by%TYPE := USER;/*dbax_core.g$username or apex_application.g_user*/
        l_date        wdx_sessions.created_date%TYPE := SYSDATE;

    BEGIN

        p_wdx_sessions_rec.created_by := l_user_name;
        p_wdx_sessions_rec.created_date := l_date;
        p_wdx_sessions_rec.modified_by := l_user_name;
        p_wdx_sessions_rec.modified_date := l_date;

        l_rowtype.appid := ins.p_wdx_sessions_rec.appid;
        l_rowtype.session_id := ins.p_wdx_sessions_rec.session_id;
        l_rowtype.username := ins.p_wdx_sessions_rec.username;
        l_rowtype.expired := ins.p_wdx_sessions_rec.expired;
        l_rowtype.last_access := ins.p_wdx_sessions_rec.last_access;
        l_rowtype.cgi_env := ins.p_wdx_sessions_rec.cgi_env;
        l_rowtype.session_variable := ins.p_wdx_sessions_rec.session_variable;
        l_rowtype.created_by := ins.p_wdx_sessions_rec.created_by;
        l_rowtype.created_date := ins.p_wdx_sessions_rec.created_date;
        l_rowtype.modified_by := ins.p_wdx_sessions_rec.modified_by;
        l_rowtype.modified_date := ins.p_wdx_sessions_rec.modified_date;

       INSERT INTO wdx_sessions
         VALUES   l_rowtype;


    END ins;

    PROCEDURE upd (
                  p_wdx_sessions_rec         IN wdx_sessions_rt,
                  p_ignore_nulls         IN boolean := FALSE
                  )
    IS
    BEGIN

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   wdx_sessions
             SET appid = NVL(p_wdx_sessions_rec.appid,appid),
                session_id = NVL(p_wdx_sessions_rec.session_id,session_id),
                username = NVL(p_wdx_sessions_rec.username,username),
                expired = NVL(p_wdx_sessions_rec.expired,expired),
                last_access = NVL(p_wdx_sessions_rec.last_access,last_access),
                cgi_env = NVL(p_wdx_sessions_rec.cgi_env,cgi_env),
                session_variable = NVL(p_wdx_sessions_rec.session_variable,session_variable),
                modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                modified_date = SYSDATE
           WHERE
                appid = upd.p_wdx_sessions_rec.appid AND 
                session_id = upd.p_wdx_sessions_rec.session_id
                ;
       ELSE
          UPDATE   wdx_sessions
             SET appid = p_wdx_sessions_rec.appid,
                session_id = p_wdx_sessions_rec.session_id,
                username = p_wdx_sessions_rec.username,
                expired = p_wdx_sessions_rec.expired,
                last_access = p_wdx_sessions_rec.last_access,
                cgi_env = p_wdx_sessions_rec.cgi_env,
                session_variable = p_wdx_sessions_rec.session_variable,
                modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                modified_date = SYSDATE
           WHERE
                appid = upd.p_wdx_sessions_rec.appid AND 
                session_id = upd.p_wdx_sessions_rec.session_id
                ;
       END IF;

       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;

    EXCEPTION
       WHEN e_upd_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
    END upd;


    PROCEDURE upd_rowid (
                         p_wdx_sessions_rec         IN wdx_sessions_rt,
                         p_ignore_nulls         IN boolean := FALSE
                        )
    IS
    BEGIN

       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   wdx_sessions
             SET appid = NVL(p_wdx_sessions_rec.appid,appid),
                session_id = NVL(p_wdx_sessions_rec.session_id,session_id),
                username = NVL(p_wdx_sessions_rec.username,username),
                expired = NVL(p_wdx_sessions_rec.expired,expired),
                last_access = NVL(p_wdx_sessions_rec.last_access,last_access),
                cgi_env = NVL(p_wdx_sessions_rec.cgi_env,cgi_env),
                session_variable = NVL(p_wdx_sessions_rec.session_variable,session_variable),
                modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                modified_date = SYSDATE
           WHERE  ROWID = p_wdx_sessions_rec.row_id;
       ELSE
          UPDATE   wdx_sessions
             SET appid = p_wdx_sessions_rec.appid,
                session_id = p_wdx_sessions_rec.session_id,
                username = p_wdx_sessions_rec.username,
                expired = p_wdx_sessions_rec.expired,
                last_access = p_wdx_sessions_rec.last_access,
                cgi_env = p_wdx_sessions_rec.cgi_env,
                session_variable = p_wdx_sessions_rec.session_variable,
                modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                modified_date = SYSDATE
           WHERE  ROWID = p_wdx_sessions_rec.row_id;
       END IF;

       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;

    EXCEPTION
       WHEN e_upd_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
    END upd_rowid;

   PROCEDURE web_upd (
                  p_wdx_sessions_rec         IN wdx_sessions_rt,
                  p_ignore_nulls         IN boolean := FALSE
                )
   IS
      l_wdx_sessions_rec wdx_sessions_rt;
   BEGIN

      OPEN wdx_sessions_cur(
                             web_upd.p_wdx_sessions_rec.appid,
                             web_upd.p_wdx_sessions_rec.session_id
                        );

      FETCH wdx_sessions_cur INTO l_wdx_sessions_rec;

      IF wdx_sessions_cur%NOTFOUND THEN
         CLOSE wdx_sessions_cur;
         RAISE e_row_missing;
      ELSE
         IF p_wdx_sessions_rec.hash != l_wdx_sessions_rec.hash THEN
            CLOSE wdx_sessions_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(p_ignore_nulls, FALSE)
            THEN

                UPDATE   wdx_sessions
                   SET appid = NVL(p_wdx_sessions_rec.appid,appid),
                       session_id = NVL(p_wdx_sessions_rec.session_id,session_id),
                       username = NVL(p_wdx_sessions_rec.username,username),
                       expired = NVL(p_wdx_sessions_rec.expired,expired),
                       last_access = NVL(p_wdx_sessions_rec.last_access,last_access),
                       cgi_env = NVL(p_wdx_sessions_rec.cgi_env,cgi_env),
                       session_variable = NVL(p_wdx_sessions_rec.session_variable,session_variable),
                       modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                       modified_date = SYSDATE
               WHERE CURRENT OF wdx_sessions_cur;
            ELSE
                UPDATE   wdx_sessions
                   SET appid = p_wdx_sessions_rec.appid,
                       session_id = p_wdx_sessions_rec.session_id,
                       username = p_wdx_sessions_rec.username,
                       expired = p_wdx_sessions_rec.expired,
                       last_access = p_wdx_sessions_rec.last_access,
                       cgi_env = p_wdx_sessions_rec.cgi_env,
                       session_variable = p_wdx_sessions_rec.session_variable,
                       modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                       modified_date = SYSDATE
               WHERE CURRENT OF wdx_sessions_cur;
            END IF;

            CLOSE wdx_sessions_cur;
         END IF;
      END IF;


   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Update operation failed because the row is no longer in the database.');
   END web_upd;

   PROCEDURE web_upd_rowid (
                            p_wdx_sessions_rec    IN wdx_sessions_rt,
                            p_ignore_nulls         IN boolean := FALSE
                           )
   IS
      l_wdx_sessions_rec wdx_sessions_rt;
   BEGIN

      OPEN wdx_sessions_rowid_cur(web_upd_rowid.p_wdx_sessions_rec.row_id);

      FETCH wdx_sessions_rowid_cur INTO l_wdx_sessions_rec;

      IF wdx_sessions_rowid_cur%NOTFOUND THEN
         CLOSE wdx_sessions_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_upd_rowid.p_wdx_sessions_rec.hash != l_wdx_sessions_rec.hash THEN
            CLOSE wdx_sessions_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(web_upd_rowid.p_ignore_nulls, FALSE)
            THEN
                UPDATE   wdx_sessions
                   SET appid = NVL(p_wdx_sessions_rec.appid,appid),
                       session_id = NVL(p_wdx_sessions_rec.session_id,session_id),
                       username = NVL(p_wdx_sessions_rec.username,username),
                       expired = NVL(p_wdx_sessions_rec.expired,expired),
                       last_access = NVL(p_wdx_sessions_rec.last_access,last_access),
                       cgi_env = NVL(p_wdx_sessions_rec.cgi_env,cgi_env),
                       session_variable = NVL(p_wdx_sessions_rec.session_variable,session_variable),
                       modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                       modified_date = SYSDATE
               WHERE CURRENT OF wdx_sessions_rowid_cur;
            ELSE
                UPDATE   wdx_sessions
                   SET appid = p_wdx_sessions_rec.appid,
                       session_id = p_wdx_sessions_rec.session_id,
                       username = p_wdx_sessions_rec.username,
                       expired = p_wdx_sessions_rec.expired,
                       last_access = p_wdx_sessions_rec.last_access,
                       cgi_env = p_wdx_sessions_rec.cgi_env,
                       session_variable = p_wdx_sessions_rec.session_variable,
                       modified_by = USER /*dbax_core.g$username or apex_application.g_user*/,
                       modified_date = SYSDATE
               WHERE CURRENT OF wdx_sessions_rowid_cur;
            END IF;

            CLOSE wdx_sessions_rowid_cur;
         END IF;
      END IF;


   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Update operation failed because the row is no longer in the database.');
   END web_upd_rowid;

    PROCEDURE del (
                  p_appid IN wdx_sessions.appid%TYPE,
                  p_session_id IN wdx_sessions.session_id%TYPE
                  )
    IS
    BEGIN

       DELETE FROM   wdx_sessions
             WHERE
                  appid = del.p_appid AND 
                  session_id = del.p_session_id
                   ;

       IF sql%ROWCOUNT != 1
       THEN
          RAISE e_del_failed;
       END IF;


    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were deleted. The delete failed.');
    END del;

    PROCEDURE del_rowid (p_rowid IN varchar2)
    IS
    BEGIN

       DELETE FROM   wdx_sessions
             WHERE   ROWID = del_rowid.p_rowid;

       IF sql%ROWCOUNT != 1
       THEN
          RAISE e_del_failed;
       END IF;


    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were deleted. The delete failed.');
    END del_rowid;

    PROCEDURE web_del (
                      p_appid IN wdx_sessions.appid%TYPE,
                      p_session_id IN wdx_sessions.session_id%TYPE,
                      p_hash IN varchar2
                      )
   IS
      l_wdx_sessions_rec wdx_sessions_rt;
   BEGIN


      OPEN wdx_sessions_cur(
                            web_del.p_appid,
                            web_del.p_session_id
                            );

      FETCH wdx_sessions_cur INTO l_wdx_sessions_rec;

      IF wdx_sessions_cur%NOTFOUND THEN
         CLOSE wdx_sessions_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del.p_hash != l_wdx_sessions_rec.hash THEN
            CLOSE wdx_sessions_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM wdx_sessions
            WHERE CURRENT OF wdx_sessions_cur;

            CLOSE wdx_sessions_cur;
         END IF;
      END IF;



   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
   END web_del;

   PROCEDURE web_del_rowid (p_rowid IN varchar2, p_hash IN varchar2)
   IS
      l_wdx_sessions_rec wdx_sessions_rt;
   BEGIN


      OPEN wdx_sessions_rowid_cur(web_del_rowid.p_rowid);

      FETCH wdx_sessions_rowid_cur INTO l_wdx_sessions_rec;

      IF wdx_sessions_rowid_cur%NOTFOUND THEN
         CLOSE wdx_sessions_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del_rowid.p_hash != l_wdx_sessions_rec.hash THEN
            CLOSE wdx_sessions_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM wdx_sessions
            WHERE CURRENT OF wdx_sessions_rowid_cur;

            CLOSE wdx_sessions_rowid_cur;
         END IF;
      END IF;

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
   END web_del_rowid;

   FUNCTION count_user_sessions (p_username IN wdx_log.log_user%TYPE, p_active_sessions IN BOOLEAN DEFAULT TRUE )
     RETURN PLS_INTEGER
   AS
    l_count pls_integer;
    l_expired varchar2(10);
   BEGIN
      if p_active_sessions
      then
        l_expired := '0';
      else
        l_expired := '1';
      end if;
      
      SELECT   COUNT ( * )
        INTO   l_count
        FROM   wdx_sessions
       WHERE   username = count_user_sessions.p_username
               and expired = l_expired;     
     
     RETURN l_count;
   END;
   
END tapi_wdx_sessions;
/


