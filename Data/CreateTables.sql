
CREATE LOGIN NandaSurendra
WITH PASSWORD = 'MI$T353Instructor';

CREATE USER NandaSurendra

FOR LOGIN NandaSurendra;

ALTER ROLE db_owner ADD MEMBER NandaSurendra;





/*
CREATE table test_table (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP --DEFAULT CURRENT_TIMESTAMP
);

*/
