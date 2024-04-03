--Select *
--From PortfolioProject..CovidDeaths
--Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

--Select Location,date,total_cases,new_cases,total_deaths,population
--From PortfolioProject..CovidDeaths
--Order by Location,date

-- Detecting the Total Cases Vs Total Deaths

----Select Location,date,total_cases,total_deaths,CONVERT(FLOAT,total_deaths)/CONVERT(FLOAT,total_cases) *100 AS DeathPercentage
--Select Location,date,total_cases,total_deaths,( total_deaths/total_cases)*100 AS DeathPercentage
--From PortfolioProject..CovidDeaths
----Where Location = 'India'
--Order by 1,2

----Looking at the Total Cases Vs Population / Means what percentage of the total population was affected by Covid
--Select Location,date,Population,total_cases,CONVERT(FLOAT,total_cases)/Population *100 AS PercentagePopulationInfected
--From PortfolioProject..CovidDeaths
----Where Location = 'India'
--Order by 1,2

--To find out the Countries with highest Infection Rate compared to Population
--Select Location,Population, MAX(total_cases) AS HighestInfectionCount,MAX(CONVERT(FLOAT,total_cases)/Population) *100 AS PercentagePopulationInfected
--From PortfolioProject..CovidDeaths
----Where Location = 'India'
--Group By Location,Population
--Order By PercentagePopulationInfected

 --Showing Continents with Highest Death Count per population
--Select Continent, MAX(Cast(total_deaths as int)) AS HighestDeathCount
--From PortfolioProject..CovidDeaths
--Where Continent is not Null
----Where Location = 'India'
--Group By Continent
--Order By HighestDeathCount DESC

-- TO BREAK THINGS DOWN BY CONTINENT / LOCATION TO FIND HIGHEST DEATH COUNT
--Select Location, MAX(Cast(total_deaths as int)) AS HighestDeathCount
--From PortfolioProject..CovidDeaths
--Where Continent is not Null
--Where Location = 'India'
--Group By Location
--Order By HighestDeathCount DESC


-- TO FIND OUT CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION

--Select Location, MAX(Cast(total_deaths as int)/Population)* 100 AS HighestDeathCount
--From PortfolioProject..CovidDeaths
--Where Continent is not Null
----Where Location = 'India'
--Group By Location
--Order By HighestDeathCount DESC


--FINDING OUT SOME GLOBAL NUMBERS
----FINDING OUT DEATH PERCENTAGE OUT OF TOTAL CASES FROM A GLOBAL PERSPECTIVE
--Select Location, Date, total_cases, total_deaths, cast(total_deaths as int) / cast(total_cases as int) * 100 as DeathPercentage
--From PortfolioProject..CovidDeaths
--Where Continent is not Null
----Where Location = 'India'
----Group By 
--Order By 1,2

--FINDING OUT SOME GLOBAL NUMBERS
--------FINDING OUT THE TOTAL NEW CASES AND TOTAL NEW DEATH FOR EACH DAY ( DATE WISE) THAT TOOK PLACE IN THE WORLD AND CALCULATING DATE PERCENTAGE FOR EACH DAY
--Select Date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/ SUM(new_cases) * 100 AS DeathPercentage
----SUM(new_deaths)/ NULLIF(SUM(new_cases),0) * 100 AS DeathPercentage
--From PortfolioProject..CovidDeaths
--Where CONTINENT IS NOT NULL  
------Where Location = 'India'
--Group By Date
----USING HAVING CLAUSE RATHER THAN NULLIF THAT WAS USED TO CONVERT DIVISOR ZERO TO NULL 
--HAVING SUM(new_cases) != 0
--Order By 1,2

------FINDING OUT THE TOTAL NEW CASES AND TOTAL NEW DEATH AS A WHOLE ( NOT FOR EACH DAY) THAT TOOK PLACE IN THE WORLD AND CALCULATING DATE PERCENTAGE AS A WHOLE
----Select  SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/ SUM(new_cases) * 100 AS DeathPercentage
----SUM(new_deaths)/ NULLIF(SUM(new_cases),0) * 100 AS DeathPercentage
----From PortfolioProject..CovidDeaths
----Where CONTINENT IS NOT NULL  
------Where Location = 'India'
----Group By Date
----USING HAVING CLAUSE RATHER THAN NULLIF THAT WAS USED TO CONVERT DIVISOR ZERO TO NULL 
----HAVING SUM(new_cases) != 0
----Order By 1,2



