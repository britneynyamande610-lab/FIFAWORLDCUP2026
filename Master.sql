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

-- ============================================
-- File: 01_CreateTables.sql (CONSTRAINTS VERSION)
-- ============================================

USE FIFAWorldCup2026;
GO

-- 1. Country

CREATE TABLE Country (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,
    CountryName NVARCHAR(50) NOT NULL UNIQUE,
    Continent NVARCHAR(50) NOT NULL
);
GO

-- 2. Cities

CREATE TABLE Cities (
    CityID INT IDENTITY(1,1) PRIMARY KEY,
    CityName NVARCHAR(50) NOT NULL,
    CountryID INT NOT NULL,
    CONSTRAINT UQ_City UNIQUE (CityName, CountryID),
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);
GO

-- 3. Stadium

CREATE TABLE Stadium (
    StadiumID INT IDENTITY(1,1) PRIMARY KEY,
    StadiumName NVARCHAR(100) NOT NULL UNIQUE,
    Capacity INT NOT NULL CHECK (Capacity > 0),
    CityID INT NOT NULL,
    FOREIGN KEY (CityID) REFERENCES Cities(CityID)
);
GO

-- 4. Teams

CREATE TABLE Teams (
    TeamID INT IDENTITY(1,1) PRIMARY KEY,
    TeamName NVARCHAR(50) NOT NULL UNIQUE,
    CoachName NVARCHAR(50) NOT NULL,
    CountryID INT NOT NULL UNIQUE,  /* each country has only 1 team */
    FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);
GO

-- 5. Players

CREATE TABLE Players (
    PlayerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Initials NVARCHAR(10) NOT NULL,
    Position NVARCHAR(20) NOT NULL,
    JerseyNumber INT NOT NULL CHECK (JerseyNumber > 0),
    Goals INT NOT NULL DEFAULT 0,
    TeamID INT NOT NULL,
    CONSTRAINT UQ_Player UNIQUE (FirstName, LastName, TeamID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
GO

-- 6. Matches

CREATE TABLE Matches (
    MatchID INT IDENTITY(1,1) PRIMARY KEY,
    MatchDate DATE NOT NULL,
    KickoffTime TIME NOT NULL,
    Stage NVARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    PlayerOfTheMatch INT NULL,
    CONSTRAINT UQ_Match UNIQUE (MatchDate, KickoffTime, StadiumID),
    FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID),
    FOREIGN KEY (PlayerOfTheMatch) REFERENCES Players(PlayerID)
);
GO

-- 7. MatchLineUp

CREATE TABLE MatchLineUp (
    MatchID INT NOT NULL,
    TeamID INT NOT NULL,
    PRIMARY KEY (MatchID, TeamID),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID)
);
GO

-- 8. Fans

CREATE TABLE Fans (
    FanID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE
);
GO

-- 9. Tickets

CREATE TABLE Tickets (
    TicketID INT IDENTITY(1,1) PRIMARY KEY,
    MatchID INT NOT NULL,
    FanID INT NOT NULL,
    SeatNumber NVARCHAR(50) NOT NULL,
    Price MONEY NOT NULL CHECK (Price >= 0),
    CONSTRAINT UQ_Ticket UNIQUE (MatchID, SeatNumber),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (FanID) REFERENCES Fans(FanID)
);
GO


-- ============================================
-- File: 02_InsertData.sql
-- Description: Populate all tables with sample data
-- ============================================

USE FIFAWorldCup2026;
GO

-- 1. Countries
INSERT INTO Country (CountryName, Continent) VALUES
('USA', 'North America'),        -- 1
('Japan', 'Asia'),               -- 2
('Brazil', 'South America'),     -- 3
('Mexico', 'North America'),     -- 4
('Germany', 'Europe'),           -- 5
('France', 'Europe'),            -- 6
('Spain', 'Europe'),             -- 7
('Argentina', 'South America'),  -- 8
('Canada', 'North America'),     -- 9
('South Africa', 'Africa');      -- 10
GO


