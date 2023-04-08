
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




