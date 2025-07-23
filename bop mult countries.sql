SELECT * FROM GH_NIG_BOP
where particulars is not null
--order by YEAR


SElect * from GH_NIG_BOP
where  (particulars like '%good%')-- or particulars like '%import%')
and year = 2014 

SELECT (Year), Country,
    ROUND(
        SUM(CASE
            WHEN Particulars = 'Goods, credit (exports)' THEN [Amount]
            WHEN Particulars = 'Goods, debit (imports)' THEN -[Amount]
            END),
            2 ) AS NetGoodsExport
FROM   GH_NIG_BOP
group by Year, Country
order by Year, NetGoodsExport


select *
from GH_NIG_BOP
where Particulars like '%goods, debit%'
order by Year

create table AfNetGoodsExport (
	Year int,
	Country varchar(100),
	Exports float,
	Imports float,
	[Net Export] as Exports - Imports



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



select * from AfNetGoodsExport
order by 1

truncate table AfNetGoodsExport

update AfNetGoodsExport
set Country = GH_NIG_BOP.Country
from GH_NIG_BOP 
join AfNetGoodsExport
on AfNetGoodsExport.Year = GH_NIG_BOP.Year
