
-- CREATE LOGIN NandaSurendra
-- WITH PASSWORD = 'MI$T353Instructor';

-- CREATE USER NandaSurendra

-- FOR LOGIN NandaSurendra;

-- ALTER ROLE db_owner ADD MEMBER NandaSurendra;



if object_id('PunterStats') is not null 
    drop table PunterStats;
if object_id('KickerStats') is not null 
    drop table KickerStats;
if object_id('ReturnerStats') is not null 
    drop table ReturnerStats;
if object_id('DefenderStats') is not null 
    drop table DefenderStats;
if object_id('RBStats') is not null 
    drop table RBStats;
if object_id('QBStats') is not null 
    drop table QBStats;
if object_id('PlayerStats') is not null 
    drop table PlayerStats;
if object_id('RosterPlayer') is not null 
    drop table RosterPlayer;
if object_id('Roster') is not null 
    drop table Roster;
if object_id('PlayerPosition') is not null 
    drop table PlayerPosition;
if object_id('Player') is not null 
    drop table Player;
if object_id('Game') is not null
    drop table Game;
if object_id('Team') is not null
    drop table Team;
if object_id('Stadium') is not null
    drop table Stadium;



go 

create table Stadium (
    StadiumID INT NOT NULL IDENTITY(1,1),
    StadiumName VARCHAR(50) NOT NULL,
    StadiumStreetAddress VARCHAR(100) NOT NULL,
    StadiumCity VARCHAR(50) NOT NULL,
    StadiumState CHAR(2) NOT NULL,
    StadiumCapacity INT NOT NULL,
    TypeofField VARCHAR(50) NOT NULL,
    constraint PK_Stadium PRIMARY KEY (StadiumID),
    constraint UQ_StadiumName UNIQUE (StadiumName, StadiumCity, StadiumState),
    constraint CK_TypeofField CHECK (TypeofField IN ('Grass', 'Artificial Turf'))
);


go

CREATE table Team (
    TeamID INT NOT NULL IDENTITY(1,1),
    UniversityName VARCHAR(50) NOT NULL,
    TeamName VARCHAR(50) NOT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Team PRIMARY KEY (TeamID),
    constraint UQ_UniversityName UNIQUE (UniversityName),
    constraint FK_Team_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);



go

