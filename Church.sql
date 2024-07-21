select *
from Church..INCOME



''' DATA CLEANING'''

update  income
set date = cast(date as date)

update INCOME
set date = CONVERT(date,date)

select [SINGING BAND], [ANNUAL HARVEST]
from INCOME

ALTER TABLE income
add [CONVERTED DATE] DATE


update  income
set [CONVERTED DATE] = CONVERT(date,date)

ALTER TABLE income
add [SINGING BAND alt] float

update  income
set [SINGING BAND] = 0
WHERE [SINGING BAND] IS NULL

ALTER TABLE income
add [ANNUAL HARVEST alt] float

update  income
set [ANNUAL HARVEST] = 0
WHERE [ANNUAL HARVEST] IS NULL


update  income
set [CAMP MEETING] = 0
WHERE [CAMP MEETING] IS NULL

select *
from INCOME




'''CTES $ TEMP TABLES'''

---CONFERENCE FUNDS --cte
with ConfFunds as(
select [CONVERTED DATE] as DATE, TITHE, 
		[SYSTEMATIC OFFERING] * 0.4 as [SYSTEMATIC OFFERING],
		[THANKS OFFERING]*.4 [THANKS OFFERING],
		[LOOSE OFFERING]*.4 [LOOSE OFFERING],
		[ANNUAL HARVEST] * .1 [ANNUAL HARVEST],
		[BIBLE SOCIETY HARVEST] * 0.33 [BIBLE SOCIETY HARVEST]
from income)
select DATE, TITHE, [SYSTEMATIC OFFERING], [THANKS OFFERING], [LOOSE OFFERING], 
	[ANNUAL HARVEST], [BIBLE SOCIETY HARVEST],
	(TITHE +  [SYSTEMATIC OFFERING] + [THANKS OFFERING] +[LOOSE OFFERING] + 
	[ANNUAL HARVEST] + [BIBLE SOCIETY HARVEST]) as TOTAL, COUNT(DATE) AS FREQ
from ConfFunds
--enter date 
where date is not null and  DATE BETWEEN '2021-01-01' AND '2021-03-31'
group by DATE, TITHE, [SYSTEMATIC OFFERING], [THANKS OFFERING], [LOOSE OFFERING], 
	[ANNUAL HARVEST], [BIBLE SOCIETY HARVEST]
having COUNT(date) > 0
order by DATE



--CONFERENCE FUNDS TEMP TABLE
drop table if exists #ConfFunds
create table #ConfFunds(
		Date date, 
		Tithe float,
		Systematic_Offering float,
		Thanks_Offering float,
		Loose_Offering float,
		Annual_Harvest float,
		Bible_Society_Harvest float
		)

select *
from #ConfFunds

alter table #conffunds
add Total float

insert into #ConfFunds
Select cast(DATE as date), 
			TITHE, 
			[SYSTEMATIC OFFERING]*.4, 
			[THANKS OFFERING]*.4,
			[LOOSE OFFERING]*.4,
			[ANNUAL HARVEST]*.1,
			[BIBLE SOCIETY HARVEST]*.33
from INCOME


update #ConfFunds
set Total = Tithe + Systematic_Offering + Thanks_Offering+ Loose_Offering + Annual_Harvest + Bible_Society_Harvest



select cast(date as date) as date, *
from INCOME



--CONFERENCE FUNDS CTE
with ConfFunds as(
select  [CONVERTED DATE] AS DATE,
		Tithe,
		([SYSTEMATIC OFFERING]) * 0.4 as [SYSTEMATIC OFFERING],
		([THANKS OFFERING])*.4 [THANKS OFFERING],
		([LOOSE OFFERING])*.4 [LOOSE OFFERING],
		([ANNUAL HARVEST]) * .4 [ANNUAL HARVEST],
		([BIBLE SOCIETY HARVEST]) * 0.33 [BIBLE SOCIETY HARVEST]
from income)
select date,
	Tithe,
	([SYSTEMATIC OFFERING]),
	([THANKS OFFERING]), 
	([LOOSE OFFERING]), 
	([ANNUAL HARVEST]), 
	([BIBLE SOCIETY HARVEST]),
	(tithe + [SYSTEMATIC OFFERING] + [THANKS OFFERING] +[LOOSE OFFERING] + 
	[ANNUAL HARVEST] + [BIBLE SOCIETY HARVEST]) as TOTAL
