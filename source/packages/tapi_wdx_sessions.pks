--
-- TAPI_WDX_SESSIONS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   WDX_LOG (Table)
--   WDX_SESSIONS (Table)
--
CREATE OR REPLACE PACKAGE      tapi_wdx_sessions
IS
   /**
   -- # TAPI_WDX_SESSIONS
   -- Generated by: tapiGen2 - DO NOT MODIFY!
   -- Website: github.com/osalvador/tapiGen2
   -- Created On: 24-NOV-2015 17:26
   -- Created By: DBAX
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE appid IS wdx_sessions.appid%TYPE;
   SUBTYPE session_id IS wdx_sessions.session_id%TYPE;
   SUBTYPE username IS wdx_sessions.username%TYPE;
   SUBTYPE expired IS wdx_sessions.expired%TYPE;
   SUBTYPE last_access IS wdx_sessions.last_access%TYPE;
   SUBTYPE cgi_env IS wdx_sessions.cgi_env%TYPE;
   SUBTYPE session_variable IS wdx_sessions.session_variable%TYPE;
   SUBTYPE created_by IS wdx_sessions.created_by%TYPE;
   SUBTYPE created_date IS wdx_sessions.created_date%TYPE;
   SUBTYPE modified_by IS wdx_sessions.modified_by%TYPE;
   SUBTYPE modified_date IS wdx_sessions.modified_date%TYPE;

   --Record type
   TYPE wdx_sessions_rt
   IS
      RECORD (
            appid wdx_sessions.appid%TYPE,
            session_id wdx_sessions.session_id%TYPE,
            username wdx_sessions.username%TYPE,
            expired wdx_sessions.expired%TYPE,
            last_access wdx_sessions.last_access%TYPE,
            cgi_env wdx_sessions.cgi_env%TYPE,
            session_variable wdx_sessions.session_variable%TYPE,
            created_by wdx_sessions.created_by%TYPE,
            created_date wdx_sessions.created_date%TYPE,
            modified_by wdx_sessions.modified_by%TYPE,
            modified_date wdx_sessions.modified_date%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE wdx_sessions_tt IS TABLE OF wdx_sessions_rt;

   --Global exceptions
   e_ol_check_failed EXCEPTION; --Optimistic lock check failed
   e_row_missing     EXCEPTION; --The cursor failed to get a row
   e_upd_failed      EXCEPTION; --The update operation failed
   e_del_failed      EXCEPTION; --The delete operation failed

    /**
    --## Function Name: HASH
    --### Description:
    --       This function generates a SHA1 hash for optimistic locking purposes.
    --
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |p_appid | wdx_sessions.appid%TYPE | must be NOT NULL
    --    |p_session_id | wdx_sessions.session_id%TYPE | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   FUNCTION hash (
                  p_appid IN wdx_sessions.appid%TYPE,
                  p_session_id IN wdx_sessions.session_id%TYPE
                 )
    RETURN VARCHAR2;

    /**
    --## Function Name: HASH_ROWID
    --### Description:
    --       This function generates a SHA1 hash for optimistic locking purposes.
             Access directly to the row by rowid
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |P_ROWID | VARCHAR2(64)| must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

    /**
    --## Function Name: RT
    --### Description:
    --       This is a table encapsulation function designed to retrieve information from the wdx_sessions table.
    --
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |p_appid | wdx_sessions.appid%TYPE | must be NOT NULL
    --    |p_session_id | wdx_sessions.session_id%TYPE | must be NOT NULL

    --### Return
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |     | wdx_sessions_rt |  wdx_sessions Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   FUNCTION rt (
                p_appid IN wdx_sessions.appid%TYPE ,
                p_session_id IN wdx_sessions.session_id%TYPE 
               )
    RETURN wdx_sessions_rt RESULT_CACHE;

   /**
    --## Function Name: RT_FOR_UPDATE
    --### Description:
    --       This is a table encapsulation function designed to retrieve information
             from the wdx_sessions table while placing a lock on it for a potential
             update/delete. Do not use this for updates in web based apps, instead use the
             rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
             includes all of the tables columns along with an md5 checksum for use in the
             web_upd and web_del procedures.
    --
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |p_appid | wdx_sessions.appid%TYPE | must be NOT NULL
    --    |p_session_id | wdx_sessions.session_id%TYPE | must be NOT NULL
    --### Return
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |     | wdx_sessions_rt |  wdx_sessions Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   FUNCTION rt_for_update (
                          p_appid IN wdx_sessions.appid%TYPE ,
                          p_session_id IN wdx_sessions.session_id%TYPE 
                          )
    RETURN wdx_sessions_rt RESULT_CACHE;

    /**
    --## Function Name: TT
    --### Description:
    --       This is a table encapsulation function designed to retrieve information from the wdx_sessions table.
    --       This function return Record Table as PIPELINED Function
    --
    --### IN Paramters
    --  | Name | Type | Description
    --  | -- | -- | --
    --  |p_appid | wdx_sessions.appid%TYPE | must be NOT NULL
    --  |p_session_id | wdx_sessions.session_id%TYPE | must be NOT NULL
    --### Return
    --  | Name | Type | Description
    --  | -- | -- | --
    --  |     | wdx_sessions_tt |  wdx_sessions Table Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   FUNCTION tt (
                p_appid IN wdx_sessions.appid%TYPE DEFAULT NULL,
                p_session_id IN wdx_sessions.session_id%TYPE DEFAULT NULL
               )
   RETURN wdx_sessions_tt
   PIPELINED;

     /**
    --## Function Name: INS
    --### Description:
    --      This is a table encapsulation function designed to insert a row into the wdx_sessions table.
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   | p_wdx_sessions_rec | wdx_sessions_rt| wdx_sessions Record Type
    --### Return
    --    | Name | Type | Description
    --    | -- | -- | --
    --    | p_wdx_sessions_rec | wdx_sessions_rt |  wdx_sessions Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   PROCEDURE ins (p_wdx_sessions_rec IN OUT wdx_sessions_rt);

    /**
    --## Function Name: UPD
    --### Description:
    --     his is a table encapsulation function designed to update a row in the wdx_sessions table.
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   | p_wdx_sessions_rec | wdx_sessions_rt| wdx_sessions Record Type
    --   | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   PROCEDURE upd (p_wdx_sessions_rec IN wdx_sessions_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: UPD_ROWID
    --### Description:
    --     his is a table encapsulation function designed to update a row in the wdx_sessions table,
           access directly to the row by rowid
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   | p_wdx_sessions_rec | wdx_sessions_rt| wdx_sessions Record Type
    --   | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   PROCEDURE upd_rowid (p_wdx_sessions_rec IN wdx_sessions_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: WEB_UPD
    --### Description:
    --      This is a table encapsulation function designed to update a row
            in the wdx_sessions table whith optimistic lock validation
    --### IN Paramters
    --  | Name | Type | Description
    --  | -- | -- | --
    --  | p_wdx_sessions_rec | wdx_sessions_rt| wdx_sessions Record Type
    --  | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   PROCEDURE web_upd (p_wdx_sessions_rec IN wdx_sessions_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: WEB_UPD_ROWID
    --### Description:
    --      This is a table encapsulation function designed to update a row
            in the wdx_sessions table whith optimistic lock validation
            access directly to the row by rowid
    --### IN Paramters
    --  | Name | Type | Description
    --  | -- | -- | --
    --  | p_wdx_sessions_rec | wdx_sessions_rt| wdx_sessions Record Type
    --  | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   PROCEDURE web_upd_rowid (p_wdx_sessions_rec IN wdx_sessions_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: DEL
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_sessions table.
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   |p_appid | wdx_sessions.appid%TYPE | must be NOT NULL
    --   |p_session_id | wdx_sessions.session_id%TYPE | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
   PROCEDURE del (
                  p_appid IN wdx_sessions.appid%TYPE,
                  p_session_id IN wdx_sessions.session_id%TYPE
                );

    /**
    --## Function Name: DEL_ROWID
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_sessions table.
             Access directly to the row by rowid
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |P_ROWID | VARCHAR2(64)| must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

    /**
    --## Function Name: WEB_DEL
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_sessions table
    --       whith optimistic lock validation
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   |p_appid | wdx_sessions.appid%TYPE | must be NOT NULL
    --   |p_session_id | wdx_sessions.session_id%TYPE | must be NOT NULL
    --   | p_hash | HASH_T | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
    PROCEDURE web_del (
                      p_appid IN wdx_sessions.appid%TYPE,
                      p_session_id IN wdx_sessions.session_id%TYPE,
                      p_hash IN varchar2
                      );

    /**
    --## Function Name: WEB_DEL_ROWID
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_sessions table
    --       whith optimistic lock validation, access directly to the row by rowid
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |P_ROWID | VARCHAR2(64)| must be NOT NULL
    --   | P_HASH | HASH_T | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|24-NOV-2015 17:26   | DBAX | Created
    */
    PROCEDURE web_del_rowid (p_rowid IN varchar2,p_hash IN varchar2);

    
    FUNCTION count_user_sessions (p_username IN wdx_log.log_user%TYPE, p_active_sessions IN BOOLEAN DEFAULT TRUE )
      RETURN PLS_INTEGER;

END tapi_wdx_sessions;
/


