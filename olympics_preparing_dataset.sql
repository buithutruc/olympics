DROP TABLE IF EXISTS ATHLETE_EVENTS;
CREATE TABLE IF NOT EXISTS ATHLETE_EVENTS
(
    id          INT,
    name        VARCHAR,
    sex         VARCHAR,
    age         VARCHAR,
    height      VARCHAR,
    weight      VARCHAR,
    team        VARCHAR,
    noc         VARCHAR,
    games       VARCHAR,
    year        INT,
    season      VARCHAR,
    city        VARCHAR,
    sport       VARCHAR,
    event       VARCHAR,
    medal       VARCHAR
);

DROP TABLE IF EXISTS OLYMPICS_NOC_REGIONS;
CREATE TABLE IF NOT EXISTS OLYMPICS_NOC_REGIONS
(
    noc         VARCHAR,
    region      VARCHAR,
    notes       VARCHAR
);

select count(1) from athlete_events ae 
select * from olympics_noc_regions onr 