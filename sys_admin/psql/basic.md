1. Connect to a PostgreSQL database:
   psql -U username -d database_name

2. List all databases:
   \l

3. Connect to a specific database:
   \c database_name

4. List all tables in the current database:
   \dt

5. Describe a table:
   \d table_name

6. Execute SQL queries:
   SELECT * FROM table_name;

7. Exit psql:
   \q

8. Create a new database:
   CREATE DATABASE new_database;

9. Create a new user:
   CREATE USER new_user WITH PASSWORD 'password';

10. Grant privileges to a user:
    GRANT permission(s) ON table_name TO username;

11. Revoke privileges from a user:
    REVOKE permission(s) ON table_name FROM username;

12. Drop a database:
    DROP DATABASE database_name;

13. List all schemas in the current database:
    \dn

14. List all views in the current database:
    \dv

15. List all sequences in the current database:
    \ds

16. List all functions in the current database:
    \df

17. List all indexes in the current database:
    \di

18. Backup a database:
    pg_dump -U username -d database_name -f backup_file.sql

19. Restore a database from a backup:
    psql -U username -d database_name -f backup_file.sql

20. Show current user and database:
    SELECT current_user, current_database();

21. Show database version:
    SELECT version();

22. Show PostgreSQL configuration settings:
    SHOW ALL;


23. Show active connections:
    SELECT * FROM pg_stat_activity;

24. Show locks and their status:
    SELECT * FROM pg_locks;

25. Show all users:
    \du

26. Change the password for a user:
    ALTER USER username WITH PASSWORD 'new_password';

27. Rename a database:
    ALTER DATABASE old_database_name RENAME TO new_database_name;

28. Rename a user:
    ALTER USER old_username RENAME TO new_username;

29. Create a new schema:
    CREATE SCHEMA schema_name;

30. Delete a schema (and its contents):
    DROP SCHEMA schema_name CASCADE;

31. Create an index:
    CREATE INDEX index_name ON table_name (column_name);

32. Delete an index:
    DROP INDEX index_name;

33. Analyze a table for better query optimization:
    ANALYZE table_name;

34. Vacuum a table to reclaim storage space:
    VACUUM table_name;

35. Show the current transaction isolation level:
    SHOW transaction_isolation;

36. Set the transaction isolation level (e.g., to 'READ COMMITTED'):
    SET transaction_isolation TO 'READ COMMITTED';

37. Check the PostgreSQL logs for errors and information:
    tail -f /var/log/postgresql/postgresql.log

38. Show table and index sizes in the current database:
    SELECT
      schemaname,
      tablename,
      pg_size_pretty(total_bytes) AS total,
      pg_size_pretty(index_bytes) AS index,
      pg_size_pretty(toast_bytes) AS toast,
      pg_size_pretty(table_bytes) AS table
    FROM (
      SELECT
        nspname AS schemaname,
        relname AS tablename,
        pg_total_relation_size(c.oid) AS total_bytes,
        pg_indexes_size(c.oid) AS index_bytes,
        pg_total_relation_size(reltoastrelid) AS toast_bytes,
        pg_total_relation_size(relid) AS table_bytes
      FROM pg_class c
      LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
      WHERE relkind = 'r'
    ) AS table_stats
    ORDER BY total_bytes DESC;

39. Show information about the current database:
    \l+

40. Show information about a specific table including storage details:
    \d+ table_name;
41. Show the size of a specific table in the current database:
    SELECT pg_size_pretty(pg_total_relation_size('schema_name.table_name'));

42. Show the last auto-generated value in a sequence:
    SELECT last_value FROM sequence_name;

43. Reset a sequence's value:
    SELECT setval('sequence_name', new_value);

44. Show the current schema search path:
    SHOW search_path;

45. Set the schema search path:
    SET search_path TO schema_name;

46. Show all stored procedures (functions):
    \df+

47. Show all triggers in the current database:
    \dy

