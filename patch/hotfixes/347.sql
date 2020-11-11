DO
$$
    DECLARE
        schema_nm VARCHAR;
    BEGIN
        FOR schema_nm IN SELECT s.nspname AS schema_name
                         FROM pg_catalog.pg_namespace s
                         WHERE nspname NOT IN ('information_schema', 'pg_catalog', 'public', 'cron', 'management')
                           AND nspname NOT LIKE 'pg_toast%'
                           AND nspname NOT LIKE 'pg_temp_%'
            LOOP
                IF (SELECT p.proname as function_name
                    FROM pg_proc p
                             LEFT JOIN pg_namespace n on p.pronamespace = n.oid
                    WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
                      AND p.proname = 'update_timestamp'
                      AND n.nspname = schema_nm) is not null
                THEN
                    EXECUTE 'SET search_path TO ' || schema_nm;
                    ALTER FUNCTION update_timestamp()
                        RENAME TO update_modified_at;
                END IF;
            END LOOP;
    END
$$;
