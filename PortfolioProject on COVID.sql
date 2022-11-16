Select *
From PortfolioProject..CovidDeaths$
Where continent is not NULL
Order by 3,4

--select *
--from PortfolioProject..CovidVaccinations$
--order by 3,4

--Select Data that we are going to be using

Select Location, Date, Total_Cases, New_Cases , Total_Deaths , Population
from PortfolioProject..CovidDeaths$
Where Continent is not NULL
Order By 1,2

--Looking at Total Cases vs Total Deaths in Greece

Select Location , Date , Total_Cases , Total_Deaths , (Total_Deaths/Total_Cases)*100 as DeathsPercentage
From PortfolioProject..CovidDeaths$
Where Location like '%Greece%'
Order By 1,2

--Looking at Total Cases vs Population in Greece

Select Location , Date , Population , Total_Cases , (Total_Cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Where Location like '%Greece%'
Order By 1,2

--Looking at Countries with the Highest Infection Rate compared to Population

Select Location , Population , MAX(Total_Cases) as HighestInfectionCount , MAX((Total_Cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths$
Group By Location, Population
Order By PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is not NULL
Group By Location
Order By TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT

Select Location , MAX(cast(Total_Deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
Where continent is NULL
Group By Location
Order By TotalDeathCount desc


--Let's join the two tables together 
--Looking at Total Population vs Vaccinations Rolling by Date

With PopvsVac (Continent, Location , Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent , dea.location , dea.date , dea.population, vac.new_vaccinations 
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac