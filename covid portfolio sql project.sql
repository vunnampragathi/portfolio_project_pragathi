select *
from [dbo].[coviddeath ]
order by 3


select * 
from [dbo].[covid vaccination]
order by 3


-- Select Data that we are going to be starting with

Select location, date, total_cases, new_cases, total_deaths, population
From [dbo].[coviddeath ]
order by 1,2


--looking at total vs total deaths

select * from coviddeath

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From [dbo].[coviddeath ]
order by 1,2

--lets consider the death percentage in us

Select Location, date, Population, total_cases,  (total_deaths/total_cases)*100 as DeathPercentage
From [dbo].[coviddeath ]
Where location like '%states%'
order by 1,2


--looking at total cases vs total population in us shows what percentage of people are infected with covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as DeathPercentage
From [dbo].[coviddeath ]
--Where location like '%states%'
order by 1,2


--looking at countries with highest infection rate compared to population
Select Location,  Population, max(total_cases) as HighestInfectionCount,  max((total_cases/population))*100 as PercentagePopulationInfected
From [dbo].[coviddeath ]
--Where location like '%states%'
group by location, population
order by PercentagePopulationInfected desc


--showing the countries with the highest death count per population

Select Location,  max(total_deaths) as TotalDeathCount
From [dbo].[coviddeath ]
--Where location like '%states%'
group by location
order by TotalDeathCount desc

--here it is showing the continents names like asia,africa etc., because of null values present in the continents. So let us consider non null continents for our analysis purpose
Select Location,  max(total_deaths) as TotalDeathCount
From [dbo].[coviddeath ]
where continent is not null
--Where location like '%states%'
group by location
order by TotalDeathCount desc

--lets break things by continent instead of location wise
Select continent,  max(total_deaths) as TotalDeathCount
From [dbo].[coviddeath ]

--Where location like '%states%'
group by continent
order by TotalDeathCount desc


---showing the continents with the highest death count per population
Select continent,  max(total_deaths) as TotalDeathCount
From [dbo].[coviddeath ]
where continent is not null
--Where location like '%states%'
group by continent
order by TotalDeathCount desc


--global numbers

Select sum(new_cases)as totalcases, sum(new_deaths) as totaldeats, (sum(new_deaths)/sum(new_cases))*100 as DeathPercentage
From [dbo].[coviddeath ]
where continent is not null
--Where location like '%states%'
order by 1,2



--lets join the 2 tables for our further analysis

select * 
from [dbo].[coviddeath ] dea
join [dbo].[covid vaccination] vac
on dea.location= vac.location and dea.date=vac.date


---looking at total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from [dbo].[coviddeath ] dea
join [dbo].[covid vaccination] vac
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3

---caluculating the rolling people vaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from [dbo].[coviddeath ] dea
join [dbo].[covid vaccination] vac
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null
order by 2,3


---creating the CTE to caluculate the total percentate of people vaccinated.
with PopVSVac (continent, location, date, population,new_vaccinations, rollingpeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from [dbo].[coviddeath ] dea
join [dbo].[covid vaccination] vac
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(rollingpeopleVaccinated/population)*100 from PopVSVac




---lets create the temp table for the above data
create table #PercentPopulationVaccinated
(continent nvarchar(225),
location nvarchar(225),
date datetime,
population numeric,
new_vaccinations numeric, 
rollingpeopleVaccinated numeric
)

--inserting the data in to the temporary table created
insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from [dbo].[coviddeath ] dea
join [dbo].[covid vaccination] vac
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * ,(rollingpeopleVaccinated/population)*100 from #PercentPopulationVaccinated


--- creating the view to store data for later visualization purpose

create view PercentPopulationVaccinated
as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from [dbo].[coviddeath ] dea
join [dbo].[covid vaccination] vac
on dea.location= vac.location and dea.date=vac.date
where dea.continent is not null
--order by 2,3


select * from PercentPopulationVaccinated