-- 2. Cities (FIXED)
INSERT INTO Cities (CityName, CountryID) VALUES
('New York', 1),
('Los Angeles', 1),
('Mexico City', 4),
('Guadalajara', 4),       
('Toronto', 9),
('Vancouver', 9),
('Berlin', 5),
('Paris', 6),
('Tokyo', 2),
('Johannesburg', 10);
GO


-- 3. Stadiums (FIXED CityID links)
INSERT INTO Stadium (StadiumName, Capacity, CityID) VALUES
('MetLife Stadium', 80000, 1),   
('SoFi Stadium', 70000, 2), 
('Azteca Stadium', 87000, 3),    
('Akron Stadium', 46000, 4),    
('Rogers Centre', 50000, 5),     
('BC Place', 54000, 6),          
('Olympiastadion', 74000, 7),    
('Parc des Princes', 48000, 8), 
('Tokyo Dome', 55000, 9),       
('FNB Stadium', 90000, 10);      
GO


-- 4. Teams (FIXED CountryID)
INSERT INTO Teams (TeamName, CoachName, CountryID) VALUES
('USA Men', 'Gregg Cheddar', 1),
('Japan Men', 'Hajime Vieux-Boulogne', 2),   
('Brazil Men', 'Tite', 3),                  
('Mexico Men', 'Gerardo Fetta', 4),         
('Germany Men', 'Hansi Blau', 5),
('France Men', 'Didier Gouda', 6),
('Spain Men', 'Luis Parmasean', 7),
('Argentina Men', 'Lionel Cottage', 8),
('Canada Men', 'John Mozzarella', 9),       
('South Africa Men', 'Hugo Brie', 10);
GO


-- 5. Players (unchanged – already valid)
INSERT INTO Players (FirstName, LastName, DateOfBirth, Initials, Position, JerseyNumber, Goals, TeamID) VALUES
('Mark', 'Ruffalo', '1998-09-18', 'MR', 'Forward', 10, 15, 1),
('Henry', 'Cavil', '2002-11-13', 'HC', 'Midfielder', 7, 6, 1),
('Anthony', 'Proshcuto', '2000-11-02', 'AP', 'Defender', 19, 3, 2),
('Davy', 'Jones', '2000-01-14', 'DJ', 'Forward', 10, 10, 2),
('Jack', 'Sparrow', '1995-07-30', 'JS', 'Forward', 11, 12, 3),
('Bruce', 'Wayne', '1991-05-05', 'BW', 'Forward', 9, 8, 3),
('Clark', 'Kent', '1992-02-05', 'CK', 'Forward', 10, 25, 4),
('Razz', 'Alguhl', '1992-02-23', 'RA', 'Midfielder', 5, 4, 4),
('Tom', 'Holland', '1996-03-06', 'TH', 'Forward', 11, 18, 5),
('Lionel', 'Messi', '1995-02-08', 'LM', 'Midfielder', 6, 5, 5);
GO


-- 6. Matches (unchanged – now valid because StadiumIDs are correct)
INSERT INTO Matches (MatchDate, KickoffTime, Stage, StadiumID, PlayerOfTheMatch) VALUES
('2026-06-15','18:00','Group Stage',1,1),
('2026-06-16','21:00','Group Stage',2,4),
('2026-06-17','19:00','Group Stage',3,5),
('2026-06-18','20:00','Group Stage',4,7),
('2026-06-19','17:00','Group Stage',5,9),
('2026-06-20','18:00','Round of 16',6,2),
('2026-06-21','21:00','Round of 16',7,3),
('2026-06-22','19:00','Quarter Final',8,6),
('2026-06-23','20:00','Quarter Final',9,8),
('2026-06-24','17:00','Semi Final',10,10);
GO
GO

-- 7. MatchLineUp (associating matches with teams)

INSERT INTO MatchLineUp (MatchID, TeamID) VALUES
(1,1),(1,3),
(2,2),(2,4),
(3,3),(3,1),
(4,4),(4,2),
(5,5),(5,6),
(6,6),(6,7),
(7,7),(7,8),
(8,8),(8,9),
(9,9),(9,10),
(10,10),(10,1);
GO

-- 8. Fans

