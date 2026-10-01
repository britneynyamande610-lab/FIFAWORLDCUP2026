-- ============================================
-- File: 02_InsertData.sql
-- Description: Populate all tables with sample data
-- ============================================

USE FIFAWorldCup2026;
GO

-- 1. Countries

INSERT INTO Country (CountryName, Continent) VALUES
('USA', 'North America'),
('Canada', 'North America'),
('Mexico', 'North America'),
('Brazil', 'South America'),
('Germany', 'Europe'),
('France', 'Europe'),
('Spain', 'Europe'),
('Argentina', 'South America'),
('Japan', 'Asia'),
('South Africa', 'Africa');
GO

-- 2. Cities

INSERT INTO Cities (CityName, CountryID) VALUES
('New York', 1),
('Los Angeles', 1),
('Toronto', 2),
('Vancouver', 2),
('Mexico City', 3),
('Guadalajara', 3),
('Berlin', 5),
('Paris', 6),
('Tokyo', 9),
('Johannesburg', 10);
GO

-- 3. Stadiums

INSERT INTO Stadium (StadiumName, Capacity, CityID) VALUES
('MetLife Stadium', 80000, 1),
('SoFi Stadium', 70000, 2),
('Rogers Centre', 50000, 3),
('BC Place', 54000, 4),
('Azteca Stadium', 87000, 5),
('Akron Stadium', 46000, 6),
('Olympiastadion', 74000, 7),
('Parc des Princes', 48000, 8),
('Tokyo Dome', 55000, 9),
('FNB Stadium', 90000, 10);
GO

-- 4. Teams

INSERT INTO Teams (TeamName, CoachName, CountryID) VALUES
('USA Men', 'Gregg Berhalter', 1),
('Canada Men', 'John Herdman', 2),
('Mexico Men', 'Gerardo Martino', 3),
('Brazil Men', 'Tite', 4),
('Germany Men', 'Hansi Flick', 5),
('France Men', 'Didier Deschamps', 6),
('Spain Men', 'Luis Enrique', 7),
('Argentina Men', 'Lionel Scaloni', 8),
('Japan Men', 'Hajime Moriyasu', 9),
('South Africa Men', 'Hugo Broos', 10);
GO

-- 5. Players

INSERT INTO Players (FirstName, LastName, DateOfBirth, Initials, Position, JerseyNumber, Goals, TeamID) VALUES
('Christian', 'Pulisic', '1998-09-18', 'CP', 'Forward', 10, 15, 1),
('Giovanni', 'Reyna', '2002-11-13', 'GR', 'Midfielder', 7, 6, 1),
('Alphonso', 'Davies', '2000-11-02', 'AD', 'Defender', 19, 3, 2),
('Jonathan', 'David', '2000-01-14', 'JD', 'Forward', 10, 10, 2),
('Hirving', 'Lozano', '1995-07-30', 'HL', 'Forward', 11, 12, 3),
('Raul', 'Jimenez', '1991-05-05', 'RJ', 'Forward', 9, 8, 3),
('Neymar', 'Jr', '1992-02-05', 'NJ', 'Forward', 10, 25, 4),
('Casemiro', 'Silva', '1992-02-23', 'CS', 'Midfielder', 5, 4, 4),
('Timo', 'Werner', '1996-03-06', 'TW', 'Forward', 11, 18, 5),
('Joshua', 'Kimmich', '1995-02-08', 'JK', 'Midfielder', 6, 5, 5);
GO

-- 6. Matches

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
('John','Doe','john.doe@email.com'),
('Jane','Smith','jane.smith@email.com'),
('Michael','Brown','michael.brown@email.com'),
('Emily','Davis','emily.davis@email.com'),
('Chris','Johnson','chris.johnson@email.com'),
('Sarah','Wilson','sarah.wilson@email.com'),
('David','Lee','david.lee@email.com'),
('Laura','Taylor','laura.taylor@email.com'),
('James','Anderson','james.anderson@email.com'),
('Emma','Thomas','emma.thomas@email.com');
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