48. Show detailed information about a specific trigger:
    \d trigger_name;

49. Show database locks:
    SELECT * FROM pg_locks;

50. Terminate a session by process ID (e.g., to forcefully disconnect a client):
    SELECT pg_terminate_backend(pid);

51. Show autovacuum status:
    SELECT schemaname, relname, last_autovacuum FROM pg_stat_all_tables;

52. Show replication status:
    SELECT * FROM pg_stat_replication;

53. Show replication slots:
    SELECT * FROM pg_replication_slots;

54. Show replication connections:
    SELECT * FROM pg_stat_wal_receiver;

55. Show replication publications:
    SELECT * FROM pg_publication;

56. Show replication subscriptions:
    SELECT * FROM pg_subscription;

57. Show replication subscriptions details:
    SELECT * FROM pg_subscription_rel;

58. Show replication publication tables:
    SELECT * FROM pg_publication_tables;

59. Show replication origins:
    SELECT * FROM pg_replication_origin;

60. Manage replication subscriptions (create, drop, etc.) using the `pg_create_subscription`, `pg_drop_subscription`, and related commands.

61. Analyze a specific table:
    ANALYZE table_name;

62. Analyze a specific schema:
    ANALYZE schema_name;

63. Vacuum a specific table:
    VACUUM table_name;

64. Vacuum a specific schema:
    VACUUM schema_name;

65. Show the size of specific indexes on a table:
    SELECT indexname, pg_size_pretty(pg_relation_size(indexname))
    FROM pg_indexes
    WHERE tablename = 'table_name';

66. Show replication slots details:
    SELECT * FROM pg_replication_slots;

67. Show replication subscriptions details:
    SELECT * FROM pg_subscription_rel;

68. Show replication publication tables details:
    SELECT * FROM pg_publication_tables;

69. Show the current configuration settings for a specific parameter (e.g., max_connections):
    SHOW max_connections;

70. Change a PostgreSQL configuration parameter temporarily (e.g., work_mem):
    SET work_mem = '64MB';

71. Reload the PostgreSQL configuration to apply changes:
    SELECT pg_reload_conf();

72. Show the current connections to the database server:
    SELECT * FROM pg_stat_activity;

73. Show all roles (users and groups):
    SELECT rolname FROM pg_roles;

74. Grant membership in a group role to another role:
    GRANT group_role TO user_role;

75. Revoke membership in a group role from another role:
    REVOKE group_role FROM user_role;

76. Show the current value of a configuration parameter:
    SHOW parameter_name;

77. Show the estimated row count and size of a specific table:
    SELECT reltuples AS row_count, pg_size_pretty(relpages::bigint*8192) AS table_size
    FROM pg_class
    WHERE relname = 'table_name';

78. Show detailed information about a specific sequence:
    \d+ sequence_name;

79. Show information about foreign key constraints:
    \d table_name

80. Enable a foreign key constraint:
    ALTER TABLE table_name ENABLE TRIGGER constraint_name;

81. Disable a foreign key constraint:
    ALTER TABLE table_name DISABLE TRIGGER constraint_name;

82. Display the list of operators:
    \do

83. Display the list of operator classes:
    \dO

84. Display the list of data types:
    \dT

85. Display the list of collations:
    \dc

86. Display the list of conversions:
    \dC

87. Display the list of text search configurations:
    \dFt

88. Display the list of text search dictionaries:
    \dFd

89. Display the list of text search templates:
    \dFp

90. Display the list of text search parsers:
    \dFy

91. Display the list of text search lexemes:
    \dFl

92. Display the list of text search types:
    \dTt

93. Display the list of text search mappings:
    \dTm

94. Display the list of foreign data wrappers:
    \dew

95. Display the list of foreign servers:
    \des

96. Display the list of foreign tables:
    \det

97. Display the list of event triggers:
    \deT

98. Show information about an event trigger:
    \dE event_trigger_name;