CREATE table Game (
    GameID INT NOT NULL IDENTITY(1,1),
    GameDate Date NOT NULL,
    GameTime Time NOT NULL,
    HomeScore INT NULL,
    AwayScore INT NULL,
    HomeTeamID INT NOT NULL,
    AwayTeamID INT NOT NULL,
    WinnerTeamID INT NULL,
    StadiumID INT NOT NULL,
    constraint PK_Game PRIMARY KEY (GameID),
    constraint UQ_Game UNIQUE (HomeTeamID, GameDate, GameTime),
    constraint FK_Game_HomeTeam FOREIGN KEY (HomeTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_AwayTeam FOREIGN KEY (AwayTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_WinnerTeam FOREIGN KEY (WinnerTeamID) REFERENCES Team(TeamID),
    constraint FK_Game_Stadium FOREIGN KEY (StadiumID) REFERENCES Stadium(StadiumID)
);

go


CREATE table Position (
    PositionID INT NOT NULL IDENTITY(1,1),
    PositionName VARCHAR(20) NOT NULL,
    constraint PK_Position PRIMARY KEY (PositionID),
    constraint UQ_PositionName UNIQUE (PositionName),
    constraint CK_PositionName CHECK (PositionName IN ('QB', 'RB', 'Defender', 'Returner', 'Kicker', 'Punter'))
);

go

CREATE table Player (
    PlayerID INT NOT NULL IDENTITY(1,1),
    PlayerName VARCHAR(100) NOT NULL,
    PlayerDateOfBirth DATE NOT NULL,
    constraint PK_Player PRIMARY KEY (PlayerID),
    constraint UQ_Player UNIQUE (PlayerName, PlayerDateOfBirth)
);

go 

CREATE table Roster (
    RosterID INT NOT NULL IDENTITY(1,1),
    TeamID INT NOT NULL,
    RosterYear INT NOT NULL,
    SeasonWins INT NOT NULL DEFAULT 0,
    SeasonLosses INT NOT NULL DEFAULT 0,
    SeasonTies INT NOT NULL DEFAULT 0,
    constraint PK_Roster PRIMARY KEY (RosterID),
    constraint UQ_Roster UNIQUE (TeamID, RosterYear),
    constraint FK_Roster_Team FOREIGN KEY (TeamID) REFERENCES Team(TeamID),
    constraint CK_Roster_Record CHECK (SeasonWins >= 0 AND SeasonLosses >= 0 AND SeasonTies >= 0)
);

go 

create table PlayerStats (
    PlayerStatsID INT NOT NULL IDENTITY(1,1),
    PlayerID INT NOT NULL,
    GameID INT NOT NULL,
    PositionID INT NOT NULL,
    constraint PK_PlayerStats PRIMARY KEY (PlayerStatsID),
    constraint UQ_PlayerStats UNIQUE (PlayerID, GameID, PositionID),
    constraint FK_PlayerStats_Player FOREIGN KEY (PlayerID) REFERENCES Player(PlayerID),
    constraint FK_PlayerStats_Game FOREIGN KEY (GameID) REFERENCES Game(GameID),
    constraint FK_PlayerStats_Position FOREIGN KEY (PositionID) REFERENCES Position(PositionID)
);

go 

CREATE table QBStats (
    QBStatsID INT NOT NULL,
    Attempts INT NOT NULL DEFAULT 0,
    Completions INT NOT NULL DEFAULT 0,
    Yards INT NOT NULL DEFAULT 0,
    TDs INT NOT NULL DEFAULT 0,
    INTs INT NOT NULL DEFAULT 0,
    constraint PK_QBStats PRIMARY KEY (QBStatsID),
    constraint FK_QBStats_PlayerStats FOREIGN KEY (QBStatsID) REFERENCES PlayerStats(PlayerStatsID),
    constraint CK_QBStats CHECK (Attempts >= 0 AND Completions >= 0
        AND Completions <= Attempts AND TDs >= 0 AND INTs >= 0)
);

go 

create table RBStats (
    RBStatsID INT NOT NULL,
    Carries INT NOT NULL DEFAULT 0,
    Yards INT NOT NULL DEFAULT 0,
    TDs INT NOT NULL DEFAULT 0,
    Long INT NOT NULL DEFAULT 0,
    Fumbles INT NOT NULL DEFAULT 0,
    constraint PK_RBStats PRIMARY KEY (RBStatsID),
    constraint FK_RBStats_PlayerStats FOREIGN KEY (RBStatsID) REFERENCES PlayerStats(PlayerStatsID),
    constraint CK_RBStats CHECK (Carries >= 0 AND TDs >= 0 AND Fumbles >= 0)
);

go

create table DefenderStats (
    DefenderStatsID INT NOT NULL,
    Tackles INT NOT NULL DEFAULT 0,
    -- half sack is possible, so decimal(4,1) is used
    Sacks DECIMAL(4,1) NOT NULL DEFAULT 0, 
    Interceptions INT NOT NULL DEFAULT 0,
    DefensiveTDs INT NOT NULL DEFAULT 0,
    constraint PK_DefenderStats PRIMARY KEY (DefenderStatsID),
    constraint FK_DefenderStats_PlayerStats FOREIGN KEY (DefenderStatsID) REFERENCES PlayerStats(PlayerStatsID),
    constraint CK_DefenderStats CHECK (Tackles >= 0 AND Sacks >= 0
        AND Interceptions >= 0 AND DefensiveTDs >= 0)
);

go 

CREATE table ReturnerStats (
    ReturnerStatsID INT NOT NULL,
    KickOffAttempts INT NOT NULL DEFAULT 0,
    KickOffYards INT NOT NULL DEFAULT 0,
    KickOffLong INT NOT NULL DEFAULT 0,
    KickOffTDs INT NOT NULL DEFAULT 0,
    PuntReturnAttempts INT NOT NULL DEFAULT 0,
    PuntReturnYards INT NOT NULL DEFAULT 0,
    PuntReturnLong INT NOT NULL DEFAULT 0,
    PuntReturnTDs INT NOT NULL DEFAULT 0,
    constraint PK_ReturnerStats PRIMARY KEY (ReturnerStatsID),
    constraint FK_ReturnerStats_PlayerStats FOREIGN KEY (ReturnerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    constraint CK_ReturnerStats CHECK (KickOffAttempts >= 0 AND KickOffTDs >= 0
        AND PuntReturnAttempts >= 0 AND PuntReturnTDs >= 0)
);

go 

CREATE table KickerStats (
    KickerStatsID INT NOT NULL,
    FieldGoalAttempts INT NOT NULL DEFAULT 0,
    FieldGoalsMade INT NOT NULL DEFAULT 0,
    Long INT NOT NULL DEFAULT 0,
    ExtraPointAttempts INT NOT NULL DEFAULT 0,
    ExtraPointsMade INT NOT NULL DEFAULT 0,
    constraint PK_KickerStats PRIMARY KEY (KickerStatsID),
    constraint FK_KickerStats_PlayerStats FOREIGN KEY (KickerStatsID) REFERENCES PlayerStats(PlayerStatsID),
    constraint CK_KickerStats CHECK (FieldGoalAttempts >= 0 AND FieldGoalsMade >= 0
        AND FieldGoalsMade <= FieldGoalAttempts AND ExtraPointAttempts >= 0
        AND ExtraPointsMade >= 0 AND ExtraPointsMade <= ExtraPointAttempts)
);

go 

CREATE table PunterStats (
    PunterStatsID INT NOT NULL,
    Punts INT NOT NULL DEFAULT 0,
    Yards INT NOT NULL DEFAULT 0,
    Long INT NOT NULL DEFAULT 0,
    constraint PK_PunterStats PRIMARY KEY (PunterStatsID),
    constraint FK_PunterStats_PlayerStats FOREIGN KEY (PunterStatsID) REFERENCES PlayerStats(PlayerStatsID),
    constraint CK_PunterStats CHECK (Punts >= 0 AND Yards >= 0 AND Long >= 0)
);