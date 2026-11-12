

go 

create or alter procedure procScheduleGame
(
    -- @ Symbol to differentiate between a parameter and a column name.
    @homeTeamID int,
    @awayTeamID int,
    @gameDate date,
    @gameStartTime time,
    @stadiumID int,
    @gameID int output
)
as
begin

    insert into Game(homeTeamID, awayTeamID, gameDate, gameTime, stadiumID)
    values(@homeTeamID, @awayTeamID, @gameDate, @gameStartTime, @stadiumID);
   
    set @gameID = SCOPE_IDENTITY();

end;

/*
declare @gameID int;
execute procScheduleGame @homeTeamID = 1, @awayTeamID = 2, @gameDate = '2026-11-14', @gameStartTime = '19:00:00', @stadiumID = 1, @gameID = @gameID output;
print @gameID;
*/

-- execute procGetAllTeamsInAConference @ConferenceName = 'Big 12';
-- go

-- -- Optionality for user input.
-- create or alter procedure procGetAllTeamsByConference
-- (
--     @ConferenceName nvarchar(50) = null
-- )
-- as
-- begin 
--     select UniversityName, TeamName
--     from Conference C inner join Team T 
--     on T.ConferenceID = C.ConferenceID
--     --where c.ConferenceName = @ConferenceName;
--     where ConferenceName = @ConferenceName;
--     end;
   -- execute procGetAllTeamsByConference @ConferenceName = 'Big 12';
   -- execute procGetAllTeamsByConference