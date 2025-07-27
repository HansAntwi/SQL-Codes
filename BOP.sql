
--creating database
-- CREATE DATABASE BOP;


-- selecting all columns
SELECT * FROM nigeria_bop
where particulars is not null
order by YEAR


SElect * from BOP.dbo.nigeria_bop
where  particulars like '%good%'-- or particulars like '%import%')
and year = 2014 


---create view NetGoodsExport
CREATE VIEW NetGoodsExport AS
SELECT YEAR,
    ROUND(
        SUM(CASE
            WHEN Particulars = 'Goods, credit (exports)' THEN [Amount]
            WHEN Particulars = 'Goods, debit (imports)' THEN -[Amount]
            END),
            2 ) AS NetGoodsExport
FROM   BOP.dbo.nigeria_bop
group by Year

select * from NetGoodsExport;



--create view NetServicesExport
Create view NetServicesExport AS
Select YEAR,
    round(
        sum(
            Case
            when particulars = 'Services, credit (exports)' then [Amount]
            when particulars = 'Services, debit (imports)' then -[Amount]
            END
        ), 2 )as NetServicesExport
FROM   BOP.dbo.nigeria_bop
GROUP by YEAR

 

--create table NetExport
create table NetExport (
    Year int,
    NetGoodsExport decimal(18, 2),
    NetServicesExport decimal(18, 2)
)


select * from NetExport;

-- Inserting data into NetExport table from the views created above
INSERT INTO NetExport (YEAR, NetGoodsExport, NetServicesExport)
SELECT 
    nge.year, 
    nge.NetGoodsExport, 
    nse.NetServicesExport
FROM 
    netgoodsexport nge
JOIN 
    netservicesexport nse ON nge.year = nse.year;


Alter table NetExport
Add [NetExport] decimal(18, 2);

Update NetExport
set NetExport = NetGoodsExport + NetServicesExport
where NetExport is null


create view NetExportView as
select Year, NetExport
from NetExport
where NetExport is not null;

select * from NetExportview

---creating NetPrimaryIncome view
Create view as NetPrimaryIncome AS
(round(select
    SUM(case
        when Particulars = 'Primary income, credit' then [Amount]
        when Particulars = 'Primary income, debit' then -[Amount] 
        else 0
    end)
    as NetPrimaryTransfer
from nigeria_bop


SElect * from BOP.dbo.nigeria_bop
where  (particulars like '%income%')-- or particulars like '%import%')
and year = 2014

Select * from Nigeria_BOP
where particulars = 'Primary income, credit' or particulars = 'Primary income, debit'
order by YEAR

---NET PRIMARY INCOME
drop table NEtPrimaryIncome;
create table NetPrimaryIncome(
    Year int,
    [Primary Income  credit] decimal (18, 2),
    [Primary income, debit] decimal (18, 2),
    [Net Primary Income] as ([Primary Income  credit] - [Primary income, debit])
)

select * from NetPrimaryIncome;

insert into Netprimaryincome (Year)
select distinct (year) from nigeria_bop

select * from NetPrimaryIncome;


update NY
set [Primary Income  credit] = NBOP.[Amount]
from NetPrimaryIncome NY
join nigeria_bop NBOP 
on nbop.year = ny.YEAR
where nbop.particulars = 'Primary income, credit'

update NY
set [Primary income, debit] = NBOp.[Amount]
from netprimaryincome NY
join nigeria_bop nbop
on nbop.year = ny.YEAR
where nbop.particulars = 'Primary income, debit'

create view NetPrimaryIncomeView as
select Year, [Net Primary Income]
from NetPrimaryIncome
where [Net Primary Income] is not null;

select * from NetPrimaryIncomeView;
------------------------------------------------------
-----------------------------------------------------

Select * from Nigeria_BOP
where particulars = 'Secondary income, credit' or particulars = 'Secondary income, debit'
order by YEAR


---Net Secondary Income
Create table NetSecondaryIncome(
    year int,
    [Secondary income, credit] decimal(18, 2),
    [Secondary income, debit] decimal(18, 2),
    [Net Secondary Income] as ([Secondary income, credit] -  [Secondary income, debit])
)

select * from NetsecondaryIncome;

---insert values into NetSecondaryIncome table
insert into NetsecondaryIncome (year)
select distinct (year) from Nigeria_BOP;

---updating NSY
update NSY
set [Secondary income, credit] = NBOP.[amount]
from Nigeria_BOP NBOP
join NetsecondaryIncome NSY
on NBOP.year = NSY.year
where NBOP.particulars = 'Secondary income, credit'

update NSY
set [Secondary income, debit] = NBOP.[Amount]
from Nigeria_BOP NBOP
join NetSecondaryIncome NSY
on NBOP.year = nsy.YEAR
where NBOP.particulars = 'Secondary income, debit'


----create view NetSecondaryIncomeView 
Create view NetSecondaryIncomeView AS
select year, [Net Secondary Income] 
from NetsecondaryIncome
where [Net Secondary Income] is not null;

select * from NetSecondaryIncomeView;

--------------------------------------------------------------------------------------------------------------------------------------------------

-----CURRENT ACCOUNT BALANCE --CAB
create table CurrentAccountBalance AS
    select
    ne.Year,
    ne.[NetExport], 
    ny.[Net Primary Income], 
    nsy.[Net Secondary Income], 
    ne.[NetExport] + ny.[Net Primary Income] + nsy.[Net Secondary Income] as [Current Account Balance]
    from NetExport NE
    join NetPrimaryIncome NY 
    on ne.YEAR=ny.YEAR
    join NetSecondaryIncome NSY
    on Ny.YEAR = nsy.year
    --where ne.year is not null


select * from AfNetGoodsExport


select * from afnetgoodsexport
where YEAR = 2014;


select Year, Country,
SUM(CASE
			WHEN Indicator = 'Gross Fixed Capital Formation' THEN Nominal
            WHEN Indicator = 'Change in Inventories' THEN -Nominal
			else 0
            END) AS [Nominal Investment],
sum(case
		when indicator = 'Gross Fixed Capital Formation' then Real
		when indicator = 'Change in Inventories' then -Real
		else 0
		end) as [Real Investment]
from Gh_Nig_GDP
group by Year, Country