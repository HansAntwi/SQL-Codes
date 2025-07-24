SELECT * FROM GH_NIG_BOP
where particulars is not null
--order by YEAR


SElect * from GH_NIG_BOP
where  (particulars like '%import%')-- or particulars like '%import%')
--and year = 2014  and country = 'ghana'


select *
from GH_NIG_BOP
where Particulars like '%goods, debit%'
order by Year

-----------------------------------------------------------------
-------------------------------------------------------------------
create table AfNetGoodsExport (
	Year int,
	Country varchar(100),
	Exports float,
	Imports float,
	[Net Export] as ROUND([Exports] - [Imports],2))



select * from GH_NIG_BOP

insert into AfNetGoodsExport (Year, Country, Exports, Imports)
select Year, Country,
round(sum(case
	when Particulars like '%Goods, credit%' then Amount
	else 0
end), 2) as Exports,
round(sum(case
	when Particulars like '%Goods, debit%' then Amount
	else 0
end),2 )as Imports
from GH_NIG_BOP
where Country in ('Ghana', 'Nigeria') and Year between 2014 and 2024
and (Particulars like '%Goods, credit%' or  Particulars like '%Goods, debit%')
group by Year, Country



-- select * from AfNetGoodsExport
-- order by 1

-- truncate table AfNetGoodsExport

-- update AfNetGoodsExport
-- set Country = GH_NIG_BOP.Country
-- from GH_NIG_BOP 
-- join AfNetGoodsExport
-- on AfNetGoodsExport.Year = GH_NIG_BOP.Year
---------------------------------------------------------------------------------------------------------------------------------------------



----CREATING NET EXPORT SERVICE TABLE
create table AfNetExportsService (

    Year int,
    Country varchar (50),
    Exports float,
    Imports float,
    [Net Exports] as ROUND([Exports] - [Imports],2)
)


----INSERTING VALUES INTO NETEXPORTSERVICE TABLE
select * from afnetexportsservice

insert into afnetexportsservice (Year,Country, Exports, Imports)
select Year, Country,
ROUND(SUM(case
    when Particulars like '%Services, credit%' then AMount
    else 0
    end ), 2) as Exports,

Round(SUM(case
    when Particulars like '%Services, debit%' then Amount 
    else 0
    end), 2) as Imports

from gh_nig_bop
where country in ('Ghana','Nigeria')
and year between 2014 and 2024 
and (particulars like '%services, credit%'  or particulars like '%services, debit%')
group by year, country 



-- SElect * from GH_NIG_BOP
-- where  (particulars like '%services, debit%')


--delete data in table
--TRUNCATE table afnetexportsservice


---creating TotalNetExports Table

create table TotalNetExports(
    Year int,
    Country VARCHAR(50),
    [Net Exports, Goods] float,
    [Net Exports, Services] float,
    [Total Net Exports] as ROUND([Net Exports, Goods] - [Net Exports, Services], 2) 
)

-- select * from totalNetExports

insert into totalNetExports (YEAR, country)
select distinct year, country
from afnetexportsservice


update TotalNetExports
set [Net Exports, Goods] = g.[net export]
from totalnetexports
join afnetgoodsexport g
on totalnetexports.YEAR = g.year and totalnetexports.country = g.country
--where YEAR is not null

-- truncate table totalnetexports

update totalnetexports
set [Net Exports, Services] = s.[Net Exports]
from totalnetexports t
join AfNetExportsService s
on t.year = s.YEAR and t.country = s.country
-----------------------------------------------------------

---------------------------------------------------------


---NET PRIMARY INCOME
Create Table AfNetPrimaryIncome(
    Year int,
    Country varchar(50),
    Credit FLOAT,
    Debit float,
    [Net Primary Income] as round(credit - debit,2))

select * from AfNetPrimaryIncome

SElect * from GH_NIG_BOP
where  (particulars like '%primary%')

