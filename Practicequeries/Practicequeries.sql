
# Case Management Audit SQL Queries

This notebook contains SQL queries that interact with the `audit` table in the `case_management` schema. Each query is explained with comments for clarity.

```sql
-- Count distinct 'id_audit' values
-- This counts how many unique 'id_audit' entries exist in the 'audit' table
select count(distinct id_audit) from case_management.audit;

-- Retrieve first 100 rows from 'audit' table
-- Useful for previewing the first 100 rows of the data
select * from case_management.audit limit 100;

-- Count the total number of rows in the 'audit' table
-- This gives you an idea of the size of the table
select count(*) as no_ofrows from case_management.audit;

-- Retrieve all records where 'correlation_id' matches a specific value
-- This is useful when searching for audit logs related to a specific correlation ID
select * from case_management.audit where correlation_id = '2023-Albania-1015';

-- Retrieve record by 'id_audit' value
-- This finds a specific audit record by its unique identifier
select * from case_management.audit where id_audit = 'd0797501-b5fd-435c-848f-2d1afc7f4a0b';

-- Subquery: Get the first 100 rows and filter by 'correlation_id'
-- This is a combination of pagination (LIMIT 100) and a filter condition
SELECT * 
FROM (
    SELECT * 
    FROM case_management.audit
    LIMIT 100
) AS first_100_rows
WHERE correlation_id = '2023-Albania-1015';

-- Subquery: Get the first 100 rows and filter by 'entity_name'
-- Useful to examine the first 100 records with a specific entity name
SELECT * 
FROM (
    SELECT * 
    FROM case_management.audit
    LIMIT 100
) AS first_100_rows
WHERE entity_name = 'Study';

-- Retrieve column details (name and type) from 'audit' table
-- This helps you understand the structure of the table
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'case_management' AND table_name = 'audit';

-- List all tables in the 'case_management' schema
-- Useful for verifying the presence of the 'audit' table in the schema
SELECT TABLE_SCHEMA, TABLE_NAME
FROM information_schema.tables
WHERE TABLE_NAME = 'audit';

-- Get the current database name
-- This helps to know which database you're connected to
SELECT current_database();

-- Count tables in the current database
-- This gives you a quick overview of how many tables are present in the current database
SELECT COUNT(*) 
FROM information_schema.tables 
WHERE table_catalog = current_database();

-- List all tables in the 'public' schema
-- If you're interested in the public schema, this query helps to list all tables there
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public';

-- Count distinct 'entity_id' values in the 'audit' table
-- Useful for understanding how many unique entities are being tracked
select count(distinct entity_id) from case_management.audit;

-- Group by 'correlation_id' and count occurrences
-- This groups rows by 'correlation_id' and orders them by the count in descending order
select correlation_id, count(*) as count1 from case_management.audit group by 1 order by count(*) desc;

-- Group by 'entity_id' and count occurrences
-- Similar to the previous query, but grouping by 'entity_id'
select entity_id , count(*) as count2 from case_management.audit group by 1 order by count(*) desc;

-- Group by 'entity_name' and count occurrences
-- This groups the data by 'entity_name' and orders by count
select entity_name , count(*) as count3 from case_management.audit group by 1 order by count(*) desc;

-- Replace underscores with spaces for better readability
-- This replaces underscores in the 'entity_name' and 'event' columns with spaces
SELECT 
    REPLACE(entity_name, '_', ' ') AS entity_name,
    REPLACE(event, '_', ' ') AS event,
    TO_CHAR(modified_datetime, 'YYYY-MM-DD HH24:MI:SS') AS modified_datetime
FROM 
    case_management.audit;

-- Extract specific JSON fields from the 'updated_data' column
-- Here, we extract the 'tenantId' field as 'Date_Received' from the 'updated_data' JSON field
select id_audit,
    (a.updated_data::json -> 'tenantId'::text) ->> 'tenantId'::text AS Date_Received
from case_management.audit a;

-- Extract nested JSON fields (e.g., 'dateReceived' and 'receiptdate')
-- This demonstrates how to extract specific nested JSON data from the 'updated_data' column
select updated_data::json->'dateReceived'->'dr' as dr, updated_data::json->'receiptdate'->'receiptdate' as rd
from case_management.audit;

-- Alter the 'updated_data' column data type to JSON with a length of 400 characters
-- This modifies the column definition to accommodate larger JSON objects
ALTER TABLE case_management.audit ALTER COLUMN updated_data TYPE json(400);