INSERT INTO Fans (FirstName, LastName, Email) VALUES
('Sammy','Doe','sammy.doe@email.com'),
('Tobey','Mcguire','toby.mcguire@email.com'),
('Norman','Reedus','norman.reedus@email.com'),
('Emily','Blunt','emily.blunt@email.com'),
('Elle','Fanning','Elle.Fanning@email.com'),
('Tim','Burton','tim.burton@email.com'),
('David','Bouwie','david.bouwie@email.com'),
('Laura','Taylor','laura.taylor@email.com'),
('Armand','Bosman','armand.bosman@email.com'),
('Emma','Stone','emma.stone@email.com');
GO

-- 9. Tickets

INSERT INTO Tickets (MatchID, FanID, SeatNumber, Price) VALUES
(1,1,'A1',120.00),
(1,2,'A2',120.00),
(1,3,'A3',120.00),
(2,4,'B1',100.00),
(2,5,'B2',100.00),
(2,6,'B3',100.00),
(3,7,'C1',80.00),
(3,8,'C2',80.00),
(3,9,'C3',80.00),
(4,10,'D1',150.00);
GO

-- ============================================
-- File: 03_Views.sql
-- Description: 4 Views for FIFAWorldCup2026
-- ============================================

USE FIFAWorldCup2026;
GO

-- 1. vw_TeamPlayers
-- List all players with their team and country

CREATE VIEW vw_TeamPlayers AS
SELECT 
    t.TeamName,
    c.CountryName,
    p.FirstName,
    p.LastName,
    p.Position,
    p.JerseyNumber,
    p.Goals
FROM Players p
JOIN Teams t ON p.TeamID = t.TeamID
JOIN Country c ON t.CountryID = c.CountryID;
GO

-- 2. vw_MatchDetails
-- Show match info with stadium, city, stage, and player of the match

CREATE VIEW vw_MatchDetails AS
SELECT 
    m.MatchID,
    m.MatchDate,
    m.KickoffTime,
    m.Stage,
    s.StadiumName,
    ci.CityName,
    p.FirstName + ' ' + p.LastName AS PlayerOfTheMatch
FROM Matches m
JOIN Stadium s ON m.StadiumID = s.StadiumID
JOIN Cities ci ON s.CityID = ci.CityID
LEFT JOIN Players p ON m.PlayerOfTheMatch = p.PlayerID;
GO

-- 3. vw_TeamMatchSchedule
-- List all matches a team participates in (using MatchLineUp)

CREATE VIEW vw_TeamMatchSchedule AS
SELECT 
    t.TeamName,
    m.MatchID,
    m.MatchDate,
    m.KickoffTime,
    m.Stage,
    s.StadiumName
FROM MatchLineUp ml
JOIN Teams t ON ml.TeamID = t.TeamID
JOIN Matches m ON ml.MatchID = m.MatchID
JOIN Stadium s ON m.StadiumID = s.StadiumID;
GO

-- 4. vw_TicketSales
-- Show which fan bought which ticket for which match

CREATE VIEW vw_TicketSales AS
SELECT 
    f.FirstName + ' ' + f.LastName AS FanName,
    f.Email,
    tkt.TicketID,
    m.MatchID,
    m.MatchDate,
    m.Stage,
    s.StadiumName,
    tkt.SeatNumber,
    tkt.Price
FROM Tickets tkt
JOIN Fans f ON tkt.FanID = f.FanID
JOIN Matches m ON tkt.MatchID = m.MatchID
JOIN Stadium s ON m.StadiumID = s.StadiumID;
GO

-- ============================================
-- File: 04_Queries.sql
-- ============================================

USE FIFAWorldCup2026;
GO

CREATE VIEW vw_MatchInfo AS
SELECT
    m.MatchID,
    m.MatchDate,
    m.KickoffTime,
    m.Stage,
    m.StadiumID,
    s.StadiumName,
    c.CityName
FROM Matches m
INNER JOIN Stadium s ON m.StadiumID = s.StadiumID
INNER JOIN Cities c ON s.CityID = c.CityID;
GO

