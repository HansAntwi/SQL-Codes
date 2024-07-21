select * 
from CovidDeaths
where continent is not null
order by 3,4


select * 
from CovidVaccinations
order by 3, 4



--select location, date, total_cases, new_cases, total_deaths, population
--from CovidDeaths
--order by 1,2


--total cases vs total deaths
--likelihood of dying from contracting Covid19
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentageDeaths
from CovidDeaths
where location like '%state%' and continent is not null
order by 1,2

--total cases vs population
--population that contracted covid
select location, date, total_cases, population, (total_cases/population)*100 as PercentageDeaths
from CovidDeaths
where location like '%ghana%' and continent is not null
order by 1,2


--highest country with infection rate
select location, max(total_cases) as HighestInfectioncount, population, max((total_cases/population))*100 as PercInfectedPopulation
from CovidDeaths
where location like '%ghana%' and continent is not null
group by location, population
order by PercInfectedPopulation desc


--highest death count
select location, max(cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


--total number of cases per continent
select continent,sum(new_cases) as TotalNewCases
from CovidDeaths
where continent is not null
group by continent
order by TotalNewCases Desc

--total number of deaths per continent
select continent, sum(cast(new_deaths as int)) as TotalNewDeaths
from CovidDeaths
where continent is not null
group by continent
order by TotalNewDeaths Desc


--total number of cases per country
select location,sum(new_cases) as TotalNewCases
from CovidDeaths
where continent is not null and new_cases is not null
group by location
order by TotalNewCases Desc


---GLOBAL NUMBERS
--daily new cases, deaths and percentage
select date, sum(new_cases) as DailyNewCases, sum(cast(new_deaths as int)) as DailyNewDeaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as DailyPercDeaths
from CovidDeaths
--where location like '%state%'  
where continent is not null
group by date
order by 1,2


--total new cases, deaths and percentage
select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as TotalDeaths,(sum(cast(new_deaths as int))/sum(new_cases))*100 as 
TotalPercDeaths
from CovidDeaths
--where location like '%state%'  
where continent is not null
--group by date
order by 1,2



--join tables
select *
from CovidDeaths as Dea
join CovidVaccinations as Vac
	on Dea.location = vac.location
	and dea.date = vac.date

--total population vs total vaccination
---total running count
select dea.continent, dea.location, dea.date, (dea.population), vac.new_vaccinations,
	sum(cast (vac.new_vaccinations as int)) over (partition by (dea.location) order by dea.location, dea.date) as TotalVac 
from CovidDeaths as Dea
join CovidVaccinations as Vac
	on Dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null-- and dea.location like '%ghana%'
order by 2, 3


--using cte
with PopVsVac (Continent, Location, Date, Population, New_Vaccinations, TotalVac)
as
(
select dea.continent, dea.location, dea.date, (dea.population), vac.new_vaccinations,
	sum(cast (vac.new_vaccinations as int)) over (partition by (dea.location) order by dea.location, dea.date) as TotalVac 
from CovidDeaths as Dea
join CovidVaccinations as Vac
	on Dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null-- and dea.location like '%ghana%'
--order by 2, 3
)
select *, (TotalVac/Population)*100 as PerTotalVac
from PopVsVac
--order by 2, 3



--TEMP TABLE
create table #PerPopVac
(Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
TotalVac numeric)


---inserting values into temp table

drop table if exists #PerPopVac
insert into #PerPopVac
select dea.continent, dea.location, dea.date, (dea.population), vac.new_vaccinations,
	sum(cast (vac.new_vaccinations as int)) over (partition by (dea.location) order by dea.location, dea.date) as TotalVac 
from CovidDeaths as Dea
join CovidVaccinations as Vac
	on Dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null-- and dea.location like '%ghana%'
--order by 2, 3

select *, (TotalVac/Population)*100 as PerPopVac
from #PerPopVac
order by 2,3



---CREATING VIEW TO STORE DATA LATER FOR VISUALISATION
create view PerPopVac as
select dea.continent, dea.location, dea.date, (dea.population), vac.new_vaccinations,
	sum(cast (vac.new_vaccinations as int)) over (partition by (dea.location) order by dea.location, dea.date) as TotalVac 
from CovidDeaths as Dea
join CovidVaccinations as Vac
	on Dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null-- and dea.location like '%ghana%'
--order by 2, 3

select *
from PerPopVac