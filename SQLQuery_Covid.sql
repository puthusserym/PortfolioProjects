--SELECT * 
--FROM PortfolioProject..CovidDeaths
--ORDER BY 3,4

--SELECT * 
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4



SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


--Total Cases Vs Total Deaths or Death Percentage by date and country 


SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'United States' and  continent is not null
ORDER BY 1,2

Total Cases vs Population
Percentage of population with COVID

SELECT location, date, total_cases, population,	(total_cases/population) * 100 AS CovidPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2


-- Countries with highest COVID infection Rate 
 
 SELECT location,population, MAX(total_cases) as HighestInfectionCount, 
 MAX((total_cases/population)) * 100 AS CovidPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY CovidPercentage DESC


-- Countries with Total Death from COVID 

 SELECT location,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC
 

 -- COVID Death Count by Continent

 
 SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC
 
 SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Global deathrate

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths,
SUM(CAST(new_deaths as int))/ SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP By date
ORDER BY 1,2

SELECT  SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths,
SUM(CAST(new_deaths as int))/ SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
--GROUP By date
ORDER BY 1,2
--Join of 2 tables 
SELECT * 
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date

-- total population vs vaccinations

WITH PopvsVac (Continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
as 
(

SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT * , (RollingPeopleVaccinated/Population) * 100 
FROM PopvsVac

--************************************************
 
WITH PopvsVac (Continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
as 
(

SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null
)
SELECT Location ,MAX(RollingPeopleVaccinated/Population) * 100 AS Countryvaccination
FROM PopvsVac
GROUP BY Location
ORDER BY Countryvaccination 


--TEM Table


DROP TABLE IF Exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar (255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null

SELECT * , (RollingPeopleVaccinated/Population) * 100 
FROM #PercentPopulationVaccinated


Creating View for Visulaisation later

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population,vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null



SELECT *
FROM PercentPopulationVaccinated


