select *
from CovidDeaths
where continent like ''


select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPerc
from CovidDeaths
where location like 'Ukraine'
order by 1, 2

-- looking at Total cases vs Population
-- shows what perc of population got COVID
select Location, date, total_cases, population, (total_cases/population)*100 as PercofPopul
from CovidDeaths
where location like 'Ukraine'
order by 1, 2 desc

-- countries with highest infection rate to population
select Location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population)*100) as PercofPopulationInfected
from CovidDeaths
Group by Location, Population
order by PercofPopulationInfected descselect Location, population, max(total_deaths) as TotalDeathCount
from CovidDeaths
where continent not like ''
Group by Location, population
order by TotalDeathCount desc

-- Showing continents with highest death count per Population
select Location, max(total_deaths) as TotalDeathCount
from CovidDeaths
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Breaking it down by Continent
select continent, max(total_deaths) as TotalDeathCount
from CovidDeaths
where continent not like ''
Group by continent
order by TotalDeathCount desc

-- global numbers

select date, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeahts, sum(new_deaths)/sum(new_cases)*100 as DeathPerc
from CovidDeaths
where continent not like ''
group by date
order by 1, 2

-- looking at total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

from CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent not like ''
and vac.new_vaccinations not like ''
order by 2,3

-- use cte
with PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent not like ''
and vac.new_vaccinations not like ''
)

select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


-- Creating view to store for later visualisations

Create View PercentPopulationVacc as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
Join CovidVaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent not like ''
and vac.new_vaccinations not like ''


