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
    SeatNumber INT NOT NULL,
    Price MONEY NOT NULL CHECK (Price >= 0),
    CONSTRAINT UQ_Ticket UNIQUE (MatchID, SeatNumber),
    FOREIGN KEY (MatchID) REFERENCES Matches(MatchID),
    FOREIGN KEY (FanID) REFERENCES Fans(FanID)
);
GO