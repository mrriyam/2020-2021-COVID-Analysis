--COVID SQL Portfolio Project

select * 
from CovidDeaths cd 
where cd.continent is not null
and cd.continent != ''
order by 3, 4

select location, date, total_cases, total_deaths, (cd.total_deaths * 1.0/cd.total_cases ) *100 as DeathPercentage
from CovidDeaths cd 
where location like '%canada%'
order by 1,2


--Examining total cases vs total deaths
select location, date, total_cases, population, (total_cases *1.0/population) *100 as CovidPercentage
from CovidDeaths cd 
order by 1,2
*/

--Total Cases vs Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases*1.0/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Infection Rate compared to Population
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases*1.0/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Showing countries with Highest Death Count per Population
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidDeaths
--Where location like '%states%'
Where continent = '' 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

-- Continents with highest death count per population
select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths cd 
where cd.continent is not null
and cd.continent != ''
group by location
order by TotalDeathCount desc


-- Global numbers
select sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)* 100 as DeathPercentage
from CovidDeaths cd 
where continent != ''
--group by date
order by 1,2


--Using CTE, looking at total population vs vaccinations
With PopvsVac (Continent, location, date, population, new_vaccinations, ConsecutiveVaccinationCount)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
sum(vac.new_vaccinations) over (partition by dea.location 
order by dea.location, dea.date) as ConsecutiveVaccinationCount
from CovidDeaths dea
join CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date 
where dea.continent != ''
order by 2, 3
)

select *, (ConsecutiveVaccinationCount/Population)*100
from popvsvac

--Creating view to store data for later visualizations 