insert into AfNetPrimaryIncome (Year, Country, Credit, Debit)
select Year, Country,
round(sum(case
    when Particulars like '%primary income, credit%' then Amount
    else 0
end), 2) as Credit,
round(SUM(case
    when Particulars like '%primary income, debit%' then Amount
    else 0
    end),2)
from gh_nig_bop
where country in ('Ghana', 'Nigeria') and year between 2014 and 2024
and (particulars like '%Primary income%')
group by year, country

--------------------------------------------------------
---------------------------------------------------------

---SECONDARY INCOME
CREATE TABLE AfNetSecondaryIncome(
    Year int,
    Country VARCHAR(50),
    Credit float,
    Debit float,
    [Net Secondary Income] as ROUND(credit - debit, 2))


select * from AfNetSecondaryIncome

insert into AfNetSecondaryIncome (Year, Country, Credit, Debit)
select Year, Country, 
round(sum(case 
    when Particulars like '%Secondary income, credit%' then Amount 
    else 0
    end), 2) as Credit, 
    
round(sum(case 
    when particulars like '%Secondary income, debit%' then Amount 
    else 0
    end) , 2) as Debit
from gh_nig_bop
where year between 2014 and 2024 and country in ('ghana', 'nigeria')
and (particulars like '%Secondary%')
group by year, country


SElect * from GH_NIG_BOP
where  (particulars like '%second%')

TRUNCATE table afNetSecondaryIncome

--------------------------------------------------------------
--------------------------------------------------------------

--CURRENT ACCOUNT BALANCE

--CAB = X-M + NY + NCT

create table CurrentAccountBalance(
    Year int,
    Country varchar(50),
    [Net Export] float,
    [Net Primary Income] float,
    [Net Secondary Income] float,
    [Current Account Balance] as ROUND([Net Export]+[Net Primary Income]+[Net Secondary Income], 2))

select * from CurrentAccountBalance
order by YEAR

insert into CurrentAccountBalance (Year, Country)
select distinct Year, Country from totalnetexports


-- TRUNCATE table CurrentAccountBalance


update CurrentAccountBalance
set [Net Export] = t.[Total Net Exports]
from CurrentAccountBalance cab
join totalNetExports t
on cab.year = t.year and cab.country = t.country


update CAB
set [Net Primary Income] = npy.[Net Primary Income]
from CurrentAccountBalance CAB
join AfNetPrimaryIncome npy
on npy.year = cab.year and npy.country = cab.country

update cab
set [Net Secondary Income] = nsy.[Net Secondary Income]
from CurrentAccountBalance CAB
join AfNetSecondaryIncome nsy 
on cab.country = nsy.country and cab.year = nsy.year


TRUNCATE table CurrentAccountBalance


-----------------------------------------------------------------
-----------------------------------------------------------------
--RATE OF VARIATION CAB
create table RateofCABVar(
    Year int,
    Country VARCHAR(50),
    [Current Account Balance] float,
    [Previous Year's CAB] float,
    [Rate of CAB Variation] as ROUND(([Current Account Balance] - [Previous Year's CAB])/[Previous Year's CAB] * 100 ,2))

select * from RateofCABVar
order by YEAR



insert into RateofCABVar (Year, Country, [Current Account Balance], [Previous Year's CAB])
select Year, Country, [Current Account Balance],
LAG([Current Account Balance]) over (partition by country order by year)
from CurrentAccountBalance
--where country = 'ghana'

drop table RateofCABVar
truncate table RateofCABVar


select * from RateofCABVar
where country = 'ghana'


select * from RateofCABVar
where country = 'ghana'

select * from RateofCABVar
where country  = 'nigeria'


select [Net Export], Country  from CurrentAccountBalance
where Country = 'Ghana'


select [Year], Country, [Net Export], 
LAG([Net Export]) over (partition by Country order by YEAR) as [Prev YEAR] 
from CurrentAccountBalance

select * from RateofCABVar


SELECT * from CurrentAccountBalance
SELECT * from AfNetExportsService
select * from currentaccou