CREATE OR ALTER FUNCTION dbo.MatchDay (@MatchDate DATE, @KickoffTime TIME)
RETURNS NVARCHAR(50)
AS
BEGIN
    RETURN CONVERT(VARCHAR, @MatchDate, 103) + ' at ' + LEFT(CONVERT(VARCHAR, @KickoffTime, 108), 5);
END
GO

CREATE OR ALTER FUNCTION dbo.GetFixture (@MatchID INT)
RETURNS NVARCHAR(100)
AS
BEGIN
    DECLARE @Team1 NVARCHAR(50);
    DECLARE @Team2 NVARCHAR(50);

    SET @Team1 = (
        SELECT TOP 1 t.TeamName
        FROM MatchLineUp ml
        INNER JOIN Teams t ON ml.TeamID = t.TeamID
        WHERE ml.MatchID = @MatchID
        ORDER BY ml.TeamID ASC
    );

    SET @Team2 = (
        SELECT TOP 1 t.TeamName
        FROM MatchLineUp ml
        INNER JOIN Teams t ON ml.TeamID = t.TeamID
        WHERE ml.MatchID = @MatchID
        ORDER BY ml.TeamID DESC
    );

    RETURN @Team1 + ' vs ' + @Team2;
END
GO

WITH MatchDetails AS
(
    SELECT
        mi.MatchID,
        mi.MatchDate,
        mi.KickoffTime,
        mi.Stage,
        mi.StadiumName,
        mi.CityName,
        dbo.GetFixture(mi.MatchID) AS Fixture
    FROM vw_MatchInfo mi
),
TrackMatches AS
(
    SELECT
        MatchID,
        Fixture,
        dbo.MatchDay(MatchDate, KickoffTime) AS [Match Day],
        Stage,
        StadiumName AS Venue,
        CityName AS City
    FROM MatchDetails
)
SELECT * FROM TrackMatches
ORDER BY [Match Day];
GO

CREATE VIEW vw_PlayerInfo AS
SELECT
    p.PlayerID,
    p.FirstName,
    p.LastName,
    p.DateOfBirth,
    DATEDIFF(YEAR, p.DateOfBirth, '2026-07-19') AS Age,
    p.Goals,
    t.TeamName AS [Team Name],
    p.Position,
    p.JerseyNumber
FROM Players p
INNER JOIN Teams t ON p.TeamID = t.TeamID;
GO

CREATE VIEW vw_HighestGoalScorer AS
SELECT
    FirstName,
    LastName,
    [Team Name],
    Position,
    Goals AS [Total Goals Scored]
FROM vw_PlayerInfo;
GO

CREATE VIEW vw_MostPlayerOfTheMatch AS
SELECT
    pi.FirstName,
    pi.LastName,
    pi.[Team Name],
    COUNT(m.PlayerOfTheMatch) AS [Player Of The Match Awards]
FROM vw_PlayerInfo pi
LEFT JOIN Matches m ON m.PlayerOfTheMatch = pi.PlayerID
GROUP BY
    pi.PlayerID,
    pi.FirstName,
    pi.LastName,
    pi.[Team Name];
GO

WITH PlayerAwards AS
(
    SELECT
        pi.PlayerID,
        pi.FirstName,
        pi.LastName,
        pi.[Team Name],
        pi.Age,
        pi.Goals,
        COUNT(m.PlayerOfTheMatch) AS [Man Of The Match Awards]
    FROM vw_PlayerInfo pi
    LEFT JOIN Matches m ON m.PlayerOfTheMatch = pi.PlayerID
    WHERE pi.Age < 23
    GROUP BY
        pi.PlayerID,
        pi.FirstName,
        pi.LastName,
        pi.[Team Name],
        pi.Age,
        pi.Goals
),
BestYoungPlayer AS
(
    SELECT
        FirstName,
        LastName,
        [Team Name],
        Age,
        Goals,
        [Man Of The Match Awards],
        (Goals * 2) + [Man Of The Match Awards] AS [Performance Score]
    FROM PlayerAwards
)
SELECT * FROM BestYoungPlayer
ORDER BY [Performance Score] DESC, Age ASC;
GO