--NOW THE PROJECT WOULD GO AHEAD WITH CovidVacinations

--Select *
--From PortfolioProject..CovidVaccinations


--JOINING THE TWO TABLES TOGETHER
--Select *
--From PortfolioProject..CovidDeaths
--Join PortfolioProject..CovidVaccinations
--ON PortfolioProject..CovidDeaths.location=PortfolioProject..CovidVaccinations.location


Select *
--From PortfolioProject..CovidDeaths cd
--Join PortfolioProject..CovidVaccinations cv
--ON cd.location=cv.location
--and cd.date=cv.date

--FROM THE JOINED TABLE FINDING OUT TOTAL POPULATION vs TOTAL VACCINATION
--Select cd.population, cv.total_vaccinations, cast(total_vaccinations as int)/ cv.population * 100 as PerentageOfPeoplVaccinated
--From PortfolioProject..CovidDeaths cd
--Join PortfolioProject..CovidVaccinations cv
--ON cd.location=cv.location
--and cd.date=cv.date

----FROM THE JOINED TABLE FINDING OUT NUMBERS OF NEW VACCINATION
--Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations
--From PortfolioProject..CovidDeaths cd
--Join PortfolioProject..CovidVaccinations cv
--ON cd.location=cv.location
--and cd.date=cv.date
--where cd.continent is not null
--Order by 1,2,3


----------------FROM THE JOINED TABLE FINDING OUT NUMBERS OF NEW VACCINATION
--------------Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
--------------SUM(Convert(int,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as UpdatedVaccinationFigure
--------------From PortfolioProject..CovidDeaths cd
--------------Join PortfolioProject..CovidVaccinations cv
--------------ON cd.location=cv.location
--------------and cd.date=cv.date
--------------where cd.continent is not null
--------------Order by 2,3
--Msg 8729, Level 16, State 1, Line 132
--ORDER BY list of RANGE window frame has total size of 1020 bytes. Largest size supported is 900 bytes.

--Completion time: 2024-04-02T18:32:45.5501598+01:00


--USING CTE TO FIND THE PERCENTAGE OF UpdatedVaccinationFigure

--------------With PopulationVsVacci (continent,location,date,population,new_vaccinations,UpdatedVaccinationFigure)
--------------As
--------------(Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
--------------SUM(Convert(int,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as UpdatedVaccinationFigure
--------------From PortfolioProject..CovidDeaths cd
--------------Join PortfolioProject..CovidVaccinations cv
--------------ON cd.location=cv.location
--------------and cd.date=cv.date
--------------where cd.continent is not null
----------------Order by 2,3)

--------------Select *, (UpdatedVaccinationFigure/Population) * 100
--------------From PopulationVsVac

--------------Msg 156, Level 15, State 1, Line 174
--------------Incorrect syntax near the keyword 'Select'.

--------------Completion time: 2024-04-02T21:11:28.7348937+01:00


--CREATING A TEMP TABLE USING 

Create Table HASHPercentagePeopleVaccinated

( Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
UpdatedVaccinationFigure numeric)

Insert into HASHPercentagePeopleVaccinated
Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
SUM(Convert(int,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as UpdatedVaccinationFigure
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
--Order by 2,3)

Select *, (UpdatedVaccinationFigure/Population) * 100
From HASHPercentagePeopleVaccinated



-- WITH THE SAME ABOVE TABLE IF YOU WANT TO MAKE ANY CHANGE


Drop Table if exists HASHPercentagePeopleVaccinated
Create Table HASHPercentagePeopleVaccinated

( Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
UpdatedVaccinationFigure numeric)

Insert into HASHPercentagePeopleVaccinated
Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
SUM(Convert(int,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as UpdatedVaccinationFigure
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
--where cd.continent is not null ( This change has been done here)
--Order by 2,3)

Select *, (UpdatedVaccinationFigure/Population) * 100


-- CREATING VIEW FOR STORING DATA FOR VISUALISATIONS

Create View  PercentagePopulationVaccinated as

Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
SUM(Convert(int,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as UpdatedVaccinationFigure
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null 
--Order by 2,3)

--NOW GitHUB Action Required
--Keeping in hold for the moment since project not complete


  

From HASHPercentagePeopleVaccinated


