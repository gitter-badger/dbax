CREATE OR REPLACE PACKAGE tapi_wdx_views
IS
   /**
   -- # TAPI_WDX_VIEWS
   -- Generated by: tapiGen2 - DO NOT MODIFY!
   -- Website: github.com/osalvador/tapiGen2
   -- Created On: 06-ABR-2016 06:45
   -- Created By: DBAX
   */

   --Scalar/Column types
   SUBTYPE hash_t IS varchar2 (40);
   SUBTYPE appid IS wdx_views.appid%TYPE;
   SUBTYPE name IS wdx_views.name%TYPE;
   SUBTYPE title IS wdx_views.title%TYPE;
   SUBTYPE source IS wdx_views.source%TYPE;
   SUBTYPE compiled_source IS wdx_views.compiled_source%TYPE;
   SUBTYPE description IS wdx_views.description%TYPE;
   SUBTYPE visible IS wdx_views.visible%TYPE;
   SUBTYPE created_by IS wdx_views.created_by%TYPE;
   SUBTYPE created_date IS wdx_views.created_date%TYPE;
   SUBTYPE modified_by IS wdx_views.modified_by%TYPE;
   SUBTYPE modified_date IS wdx_views.modified_date%TYPE;

   --Record type
   TYPE wdx_views_rt
   IS
      RECORD (
            appid wdx_views.appid%TYPE,
            name wdx_views.name%TYPE,
            title wdx_views.title%TYPE,
            source wdx_views.source%TYPE,
            compiled_source wdx_views.compiled_source%TYPE,
            description wdx_views.description%TYPE,
            visible wdx_views.visible%TYPE,
            created_by wdx_views.created_by%TYPE,
            created_date wdx_views.created_date%TYPE,
            modified_by wdx_views.modified_by%TYPE,
            modified_date wdx_views.modified_date%TYPE,
            hash               hash_t,
            row_id            VARCHAR2(64)
      );
   --Collection types (record)
   TYPE wdx_views_tt IS TABLE OF wdx_views_rt;

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
    --    |p_appid | wdx_views.appid%TYPE | must be NOT NULL
    --    |p_name | wdx_views.name%TYPE | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   FUNCTION hash (
                  p_appid IN wdx_views.appid%TYPE,
                  p_name IN wdx_views.name%TYPE
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
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   FUNCTION hash_rowid (p_rowid IN varchar2)
   RETURN varchar2;

    /**
    --## Function Name: RT
    --### Description:
    --       This is a table encapsulation function designed to retrieve information from the wdx_views table.
    --
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |p_appid | wdx_views.appid%TYPE | must be NOT NULL
    --    |p_name | wdx_views.name%TYPE | must be NOT NULL

    --### Return
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |     | wdx_views_rt |  wdx_views Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   FUNCTION rt (
                p_appid IN wdx_views.appid%TYPE ,
                p_name IN wdx_views.name%TYPE 
               )
    RETURN wdx_views_rt ;

   /**
    --## Function Name: RT_FOR_UPDATE
    --### Description:
    --       This is a table encapsulation function designed to retrieve information
             from the wdx_views table while placing a lock on it for a potential
             update/delete. Do not use this for updates in web based apps, instead use the
             rt_for_web_update function to get a FOR_WEB_UPDATE_RT record which
             includes all of the tables columns along with an md5 checksum for use in the
             web_upd and web_del procedures.
    --
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |p_appid | wdx_views.appid%TYPE | must be NOT NULL
    --    |p_name | wdx_views.name%TYPE | must be NOT NULL
    --### Return
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |     | wdx_views_rt |  wdx_views Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   FUNCTION rt_for_update (
                          p_appid IN wdx_views.appid%TYPE ,
                          p_name IN wdx_views.name%TYPE 
                          )
    RETURN wdx_views_rt ;

    /**
    --## Function Name: TT
    --### Description:
    --       This is a table encapsulation function designed to retrieve information from the wdx_views table.
    --       This function return Record Table as PIPELINED Function
    --
    --### IN Paramters
    --  | Name | Type | Description
    --  | -- | -- | --
    --  |p_appid | wdx_views.appid%TYPE | must be NOT NULL
    --  |p_name | wdx_views.name%TYPE | must be NOT NULL
    --### Return
    --  | Name | Type | Description
    --  | -- | -- | --
    --  |     | wdx_views_tt |  wdx_views Table Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   FUNCTION tt (
                p_appid IN wdx_views.appid%TYPE DEFAULT NULL,
                p_name IN wdx_views.name%TYPE DEFAULT NULL
               )
   RETURN wdx_views_tt
   PIPELINED;

     /**
    --## Function Name: INS
    --### Description:
    --      This is a table encapsulation function designed to insert a row into the wdx_views table.
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   | p_wdx_views_rec | wdx_views_rt| wdx_views Record Type
    --### Return
    --    | Name | Type | Description
    --    | -- | -- | --
    --    | p_wdx_views_rec | wdx_views_rt |  wdx_views Record Type
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   PROCEDURE ins (p_wdx_views_rec IN OUT wdx_views_rt);

    /**
    --## Function Name: UPD
    --### Description:
    --     his is a table encapsulation function designed to update a row in the wdx_views table.
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   | p_wdx_views_rec | wdx_views_rt| wdx_views Record Type
    --   | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   PROCEDURE upd (p_wdx_views_rec IN wdx_views_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: UPD_ROWID
    --### Description:
    --     his is a table encapsulation function designed to update a row in the wdx_views table,
           access directly to the row by rowid
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   | p_wdx_views_rec | wdx_views_rt| wdx_views Record Type
    --   | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   PROCEDURE upd_rowid (p_wdx_views_rec IN wdx_views_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: WEB_UPD
    --### Description:
    --      This is a table encapsulation function designed to update a row
            in the wdx_views table whith optimistic lock validation
    --### IN Paramters
    --  | Name | Type | Description
    --  | -- | -- | --
    --  | p_wdx_views_rec | wdx_views_rt| wdx_views Record Type
    --  | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   PROCEDURE web_upd (p_wdx_views_rec IN wdx_views_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: WEB_UPD_ROWID
    --### Description:
    --      This is a table encapsulation function designed to update a row
            in the wdx_views table whith optimistic lock validation
            access directly to the row by rowid
    --### IN Paramters
    --  | Name | Type | Description
    --  | -- | -- | --
    --  | p_wdx_views_rec | wdx_views_rt| wdx_views Record Type
    --  | p_ignore_nulls | BOOLEAN | IF TRUE then null values are ignored in the update
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   PROCEDURE web_upd_rowid (p_wdx_views_rec IN wdx_views_rt, p_ignore_nulls IN boolean := FALSE);

    /**
    --## Function Name: DEL
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_views table.
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   |p_appid | wdx_views.appid%TYPE | must be NOT NULL
    --   |p_name | wdx_views.name%TYPE | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
   PROCEDURE del (
                  p_appid IN wdx_views.appid%TYPE,
                  p_name IN wdx_views.name%TYPE
                );

    /**
    --## Function Name: DEL_ROWID
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_views table.
             Access directly to the row by rowid
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |P_ROWID | VARCHAR2(64)| must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
    PROCEDURE del_rowid (p_rowid IN VARCHAR2);

    /**
    --## Function Name: WEB_DEL
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_views table
    --       whith optimistic lock validation
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --   |p_appid | wdx_views.appid%TYPE | must be NOT NULL
    --   |p_name | wdx_views.name%TYPE | must be NOT NULL
    --   | p_hash | HASH_T | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
    PROCEDURE web_del (
                      p_appid IN wdx_views.appid%TYPE,
                      p_name IN wdx_views.name%TYPE,
                      p_hash IN varchar2
                      );

    /**
    --## Function Name: WEB_DEL_ROWID
    --### Description:
    --       This is a table encapsulation function designed to delete a row from the wdx_views table
    --       whith optimistic lock validation, access directly to the row by rowid
    --### IN Paramters
    --    | Name | Type | Description
    --    | -- | -- | --
    --    |P_ROWID | VARCHAR2(64)| must be NOT NULL
    --   | P_HASH | HASH_T | must be NOT NULL
    --### Amendments
    --| When         | Who                      | What
    --|--------------|--------------------------|------------------
    --|06-ABR-2016 06:45   | DBAX | Created
    */
    PROCEDURE web_del_rowid (p_rowid IN varchar2,p_hash IN varchar2);

END tapi_wdx_views;
/