CREATE OR ALTER PROC sp_GetPlayerStats
    @ChooseTypeOfStats INT
AS
BEGIN
    IF @ChooseTypeOfStats = 1
    BEGIN
        SELECT * FROM vw_HighestGoalScorer
        ORDER BY [Total Goals Scored] DESC;
    END
    ELSE IF @ChooseTypeOfStats = 2
    BEGIN
        SELECT * FROM vw_MostPlayerOfTheMatch
        ORDER BY [Player Of The Match Awards] DESC;
    END
    ELSE IF @ChooseTypeOfStats = 3
    BEGIN
        SELECT * FROM vw_PlayerInfo
        ORDER BY [Team Name], LastName;
    END
    ELSE
    BEGIN
        PRINT 'Invalid choice. Select 1 (Highest Goal Scorers), 2 (Most Player Of The Match Awards), or 3 (All Player Stats).';
    END
END
GO

CREATE OR ALTER PROC sp_PurchaseTicket
    @MatchID INT,
    @FanID INT,
    @SeatNumber NVARCHAR(50)
AS
BEGIN
    DECLARE @Price MONEY = (
        SELECT
            CASE Stage
                WHEN 'Final' THEN 750
                WHEN 'Semi Final' THEN 500
                WHEN 'Quarter Final' THEN 350
                ELSE 200
            END
        FROM Matches
        WHERE MatchID = @MatchID
    );

    IF (SELECT COUNT(*) FROM Tickets WHERE MatchID = @MatchID) >=
       (SELECT s.Capacity FROM Stadium s JOIN Matches m ON s.StadiumID = m.StadiumID WHERE m.MatchID = @MatchID)
    BEGIN
        PRINT 'Tickets sold out';
    END
    ELSE
    BEGIN
        INSERT INTO Tickets (MatchID, FanID, SeatNumber, Price)
        VALUES (@MatchID, @FanID, @SeatNumber, @Price);
        PRINT 'Ticket purchased successfully';
    END
END
GO

CREATE VIEW vw_FanAttendance AS
SELECT
    mi.MatchID,
    mi.MatchDate,
    mi.KickoffTime,
    mi.StadiumName,
    mi.Stage,
    COUNT(t.TicketID) AS Attendance
FROM vw_MatchInfo mi
LEFT JOIN Tickets t ON mi.MatchID = t.MatchID
GROUP BY
    mi.MatchID,
    mi.MatchDate,
    mi.KickoffTime,
    mi.StadiumName,
    mi.Stage;
GO

WITH TicketCount AS
(
    SELECT
        mi.MatchID,
        mi.MatchDate,
        mi.Stage,
        mi.StadiumName,
        s.Capacity,
        COUNT(t.TicketID) AS TicketsSold
    FROM vw_MatchInfo mi
    LEFT JOIN Tickets t ON mi.MatchID = t.MatchID
    JOIN Stadium s ON mi.StadiumID = s.StadiumID
    GROUP BY
        mi.MatchID,
        mi.MatchDate,
        mi.Stage,
        mi.StadiumName,
        s.Capacity
),
AttendanceReport AS
(
    SELECT
        MatchID,
        MatchDate,
        Stage,
        StadiumName,
        Capacity,
        TicketsSold,
        Capacity - TicketsSold AS SeatsRemaining,
        CAST(TicketsSold * 100.0 / Capacity AS DECIMAL(5,2)) AS PercentFull
    FROM TicketCount
)
SELECT * FROM AttendanceReport
ORDER BY MatchDate;
GO

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

-- ==========================================================
-- AUTHENTICATION & SECURITY 
-- ==========================================================

-- In case it happens that  we need to run this script more than once, drop the user and login first so it doesn't crash
IF DATABASE_PRINCIPAL_ID('TicketStaff_User') IS NOT NULL
    DROP USER TicketStaff_User;
GO

IF SUSER_ID('TicketStaff_Login') IS NOT NULL
    DROP LOGIN TicketStaff_Login;
GO

-- Create login for ticketing staff
CREATE LOGIN TicketStaff_Login WITH PASSWORD = 'Fifa_Tickets_DB26@';
GO

