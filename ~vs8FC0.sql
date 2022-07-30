select location, date ,total_cases ,new_cases,total_deaths, population 
from [portfolioProject ]..Covid_death$
order by 3,4;


--comparing total cases with death rate (how likelyhood of dying after getting covid)

select location, date ,total_cases ,new_cases,total_deaths, (total_deaths/total_cases)*100 as Death_rate_percentage
from [portfolioProject ]..Covid_death$
where location like 'india'
order by 2 desc; 

--comparing total case with polulation 
--percentage of people getting covid
select location, date ,total_cases, population, (total_cases/population)*100 as populationInfected
from [portfolioProject ]..Covid_death$
where location like 'india'
order by 2 desc; 

--countries with highest infection rate
select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 as populationInfected
from [portfolioProject ]..Covid_death$
--where location like 'india'
group by location, population 
order by populationInfected  desc;

--highest death count
select location, population, max(total_deaths) as highest_death_rate, max((total_deaths/population))*100 as death_rate_percentage
from [portfolioProject ]..Covid_death$
--where location like 'india'
group by location, population 
order by death_rate_percentage  desc;

--global 
select date, sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as higest_death, sum(cast(total_deaths as int))/sum(total_cases)*100 as highest_death_percentage
from [portfolioProject ]..Covid_death$
where continent is not null
group by date
order by 1,2  desc;

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [portfolioProject ]..Covid_death$
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

--join
--comparing total_cases and vacination
select cod.continent,cod.location, cod.date, cod.population, cov.new_vaccinations,
sum(cast(cov.new_vaccinations as int)) over(Partition by cod.location order by cod.location, cod.date) as total_people_vaccinated
from [portfolioProject ]..Covid_death$ cod 
join [portfolioProject ]..Covid_vaccination$ cov
on cod.location = cov.location 
and cod.date = cov.date
where cod.continent is not null
order by 2,3; 


--cte
with popvs(continent,location, date, population, new_vaccinations, total_people_vaccinated)
as (
select cod.continent,cod.location, cod.date, cod.population, cov.new_vaccinations,
sum(cast(cov.new_vaccinations as int)) over(Partition by cod.location order by cod.location, cod.date) as total_people_vaccinated
from [portfolioProject ]..Covid_death$ cod 
join [portfolioProject ]..Covid_vaccination$ cov
on cod.location = cov.location 
and cod.date = cov.date
where cod.continent is not null
--order by 2,3 
)
select *,(total_people_vaccinated/population)*100 as total_vacciation_percentage from popvs;


--temp

Drop table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar(255),
location  nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
total_vacciation_percentage numeric 
)

insert into #PercentagePopulationVaccinated
select cod.continent,cod.location, cod.date, cod.population, cov.new_vaccinations,
sum(cast(cov.new_vaccinations as bigint)) over (Partition by cod.location order by cod.location, cod.date) as total_people_vaccinated
from [portfolioProject ]..Covid_death$ cod 
join [portfolioProject ]..Covid_vaccination$ cov
on cod.location = cov.location 
and cod.date = cov.date
where cod.continent is not null
--order by 2,3 

select * from #PercentagePopulationVaccinated;



-- create view

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [portfolioProject ]..Covid_death$ dea
Join [portfolioProject ]..Covid_vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


create View ContinentHighDeath as
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From [portfolioProject ]..Covid_death$
--Where location like '%states%'
Where continent is not null 
Group by continent
--order by TotalDeathCount desc


select * from ContinentHighDeath;



