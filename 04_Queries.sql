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
