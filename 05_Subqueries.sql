-- ============================================
-- File: 05_Subqueries.sql
-- ============================================

USE FIFAWorldCup2026;
GO

SELECT FirstName, LastName, Goals
FROM Players
WHERE Goals > (
    SELECT AVG(Goals) FROM Players
);
GO