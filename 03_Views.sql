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