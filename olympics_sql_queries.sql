
-- LIST OF SQL QUERIES:

-- Identify the sport which was played in all summer olympics.
with t1 as (
	select count(distinct games) as total_summer_games
	from athlete_events ae 
	where season='Summer'),
t2 as (
	select distinct sport, games
	from athlete_events ae 
	where season='Summer'
	order by games
),
t3 as (
	select sport, count(games) as no_of_games
	from t2
	group by sport
)
select * from t3 join t1 on t1.total_summer_games = t3.no_of_games;


-- Fetch the top 5 athletes who have won the most gold medals.
with t1 as (
	select ae.name, ae.team, count(medal) as no_of_gold_medals
	from athlete_events ae 
	where medal = 'Gold'
	group by ae.name, ae.team
	order by no_of_gold_medals desc
),
t2 as (
	select * , dense_rank() over(order by no_of_gold_medals desc) as athlete_rank
	from t1
)
select * from t2 where athlete_rank <= 5;


-- List down total gold, silver and broze medals won by each country.
select * from athlete_events ae where medal <> 'NA'

select onr.region as country, medal, count(1) as total_medals
from athlete_events ae 
join olympics_noc_regions onr on ae.noc = onr.noc 
where medal <> 'NA'
group by country, medal
order by country, medal

create extension tablefunc; -- to use crosstab function

select country, coalesce(gold, 0) as gold, coalesce (silver,0) as silver, coalesce (bronze, 0) as bronze
from crosstab('select onr.region as country, medal, count(1) as total_medals
from athlete_events ae 
join olympics_noc_regions onr on ae.noc = onr.noc 
where medal <> ''NA''
group by country, medal
order by country, medal', 'values(''Bronze''),(''Gold''),(''Silver'')') 
as result(country varchar, bronze bigint, gold bigint, silver bigint)
order by gold desc, silver desc, bronze desc;


-- Identify which country won the most gold, most silver and most bronze medals in each olympic games.
with temp as (select substring(games_country, 1, position(' - ' in games_country) - 1) as games,
substring(games_country, position(' - ' in games_country) + 3) as country,
coalesce(gold, 0) as gold, 
coalesce (silver,0) as silver, 
coalesce (bronze, 0) as bronze
from crosstab('select concat(games, '' - '', onr.region) as games_country, medal, count(1) as total_medals
from athlete_events ae 
join olympics_noc_regions onr on ae.noc = onr.noc 
where medal <> ''NA''
group by games, onr.region, medal
order by games, onr.region, medal', 'values(''Bronze''),(''Gold''),(''Silver'')') 
as result(games_country varchar, bronze bigint, gold bigint, silver bigint)
order by games_country)

select distinct games,
concat(first_value(country) over(partition by games order by gold desc), ' - ',first_value(gold) over(partition by games order by gold desc)) as gold,
concat(first_value(country) over(partition by games order by silver desc), ' - ',first_value(silver) over(partition by games order by silver desc)) as silver,
concat(first_value(country) over(partition by games order by bronze desc), ' - ',first_value(bronze) over(partition by games order by bronze desc)) as bronze
from temp
order by games;




