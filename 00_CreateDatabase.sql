-- ============================================
-- Force Drop Database (if in use)
-- ============================================

IF DB_ID('FIFAWorldCup2026') IS NOT NULL
BEGIN
    DROP DATABASE FIFAWorldCup2026;
END
GO

CREATE DATABASE FIFAWorldCup2026;
GO

USE FIFAWorldCup2026;
GO

/*
The database is dropped and recreated for testing and marking purposes.
*/