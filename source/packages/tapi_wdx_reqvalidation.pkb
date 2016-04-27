
-- TAPI_WDX_REQVALIDATION  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY tapi_wdx_reqvalidation IS

   /**
   -- # TAPI_wdx_request_valid_function
   -- Generated by: tapiGen2 - DO NOT MODIFY!
   -- Website: github.com/osalvador/tapiGen2
   -- Created On: 11-AGO-2015 16:26
   -- Created By: DBAX
   */

    

   --GLOBAL_PRIVATE_CURSORS
   --By PK
   CURSOR wdx_reqvalidation_cur (      
        p_appid     IN      wdx_request_valid_function.appid%TYPE,
        p_procedure_name     IN      wdx_request_valid_function.procedure_name%TYPE
   )
   IS
      SELECT appid
           , procedure_name
           , created_by
           , created_date
           , modified_by
           , modified_date
           , tapi_wdx_reqvalidation.hash(appid, procedure_name)
           , ROWID
      FROM wdx_request_valid_function
      WHERE appid = wdx_reqvalidation_cur.p_appid AND 
            procedure_name = wdx_reqvalidation_cur.p_procedure_name
      FOR UPDATE;

    --By Rowid
    CURSOR wdx_reqvalidation_rowid_cur (p_rowid     IN      varchar2)
    IS
      SELECT appid
           , procedure_name
           , created_by
           , created_date
           , modified_by
           , modified_date
           , tapi_wdx_reqvalidation.hash(appid, procedure_name)
           , ROWID
      FROM wdx_request_valid_function
      WHERE ROWID = p_rowid
      FOR UPDATE;    


    FUNCTION hash (
        p_appid     IN      wdx_request_valid_function.appid%TYPE,
        p_procedure_name     IN      wdx_request_valid_function.procedure_name%TYPE
          )
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
      
      SELECT  appid ||
               procedure_name ||
               created_by ||
               created_date ||
               modified_by ||
               modified_date 
      INTO l_string
      FROM wdx_request_valid_function
      WHERE  appid =  hash.p_appid AND 
             procedure_name =  hash.p_procedure_name;

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

      SELECT  appid ||
               procedure_name ||
               created_by ||
               created_date ||
               modified_by ||
               modified_date 
      INTO l_string
      FROM wdx_request_valid_function
      WHERE  ROWID = p_rowid;

      --Restore NLS_DATE_FORMAT to default
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT=''' || l_date_format|| '''';
      
      
      l_retval := DBMS_CRYPTO.hash(l_string, DBMS_CRYPTO.hash_sh1);

      
      RETURN l_retval;
   
   
   END hash_rowid;   

   FUNCTION rt (
        p_appid     IN      wdx_request_valid_function.appid%TYPE,
        p_procedure_name     IN      wdx_request_valid_function.procedure_name%TYPE
          )
      RETURN wdx_request_valid_function_rt RESULT_CACHE
   IS
        
      l_wdx_reqvalidation_rec wdx_request_valid_function_rt;
   BEGIN
          

      SELECT a.*, tapi_wdx_reqvalidation.hash(appid, procedure_name), rowid
      INTO l_wdx_reqvalidation_rec
      FROM wdx_request_valid_function a
      WHERE appid= rt.p_appid AND 
            procedure_name= rt.p_procedure_name;

            
      RETURN l_wdx_reqvalidation_rec;

   
   END rt;

   FUNCTION rt_for_update (
        p_appid     IN      wdx_request_valid_function.appid%TYPE,
        p_procedure_name     IN      wdx_request_valid_function.procedure_name%TYPE
          )
      RETURN wdx_request_valid_function_rt RESULT_CACHE
   IS
            
      l_wdx_reqvalidation_rec wdx_request_valid_function_rt;
   BEGIN

      
      
      SELECT a.*, tapi_wdx_reqvalidation.hash(appid, procedure_name), rowid
      INTO l_wdx_reqvalidation_rec
      FROM wdx_request_valid_function a
      WHERE appid= rt_for_update.p_appid AND 
            procedure_name= rt_for_update.p_procedure_name
      FOR UPDATE;

      
      RETURN l_wdx_reqvalidation_rec;
   
   
   END rt_for_update;

    FUNCTION tt (
        p_appid IN wdx_request_valid_function.appid%TYPE DEFAULT NULL,
        p_procedure_name IN wdx_request_valid_function.procedure_name%TYPE DEFAULT NULL
              )
       RETURN wdx_request_valid_function_tt
       PIPELINED
    IS
            
       l_wdx_reqvalidation_rec   wdx_request_valid_function_rt;
    BEGIN

       
      
       FOR c1 IN (SELECT   a.*, ROWID
                    FROM   wdx_request_valid_function a
                   WHERE appid= NVL(p_appid,appid) AND 
                         procedure_name= NVL(p_procedure_name,procedure_name))                   
       LOOP
              l_wdx_reqvalidation_rec.appid := c1.appid;
              l_wdx_reqvalidation_rec.procedure_name := c1.procedure_name;
              l_wdx_reqvalidation_rec.created_by := c1.created_by;
              l_wdx_reqvalidation_rec.created_date := c1.created_date;
              l_wdx_reqvalidation_rec.modified_by := c1.modified_by;
              l_wdx_reqvalidation_rec.modified_date := c1.modified_date;
              
              l_wdx_reqvalidation_rec.hash := tapi_wdx_reqvalidation.hash(c1.appid, c1.procedure_name);
              l_wdx_reqvalidation_rec.row_id := c1.ROWID;
              PIPE ROW (l_wdx_reqvalidation_rec);
       END LOOP;

              
       RETURN;
    
    
    END tt;


    PROCEDURE ins (p_wdx_reqvalidation_rec IN OUT wdx_request_valid_function_rt)
    IS
      
             
       l_rowtype     wdx_request_valid_function%ROWTYPE;       
       l_user_name   wdx_request_valid_function.CREATED_BY%TYPE := USER;
       l_date        wdx_request_valid_function.CREATED_DATE%TYPE := SYSDATE;
              
    BEGIN
       
      
       p_wdx_reqvalidation_rec.CREATED_BY := l_user_name;
       p_wdx_reqvalidation_rec.CREATED_DATE := l_date;
       p_wdx_reqvalidation_rec.MODIFIED_BY := l_user_name;
       p_wdx_reqvalidation_rec.MODIFIED_DATE := l_date;
       
       l_rowtype.appid := p_wdx_reqvalidation_rec.appid; 
       l_rowtype.procedure_name := p_wdx_reqvalidation_rec.procedure_name; 
       l_rowtype.created_by := p_wdx_reqvalidation_rec.created_by; 
       l_rowtype.created_date := p_wdx_reqvalidation_rec.created_date; 
       l_rowtype.modified_by := p_wdx_reqvalidation_rec.modified_by; 
       l_rowtype.modified_date := p_wdx_reqvalidation_rec.modified_date;        
       
       INSERT INTO wdx_request_valid_function
         VALUES   l_rowtype;
         
               
    
    
    END ins;

    PROCEDURE upd (p_wdx_reqvalidation_rec IN wdx_request_valid_function_rt, p_ignore_nulls IN boolean := FALSE)
    IS
      
    BEGIN
       
      
       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   wdx_request_valid_function
             SET   appid = NVL(p_wdx_reqvalidation_rec.appid,appid) ,
                   procedure_name = NVL(p_wdx_reqvalidation_rec.procedure_name,procedure_name) ,
                   created_by = NVL(p_wdx_reqvalidation_rec.created_by,created_by) ,
                   created_date = NVL(p_wdx_reqvalidation_rec.created_date,created_date) ,
                   modified_by = NVL(p_wdx_reqvalidation_rec.modified_by,modified_by) ,
                   modified_date = NVL(p_wdx_reqvalidation_rec.modified_date,modified_date) 
           WHERE  appid = p_wdx_reqvalidation_rec.appid AND 
                  procedure_name = p_wdx_reqvalidation_rec.procedure_name;
       ELSE
          UPDATE   wdx_request_valid_function
             SET   appid = p_wdx_reqvalidation_rec.appid ,
                   procedure_name = p_wdx_reqvalidation_rec.procedure_name ,
                   created_by = p_wdx_reqvalidation_rec.created_by ,
                   created_date = p_wdx_reqvalidation_rec.created_date ,
                   modified_by = p_wdx_reqvalidation_rec.modified_by ,
                   modified_date = p_wdx_reqvalidation_rec.modified_date             
           WHERE appid = p_wdx_reqvalidation_rec.appid AND 
                 procedure_name = p_wdx_reqvalidation_rec.procedure_name;
       END IF;
       
       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;
      

    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
              
    END upd;
    
    
    PROCEDURE upd_rowid (p_wdx_reqvalidation_rec IN wdx_request_valid_function_rt, p_ignore_nulls IN boolean := FALSE)
    IS
      
    BEGIN
       
      
       IF NVL (p_ignore_nulls, FALSE)
       THEN
          UPDATE   wdx_request_valid_function
             SET   appid = NVL(p_wdx_reqvalidation_rec.appid,appid) ,
                   procedure_name = NVL(p_wdx_reqvalidation_rec.procedure_name,procedure_name) ,
                   created_by = NVL(p_wdx_reqvalidation_rec.created_by,created_by) ,
                   created_date = NVL(p_wdx_reqvalidation_rec.created_date,created_date) ,
                   modified_by = NVL(p_wdx_reqvalidation_rec.modified_by,modified_by) ,
                   modified_date = NVL(p_wdx_reqvalidation_rec.modified_date,modified_date) 
           WHERE  ROWID = p_wdx_reqvalidation_rec.row_id;
       ELSE
          UPDATE   wdx_request_valid_function
             SET   appid = p_wdx_reqvalidation_rec.appid ,
                   procedure_name = p_wdx_reqvalidation_rec.procedure_name ,
                   created_by = p_wdx_reqvalidation_rec.created_by ,
                   created_date = p_wdx_reqvalidation_rec.created_date ,
                   modified_by = p_wdx_reqvalidation_rec.modified_by ,
                   modified_date = p_wdx_reqvalidation_rec.modified_date             
           WHERE  ROWID = p_wdx_reqvalidation_rec.row_id;
       END IF;
       
       IF SQL%ROWCOUNT != 1 THEN RAISE e_upd_failed; END IF;
      

    EXCEPTION
       WHEN e_del_failed
       THEN
          raise_application_error (-20000, 'No rows were updated. The update failed.');
              
    END upd_rowid;

   PROCEDURE web_upd (
      p_wdx_reqvalidation_rec    IN wdx_request_valid_function_rt
    , p_ignore_nulls         IN boolean := FALSE
   )
   IS
      
      l_wdx_reqvalidation_rec wdx_request_valid_function_rt;
   BEGIN
       
       
      OPEN wdx_reqvalidation_cur(p_wdx_reqvalidation_rec.appid , p_wdx_reqvalidation_rec.procedure_name);
                              
      FETCH wdx_reqvalidation_cur INTO l_wdx_reqvalidation_rec;

      IF wdx_reqvalidation_cur%NOTFOUND THEN
         CLOSE wdx_reqvalidation_cur;
         RAISE e_row_missing;
      ELSE
         IF p_wdx_reqvalidation_rec.hash != l_wdx_reqvalidation_rec.hash THEN
            CLOSE wdx_reqvalidation_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(p_ignore_nulls, FALSE)
            THEN
                UPDATE   wdx_request_valid_function
                   SET   appid = NVL(p_wdx_reqvalidation_rec.appid,appid) ,
                   procedure_name = NVL(p_wdx_reqvalidation_rec.procedure_name,procedure_name) ,
                   created_by = NVL(p_wdx_reqvalidation_rec.created_by,created_by) ,
                   created_date = NVL(p_wdx_reqvalidation_rec.created_date,created_date) ,
                   modified_by = NVL(p_wdx_reqvalidation_rec.modified_by,modified_by) ,
                   modified_date = NVL(p_wdx_reqvalidation_rec.modified_date,modified_date)                                      
               WHERE CURRENT OF wdx_reqvalidation_cur;
            ELSE
                UPDATE   wdx_request_valid_function
                   SET   appid = p_wdx_reqvalidation_rec.appid ,
                   procedure_name = p_wdx_reqvalidation_rec.procedure_name ,
                   created_by = p_wdx_reqvalidation_rec.created_by ,
                   created_date = p_wdx_reqvalidation_rec.created_date ,
                   modified_by = p_wdx_reqvalidation_rec.modified_by ,
                   modified_date = p_wdx_reqvalidation_rec.modified_date    
               WHERE CURRENT OF wdx_reqvalidation_cur;
            END IF;

            CLOSE wdx_reqvalidation_cur;
         END IF;
      END IF;

      

   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
     
   END web_upd;
   
   PROCEDURE web_upd_rowid (
      p_wdx_reqvalidation_rec    IN wdx_request_valid_function_rt
    , p_ignore_nulls         IN boolean := FALSE
   )
   IS
      
      l_wdx_reqvalidation_rec wdx_request_valid_function_rt;
   BEGIN
       
       
      OPEN wdx_reqvalidation_rowid_cur(p_wdx_reqvalidation_rec.row_id);
                              
      FETCH wdx_reqvalidation_rowid_cur INTO l_wdx_reqvalidation_rec;

      IF wdx_reqvalidation_rowid_cur%NOTFOUND THEN
         CLOSE wdx_reqvalidation_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF p_wdx_reqvalidation_rec.hash != l_wdx_reqvalidation_rec.hash THEN
            CLOSE wdx_reqvalidation_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            IF NVL(p_ignore_nulls, FALSE)
            THEN
                UPDATE   wdx_request_valid_function
                     SET  appid = NVL(p_wdx_reqvalidation_rec.appid,appid) ,
                          procedure_name = NVL(p_wdx_reqvalidation_rec.procedure_name,procedure_name) ,
                          created_by = NVL(p_wdx_reqvalidation_rec.created_by,created_by) ,
                          created_date = NVL(p_wdx_reqvalidation_rec.created_date,created_date) ,
                          modified_by = NVL(p_wdx_reqvalidation_rec.modified_by,modified_by) ,
                          modified_date = NVL(p_wdx_reqvalidation_rec.modified_date,modified_date)                                      
               WHERE CURRENT OF wdx_reqvalidation_rowid_cur;
            ELSE
                UPDATE   wdx_request_valid_function
                 SET  appid = p_wdx_reqvalidation_rec.appid ,
                      procedure_name = p_wdx_reqvalidation_rec.procedure_name ,
                      created_by = p_wdx_reqvalidation_rec.created_by ,
                      created_date = p_wdx_reqvalidation_rec.created_date ,
                      modified_by = p_wdx_reqvalidation_rec.modified_by ,
                      modified_date = p_wdx_reqvalidation_rec.modified_date    
               WHERE CURRENT OF wdx_reqvalidation_rowid_cur;
            END IF;

            CLOSE wdx_reqvalidation_rowid_cur;
         END IF;
      END IF;

      


   EXCEPTION
     WHEN e_ol_check_failed
     THEN
        raise_application_error (-20000 , 'Current version of data in database has changed since last page refresh.');
     WHEN e_row_missing
     THEN
        raise_application_error (-20000 , 'Delete operation failed because the row is no longer in the database.');
     
   END web_upd_rowid;   

    PROCEDURE del (
        p_appid IN wdx_request_valid_function.appid%TYPE,
        p_procedure_name IN wdx_request_valid_function.procedure_name%TYPE
              )
    IS
      
    BEGIN
       
       
       DELETE FROM   wdx_request_valid_function
             WHERE   appid = del.p_appid AND 
                     procedure_name = del.p_procedure_name;
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
       
       
       DELETE FROM   wdx_request_valid_function
             WHERE   ROWID = p_rowid;
             
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
        p_appid IN wdx_request_valid_function.appid%TYPE,
        p_procedure_name IN wdx_request_valid_function.procedure_name%TYPE
      , p_hash IN varchar2
   )
   IS
      
      l_wdx_reqvalidation_rec wdx_request_valid_function_rt;
   BEGIN

      
       
      OPEN wdx_reqvalidation_cur(web_del.p_appid, web_del.p_procedure_name);
                              
      FETCH wdx_reqvalidation_cur INTO l_wdx_reqvalidation_rec;

      IF wdx_reqvalidation_cur%NOTFOUND THEN
         CLOSE wdx_reqvalidation_cur;
         RAISE e_row_missing;
      ELSE
         IF p_hash != l_wdx_reqvalidation_rec.hash THEN
            CLOSE wdx_reqvalidation_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM wdx_request_valid_function
            WHERE CURRENT OF wdx_reqvalidation_cur;

            CLOSE wdx_reqvalidation_cur;
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
      
      l_wdx_reqvalidation_rec wdx_request_valid_function_rt;
   BEGIN

      
       
      OPEN wdx_reqvalidation_rowid_cur(web_del_rowid.p_rowid);
                              
      FETCH wdx_reqvalidation_rowid_cur INTO l_wdx_reqvalidation_rec;

      IF wdx_reqvalidation_rowid_cur%NOTFOUND THEN
         CLOSE wdx_reqvalidation_rowid_cur;
         RAISE e_row_missing;
      ELSE
         IF web_del_rowid.p_hash != l_wdx_reqvalidation_rec.hash THEN
            CLOSE wdx_reqvalidation_rowid_cur;
            RAISE e_ol_check_failed;
         ELSE
            DELETE FROM wdx_request_valid_function
            WHERE CURRENT OF wdx_reqvalidation_rowid_cur;

            CLOSE wdx_reqvalidation_rowid_cur;
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

   FUNCTION get_xml (p_appid IN wdx_request_valid_function.appid%TYPE)
      RETURN XMLTYPE
   AS
      l_refcursor   sys_refcursor;
      l_dummy       VARCHAR2 (1);      
      l_xmldata               XMLTYPE;
      l_current_date_format   VARCHAR2 (100);
   BEGIN
      SELECT   VALUE
        INTO   l_current_date_format
        FROM   nls_session_parameters
       WHERE   parameter = 'NLS_DATE_FORMAT';

      /* ISO 8601 date format*/
      EXECUTE IMMEDIATE 'ALTER SESSION SET nls_date_format = ''YYYY-MM-DD"T"HH24:MI:SS''';      
      
      --If record not exists raise NO_DATA_FOUND
      SELECT   NULL
        INTO   l_dummy
        FROM   wdx_request_valid_function
       WHERE   appid = UPPER (p_appid) AND ROWNUM = 1;
    
      OPEN l_refcursor FOR
         SELECT   *
           FROM   wdx_request_valid_function
          WHERE   appid = UPPER (p_appid);

      l_xmldata   := xmltype (l_refcursor);

      EXECUTE IMMEDIATE 'ALTER SESSION SET nls_date_format = ''' || l_current_date_format || '''';

      RETURN l_xmldata;
   END get_xml;
   
   FUNCTION get_tt (p_xml IN XMLTYPE)
      RETURN wdx_request_valid_function_tt
      PIPELINED
   IS
      l_wdx_reqvalidation_rec   wdx_request_valid_function_rt;
      l_current_date_format   VARCHAR2 (100);
   BEGIN
      SELECT   VALUE
        INTO   l_current_date_format
        FROM   nls_session_parameters
       WHERE   parameter = 'NLS_DATE_FORMAT';

      /* ISO 8601 date format*/
      EXECUTE IMMEDIATE 'ALTER SESSION SET nls_date_format = ''YYYY-MM-DD"T"HH24:MI:SS''';
      
      FOR c1 IN (SELECT   xt.*
                   FROM   XMLTABLE ('/ROWSET/ROW'
                                    PASSING get_tt.p_xml
                                    COLUMNS 
                                      "APPID"              VARCHAR2(50)   PATH 'APPID',
                                      "PROCEDURE_NAME"     VARCHAR2(255)  PATH 'PROCEDURE_NAME',                                      
                                      "CREATED_BY"         VARCHAR2(100)  PATH 'CREATED_BY',
                                      "CREATED_DATE"       VARCHAR2(20)   PATH 'CREATED_DATE',
                                      "MODIFIED_BY"        VARCHAR2(100)  PATH 'MODIFIED_BY',
                                      "MODIFIED_DATE"      VARCHAR2(20)   PATH 'MODIFIED_DATE'
                                    ) xt)
      LOOP
          l_wdx_reqvalidation_rec.appid := c1.appid;
          l_wdx_reqvalidation_rec.procedure_name := c1.procedure_name;
          l_wdx_reqvalidation_rec.created_by := c1.created_by;
          l_wdx_reqvalidation_rec.created_date := c1.created_date;
          l_wdx_reqvalidation_rec.modified_by := c1.modified_by;
          l_wdx_reqvalidation_rec.modified_date := c1.modified_date;
          PIPE ROW (l_wdx_reqvalidation_rec);
      END LOOP;

      EXECUTE IMMEDIATE 'ALTER SESSION SET nls_date_format = ''' || l_current_date_format || '''';

      RETURN;
   END get_tt;

END tapi_wdx_reqvalidation;
/


