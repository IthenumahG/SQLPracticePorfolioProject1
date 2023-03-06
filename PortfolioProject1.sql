select *
from CovidDeaths
order by 3,4

--select *
--from CovidVaccination
--order by 3,4

-- Select Data to be used

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

-- Loking at Total cases vs Total Death (Likelihood of dying from Covid)

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location = 'Nigeria'
order by 1,2

-- Total Cases vs Population (Percentage of Population that got Covid)

select location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
from CovidDeaths
where location = 'Nigeria'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from CovidDeaths
--where location = 'Nigeria'
group by location, population
order by 4 desc

-- Showing Countries with hghest Death Count per Population

select location, population, max(cast(total_deaths as int)) as HighestDeathCount, max((total_deaths/population))*100 as DeathPercentByPopulation
from CovidDeaths
--where location = 'Nigeria'
where continent is not null
group by location, population
order by 3 desc
 -- OR
 select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location = 'World'
where continent is not null
group by location
order by 2 desc

-- Showing Continents with Highest Death count per population


select continent, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location = 'World'
where continent is not null
group by continent
order by 2 desc
 --OR

 select location, max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location = 'World'
where continent is null
group by location
order by 2 desc

--GLOBAL NUMBERS

select date, sum(new_cases) as  total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/
sum(new_cases)*100 as DeathPercentage
from CovidDeaths
--where location = 'Nigeria'
where continent is not null
group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location,dea.date, dea.population, vac.new_vaccinations,
sum(convert(bigint, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.Date) as RollingPeopleVaccinated
from CovidDeaths as dea
join CovidVaccination vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3