from ConfFunds
where date is not null and  DATE BETWEEN '2023-01-01' AND '2023-06-06'
--group by ([SYSTEMATIC OFFERING]), ([THANKS OFFERING]), ([LOOSE OFFERING]), (([BIBLE SOCIETY HARVEST])
order by Date




---DISTRICT FUND
--cte
with distfunds as(
select  [CONVERTED DATE] AS DATE,
		([SYSTEMATIC OFFERING]) * 0.1 as [SYSTEMATIC OFFERING],
		([THANKS OFFERING])*.1 [THANKS OFFERING],
		([LOOSE OFFERING])*.1 [LOOSE OFFERING],
		([ANNUAL HARVEST]) * .1 [ANNUAL HARVEST],
		([BIBLE SOCIETY HARVEST]) * 0.33 [BIBLE SOCIETY HARVEST]
from income)
select DATE, 
	([SYSTEMATIC OFFERING]), 
	([THANKS OFFERING]), 
	([LOOSE OFFERING]), 
	([ANNUAL HARVEST]), 
	([BIBLE SOCIETY HARVEST]),
	([SYSTEMATIC OFFERING] + [THANKS OFFERING] +[LOOSE OFFERING] + 
	[ANNUAL HARVEST] + [BIBLE SOCIETY HARVEST]) as TOTAL
from distfunds
where date is not null
--group by ([SYSTEMATIC OFFERING]), ([THANKS OFFERING]), ([LOOSE OFFERING]), (([BIBLE SOCIETY HARVEST])
order by Date


---DISTRICT TEMPORARY TABLE
drop table if exists #DistrictFund
create table #DistrictFund(
Date date,
Systematic_Offering float,
Thanks_Offering float,
Loose_Offering float,
Annual_Harvest float,
Bible_Society_Harvest float)


select *
from #DistrictFund
where date is not null

drop table if exists #DistrictFund
insert into #DistrictFund
select cast(Date as Date), [SYSTEMATIC OFFERING]*.1, 
		[THANKS OFFERING]*.1, [LOOSE OFFERING]*.1, 
		[ANNUAL HARVEST]*.1, [BIBLE SOCIETY HARVEST]*.33
from INCOME


select *
from #DistrictFund
where date is not null

alter table #DistrictFund
add Total float

update #Districtfund
set TOTAL = Systematic_Offering+Thanks_Offering+Loose_Offering+
			Annual_Harvest+Bible_Society_Harvest




-------LOCAL FUNDS
--cte
with localfunds as(
select [CONVERTED DATE] as DATE,
		([SYSTEMATIC OFFERING]*0.5) as [SYSTEMATIC OFFERING],
		([THANKS OFFERING]*.5) as [THANKS OFFERING],
		([LOOSE OFFERING]*.5) as [LOOSE OFFERING],
		([ANNUAL HARVEST] *.8) as [ANNUAL HARVEST], 
		([EXPENSES OFFERING]), ([WELFARE DUES]), (HARVEST),
		[SELLING OF TREES], NURSERY, 
		[BIBLE SOCIETY HARVEST] * .33 AS [BIBLE SOCIETY HARVEST], 
		DONATIONS,[FUND RAISING / SPECIAL HARVEST], 
		[CARE FOR THE AGED FUND], [ZONAL CONTRIBUTION], [WOMEN MINISTRY HARVEST], CHOIR, [SINGING BAND], 
		[LORD'S SUPPER], [AMM HARVEST], [CAMP MEETING], [HOME COMING], RENT
FROM income)
select 
		DATE, [SYSTEMATIC OFFERING], [THANKS OFFERING],
		[LOOSE OFFERING], [ANNUAL HARVEST], ([EXPENSES OFFERING]), ([WELFARE DUES]), (HARVEST),
		[SELLING OF TREES], NURSERY, [BIBLE SOCIETY HARVEST], DONATIONS,[FUND RAISING / SPECIAL HARVEST], 
		[CARE FOR THE AGED FUND], [ZONAL CONTRIBUTION], [WOMEN MINISTRY HARVEST], CHOIR, [SINGING BAND], 
		[LORD'S SUPPER], [AMM HARVEST], [CAMP MEETING], [HOME COMING], RENT,
		([SYSTEMATIC OFFERING] + [THANKS OFFERING] + [LOOSE OFFERING] + [ANNUAL HARVEST] + 
		[EXPENSES OFFERING] + [WELFARE DUES] + HARVEST
		+ [SELLING OF TREES] + [BIBLE SOCIETY HARVEST] + DONATIONS + 
		[FUND RAISING / SPECIAL HARVEST] + [CARE FOR THE AGED FUND] + [ZONAL CONTRIBUTION]) as Total
from localfunds
where date is not null-- and TOTAL is not null
ORDER BY DATE


--LOCAL FUNDS TEMP TABLE
drop table if exists #localfunds
create table #LocalFunds
		(Date date,
		Systematic_Offering float,
		Thanks_Offering float,
		Loose_Offering float,
		Expenses_Offering float,
		Annual_Harvest float, 
		Welfare_Dues float,
		Harvest float,
		Selling_of_Trees float,
		Nursery float,
		Bible_Society_Harvest float,
		Donations float,
		Fund_Raising_Special_Harvest float, 
		Care_For_The_Aged_Fund float, 
		Zonal_Contributions float, 
		Women_Ministry float,
		Choir float,
		Singing_Band float, 
		[LORD'S SUPPER] float,
		[AMM HARVEST] float,
		[CAMP MEETING] float,
		[HOME COMING] float,
		RENT float)


select *
from #LocalFunds

insert into #LocalFunds
	select cast(DATE as date),
		[SYSTEMATIC OFFERING]*0.5,
		[THANKS OFFERING]*.5,
		[LOOSE OFFERING]*.5,
		[EXPENSES OFFERING],
		[ANNUAL HARVEST] *.8,
		[WELFARE DUES], 
		HARVEST,
		[SELLING OF TREES], 
		NURSERY, 
		[BIBLE SOCIETY HARVEST] * .33, 
		DONATIONS,
		[FUND RAISING / SPECIAL HARVEST], 
		[CARE FOR THE AGED FUND], 
		[ZONAL CONTRIBUTION], 
		[WOMEN MINISTRY HARVEST], 
		CHOIR, 
		[SINGING BAND], 
		[LORD'S SUPPER], 
		[AMM HARVEST],
		[CAMP MEETING],
		[HOME COMING], 
		RENT
FROM income


alter table #localfunds
add TOTAL float

--replacing is null cells with 0
update #LocalFunds 
set Singing_Band = 0 
where Singing_Band is null

update #LocalFunds
set [CAMP MEETING] = 0
where [CAMP MEETING] is null

update #LocalFunds
set Total = Systematic_Offering + Thanks_Offering + Loose_Offering + Expenses_Offering + Annual_Harvest +
			Welfare_Dues + Harvest + Selling_of_Trees + Nursery + Bible_Society_Harvest + Donations + Fund_Raising_Special_Harvest + 
			Care_For_The_Aged_Fund + Zonal_Contributions + Women_Ministry + Choir + [LORD'S SUPPER] + [AMM HARVEST] +
			[HOME COMING] + RENT + [CAMP MEETING]  + Singing_Band
		
alter table #LocalFunds alter column [CAMP MEETING] float  null
		--[HOME COMING] ,
		--RENT) is not null

select total, *
from #LocalFunds



--SELECT date BETWEEN DATE
SELECT [CONVERTED DATE] AS DATE, * 
FROM INCOME
WHERE DATE BETWEEN '2021-01-01' AND '2021-06-06'




'''CREATING VIEWS FOR VISUALISATION'''


create view LocalFunds as
select cast(DATE as date) as DATE,
		[SYSTEMATIC OFFERING]*0.5 [SYSTEMATIC OFFERING],
		[THANKS OFFERING]*.5 [THANKS OFFERING],
		[LOOSE OFFERING]*.5 [LOOSE OFFERING],
		[EXPENSES OFFERING],
		[ANNUAL HARVEST] *.8 [ANNUAL HARVEST], [WELFARE DUES], 
		HARVEST, [SELLING OF TREES], NURSERY, 
		[BIBLE SOCIETY HARVEST] * .33 [BIBLE SOCIETY HARVEST], DONATIONS,
		[FUND RAISING / SPECIAL HARVEST], 
		[CARE FOR THE AGED FUND], [ZONAL CONTRIBUTION], [WOMEN MINISTRY HARVEST], CHOIR, 
		[SINGING BAND], [LORD'S SUPPER], [AMM HARVEST],[CAMP MEETING],[HOME COMING], RENT, 
		([SYSTEMATIC OFFERING] +  [THANKS OFFERING] + [LOOSE OFFERING] + [EXPENSES OFFERING] + [ANNUAL HARVEST] + [WELFARE DUES]+
		HARVEST + [SELLING OF TREES] + NURSERY + [BIBLE SOCIETY HARVEST] + DONATIONS + [FUND RAISING / SPECIAL HARVEST] + [CARE FOR THE AGED FUND] + 
		[ZONAL CONTRIBUTION] + [WOMEN MINISTRY HARVEST] + CHOIR + [SINGING BAND] + [LORD'S SUPPER] + [AMM HARVEST] + 
		[CAMP MEETING] + [HOME COMING]+ RENT) as Total
FROM INCOME


select * 
from LOCALFUNDS

DROP VIEW ConfFunds




CREATE VIEW DistrictFunds AS
select 
		CAST (DATE as DATE) DATE,
		[SYSTEMATIC OFFERING]*0.1 [SYSTEMATIC OFFERING],
		[THANKS OFFERING]*.1 [THANKS OFFERING],
		[LOOSE OFFERING]*.1 [LOOSE OFFERING],
		[ANNUAL HARVEST] *.1 [ANNUAL HARVEST],
		[BIBLE SOCIETY HARVEST] * .33 [BIBLE SOCIETY HARVEST], 
		([SYSTEMATIC OFFERING] +[THANKS OFFERING]+[LOOSE OFFERING]+[ANNUAL HARVEST]+[BIBLE SOCIETY HARVEST]+DONATIONS) TOTAL
FROM income
where date is not null-- and TOTAL is not null
--ORDER BY DATE

select *
from DistrictFunds




CREATE VIEW ConfFunds AS
select 
		CAST (DATE as DATE) DATE, TITHE,
		[SYSTEMATIC OFFERING]*0.4 [SYSTEMATIC OFFERING],
		[THANKS OFFERING]*.4 [THANKS OFFERING],
		[LOOSE OFFERING]*.4 [LOOSE OFFERING],
		[ANNUAL HARVEST] *.1 [ANNUAL HARVEST],
		[BIBLE SOCIETY HARVEST] * .33 [BIBLE SOCIETY HARVEST], 
		(TITHE + [SYSTEMATIC OFFERING] +[THANKS OFFERING]+[LOOSE OFFERING]+[ANNUAL HARVEST]+[BIBLE SOCIETY HARVEST]+DONATIONS) TOTAL
FROM income
where date is not null-- and TOTAL is not null
--ORDER BY DATE

select *
from ConfFunds