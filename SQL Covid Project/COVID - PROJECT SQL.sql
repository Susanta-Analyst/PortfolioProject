Select *
From PortfolioProject..CovidDeaths
Order by 3,4

Select *
From PortfolioProject..CovidVaccinations
Order by 3,4

Select Location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
Order by Location,date

-- DETECTING THE TOTAL CASES Vs TOTAL DEATH

--Select Location,date,total_cases,total_deaths,CONVERT(FLOAT,total_deaths)/CONVERT(FLOAT,total_cases) *100 AS DeathPercentage
Select Location,date,total_cases,total_deaths,( total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where Location = 'India'
Order by 1,2


----Looking at the Total Cases Vs Population / Means what percentage of the total population was affected by Covid----

Select Location,date,Population,total_cases,CONVERT(FLOAT,total_cases)/Population *100 AS PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where Location = 'India'
Order by 1,2

----To find out the Countries with highest Infection Rate compared to Population----

Select Location,Population, MAX(total_cases) AS HighestInfectionCount,MAX(CONVERT(FLOAT,total_cases)/Population) *100 AS PercentagePopulationInfected
From PortfolioProject..CovidDeaths
Where Location = 'India'
Group By Location,Population
Order By PercentagePopulationInfected

 ----Showing Continents with Highest Death Count per population----

Select Continent, MAX(Cast(total_deaths as int)) AS HighestDeathCount
From PortfolioProject..CovidDeaths
Where Continent is not Null
--Where Location = 'India'
Group By Continent
Order By HighestDeathCount DESC

-- TO BREAK THINGS DOWN BY LOCATION TO FIND HIGHEST DEATH COUNT--

Select Location, MAX(Cast(total_deaths as int)) AS HighestDeathCount
From PortfolioProject..CovidDeaths
Where Continent is Not Null
--Where Location = 'India'
Group By Location
Order By HighestDeathCount DESC


--TO BREAK THINGS DOWN BY CONTINENT TO FIND HIGHEST DEATH COUNT--

--TO FIND OUT CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION--

Select Continent, MAX(Cast(total_deaths as int)/Population)* 100 AS HighestDeathCount
From PortfolioProject..CovidDeaths
Where Continent is not Null
--Where Location = 'India'
Group By Continent
Order By HighestDeathCount DESC


----FINDING OUT SOME GLOBAL NUMBERS----

--Case I :FINDING OUT DEATH PERCENTAGE OUT OF TOTAL CASES FROM A GLOBAL PERSPECTIVE--

Select Location, Date, total_cases, total_deaths, (total_deaths /total_cases) * 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is not Null
--Where Location = 'India'
--Group By Date
Order By 1,2

--FINDING OUT SOME GLOBAL NUMBERS

-- Case II: FINDING OUT THE TOTAL NEW CASES AND TOTAL NEW DEATH FOR EACH DAY ( DATE WISE) THAT TOOK PLACE IN THE WORLD AND CALCULATING DATE PERCENTAGE FOR EACH DAY

Select Date, SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/ SUM(new_cases) * 100 AS DeathPercentage
--SUM(new_deaths)/ NULLIF(SUM(new_cases),0) * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where CONTINENT IS NOT NULL  
----Where Location = 'India'
Group By Date
--USING HAVING CLAUSE RATHER THAN NULLIF THAT WAS USED TO CONVERT DIVISOR ZERO TO NULL 
HAVING SUM(new_cases) != 0
Order By 1,2

--Case III : FINDING OUT THE TOTAL NEW CASES AND TOTAL NEW DEATH AS A WHOLE ( NOT FOR EACH DAY) THAT TOOK PLACE IN THE WORLD AND CALCULATING DATE PERCENTAGE AS A WHOLE---
 
Select  SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/ SUM(new_cases) * 100 AS DeathPercentage
--SUM(new_deaths)/ NULLIF(SUM(new_cases),0) * 100 AS DeathPercentage
From PortfolioProject..CovidDeaths
Where CONTINENT IS NOT NULL  
--Where Location = 'India'
--Group By Date
--USING HAVING CLAUSE RATHER THAN NULLIF THAT WAS USED TO CONVERT DIVISOR ZERO TO NULL 
HAVING SUM(new_cases) != 0
Order By 1,2

-- Note: To do the above operation, two things were done , a) Date removed b) No Group By Date this time



--NOW THE PROJECT WOULD GO AHEAD WITH CovidVacinations

Select *
From PortfolioProject..CovidVaccinations


--JOINING THE TWO TABLES TOGETHER ( Covid Death + Covid Vaccinations) --

Select *
From PortfolioProject..CovidDeaths
Join PortfolioProject..CovidVaccinations
ON PortfolioProject..CovidDeaths.location=PortfolioProject..CovidVaccinations.location


Select *
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date

--FROM THE JOINED TABLE FINDING OUT TOTAL POPULATION vs TOTAL VACCINATION

Select cd.population, cv.total_vaccinations, cast(total_vaccinations as int)/ (cv.population) * 100 as PerentageOfPeoplVaccinated
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date   


----FROM THE JOINED TABLE FINDING OUT NUMBERS OF NEW VACCINATION

Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
Order by 1,2,3


--FROM THE JOINED TABLE FINDING OUT NUMBERS OF NEW VACCINATION
-- Extra Note : Usage of int instead of bigint will not work here since output of the operation is out of the range of "int" --

Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
SUM(Convert(bigint,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as RollingVaccinationFigure
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null
Order by 2,3 


--USING CTE TO FIND THE PERCENTAGE OF UpdatedVaccinationFigure--

With PopulationVsVacci 
(continent,location,date,population,new_vaccinations,RollingVaccinationFigure)
As
(Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
SUM(Convert(bigint,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as RollingVaccinationFigure
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null)
--Order by 2,3)

Select * , (RollingVaccinationFigure/Population) * 100 as PercentageVaccinated
From PopulationVsVacci


----CREATING A TEMP TABLE USING DROP BY Statement ----
-- Drop By is usually used to initiate a change in the created Table 

DROP Table if exists #PercentagePeopleVaccinated1
Create Table #PercentagePeopleVaccinated1

( Continent nvarchar(255),
Location nvarchar (255),
Date datetime,
Population numeric,
New_vaccinations numeric,
UpdatedVaccinationFigure numeric)

Insert into #PercentagePeopleVaccinated1

Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
SUM(Convert(bigint,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as UpdatedVaccinationFigure
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
--where cd.continent is not null

Select *
From #PercentagePeopleVaccinated1


-- CREATING VIEW FOR STORING DATA FOR VISUALISATIONS--

Create View PercentagePopulationVaccinatedVisualisationFile as

Select cd.continent,cd.location,cd.date,cd.population, cv.new_vaccinations,
SUM(Convert(int,cv.new_vaccinations)) over (Partition by cd.location Order by cd.location, cd.date) as UpdatedVaccinationFigure
From PortfolioProject..CovidDeaths cd
Join PortfolioProject..CovidVaccinations cv
ON cd.location=cv.location
and cd.date=cv.date
where cd.continent is not null 
--Order by 2,3)

----------------------------------------------  END OF FIRST PART OF PROJECT---------------------------------------------------


 