-- Give that login access to our specific World Cup database
CREATE USER TicketStaff_User FOR LOGIN TicketStaff_Login;
GO

-- Provide access to see and add stuff to Fans and Tickets, nothing else 
GRANT SELECT, INSERT, UPDATE ON Fans TO TicketStaff_User;
GRANT SELECT, INSERT, UPDATE ON Tickets TO TicketStaff_User;

-- Makes sure the staff cannot accidentally delete a fan's record or a ticket that has been purchased
DENY DELETE ON Fans TO TicketStaff_User;
DENY DELETE ON Tickets TO TicketStaff_User;
GO

-- ==========================================================
-- ENCRYPTION (Protecting Fan Data)
-- ==========================================================

-- Add a VARBINARY column to store the encrypted emails
ALTER TABLE Fans 
ADD Encrypted_Email VARBINARY(MAX);
GO

-- Encrypt emails with a passphrase
UPDATE Fans
SET Encrypted_Email = ENCRYPTBYPASSPHRASE('WC_2026_Fan_Data_Secure_Key!', Email);
GO

-- The original Email column is intentionally kept so the views don't break. 
-- ALTER TABLE Fans DROP COLUMN Email; 
-- GO

-- ==========================================================
-- TRANSACTIONS (Booking a Ticket)
-- ==========================================================

BEGIN TRY
    BEGIN TRANSACTION;

    -- Add new fan profile
    INSERT INTO Fans (FirstName, LastName, Email)
    VALUES ('Sipho', 'Nkosi', 'sipho.nkosi@email.com');

    -- Get the ID of the fan we just inserted
    DECLARE @NewFanID INT = SCOPE_IDENTITY();

    -- Book a ticket for them for Match 1
    INSERT INTO Tickets (MatchID, FanID, SeatNumber, Price)
    VALUES (1, @NewFanID, 'D2', 250.00);

    -- Save all changes if everything worked
    COMMIT TRANSACTION;
    PRINT 'Success: Fan profile created and ticket booked.';

END TRY
BEGIN CATCH
    -- Cancel everything if an error occurs so we don't get half saved data
    ROLLBACK TRANSACTION;
    PRINT 'Error: Transaction failed and was rolled back.';
    PRINT ERROR_MESSAGE();
END CATCH;
GO

-- ==========================================================
-- TRIGGERS (Auto-format Player Initials)
-- ==========================================================

-- Create a trigger that watches the Players table for any new or updated records
CREATE OR ALTER TRIGGER trg_FormatInitials
ON Players
AFTER INSERT, UPDATE
AS
BEGIN
    -- Prevent extra system messages which might slow down the server
    SET NOCOUNT ON;

    UPDATE Players
    SET Initials = UPPER(i.Initials)
    FROM Players p
    INNER JOIN inserted i ON p.PlayerID = i.PlayerID;
END;
GO

-- ==========================================================
-- CURSORS (Stadium Capacity Report)
-- ==========================================================

SET NOCOUNT ON;

DECLARE @venue_name NVARCHAR(100);
DECLARE @max_seats INT;

DECLARE stadium_cursor CURSOR FOR
SELECT StadiumName, Capacity FROM Stadium;

OPEN stadium_cursor;
FETCH NEXT FROM stadium_cursor INTO @venue_name, @max_seats;

PRINT '--- 2026 WORLD CUP VENUE CHECK ---';

-- Keep looping as long as there is still data to read (status 0 means success)
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Venue: ' + @venue_name + ' | Capacity: ' + CAST(@max_seats AS NVARCHAR(20));
    
    FETCH NEXT FROM stadium_cursor INTO @venue_name, @max_seats;
END;

-- Clean up the memory
CLOSE stadium_cursor;
DEALLOCATE stadium_cursor;
GO

-- ==========================================================
-- DATABASE BACKUP 
-- ==========================================================

BACKUP DATABASE FIFAWorldCup2026
TO DISK = 'C:\Temp\FIFAWorldCup2026_Final.bak'
WITH FORMAT,
NAME = 'World Cup 2026 Complete Backup';
GO
