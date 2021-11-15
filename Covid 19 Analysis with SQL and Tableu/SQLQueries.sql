SELECT * FROM CovidProject..CovidDeaths ORDER BY 3,4

SELECT * FROM CovidProject..CovidVaccinations ORDER BY 3,4


--Table for the introduction of number of cases and deaths
SELECT location,date,total_cases,total_deaths
FROM CovidProject..CovidDeaths 
ORDER BY 1,2

--Table for the Deaths/Case ratio
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRatio 
FROM CovidProject..CovidDeaths 
ORDER BY 1,2

--Table for the Deaths/Case ratio for Germany
SELECT location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRatio FROM CovidProject..CovidDeaths WHERE location='Germany' ORDER BY 1,2

--Table for percentage of infected population
SELECT location,date,population, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathRatio,(total_cases/population)*100 as InfectedPercentage 
FROM CovidProject..CovidDeaths 
ORDER BY 1,2

-- Countries with highest cases and deaths

SELECT location,population,(total_cases) as HighestInfectionCount,(total_cases/population)*100 as InfectionPercentage,total_deaths,(total_deaths/total_cases)*100 as DeathRatio 
FROM CovidProject..CovidDeaths 
ORDER BY InfectionPercentage DESC,DeathRatio DESC

-- Countries with Highest Infection Rate compared to Population

Select location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount DESC

-- Showing contintents with the highest death count per population

Select location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where continent is null and location not like '%income%'
Group by location
order by TotalDeathCount desc

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
where continent is not null 
Group By date
order by 1,2

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

Select  dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
from CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
ON dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by vac.new_vaccinations DESC

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- Creating View to store data for visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From CovidProject..CovidDeaths dea
Join CovidProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select * from PercentPopulationVaccinated

-- Table 1 Query-- Global numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidProject..CovidDeaths
where continent is not null 
order by 1,2

--Table 2 Query-- Death count by continent

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From CovidProject..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International','Upper middle income','High income','Lower middle income','Low income')
Group by location
order by TotalDeathCount desc

--Table 3 Query--  Poulation infected by countries

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
Where location not in ('International','Upper middle income','High income','Lower middle income','Low income','World','Africa','North America','South America','Asia','Europe','European Union','Central Africa')
Group by Location, Population
order by PercentPopulationInfected desc

--Tabel 4-- Poulation infected by countries and date in ascending order

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidProject..CovidDeaths
Where location not in ('International','Upper middle income','High income','Lower middle income','Low income','World','Africa','North America','South America','Asia','Europe','European Union','Central Africa')
Group by Location, Population, date
order by location,PercentPopulationInfected DESC