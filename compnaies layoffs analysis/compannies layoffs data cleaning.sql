-- SQL Project - Data Cleaning

-- https://www.kaggle.com/datasets/swaptr/layoffs-2022



use [pragathi portfolio project]


SELECT * 
FROM [dbo].[layoffs];

--- steps doing in this project
--1.remove duplicates
--2.standardize the data
--3.null values or blank values
--4.remove unwanted columns


---not to effect the original dataset i am creating a staging database and there i will do the data clenaing

CREATE TABLE dbo.layoffs_staging (
company varchar(50),
location varchar(50),
industry varchar(50),
total_laid_off varchar(50),
percentage_laid_off float,
date date,
stage varchar(50),
country varchar(50),
funds_raised_millions varchar(50)
)



INSERT layoffs_staging 
SELECT * FROM dbo.layoffs;

select * from layoffs_staging 

SELECT company, industry, total_laid_off,date,
		ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off,date, stage,country,location,percentage_laid_off, funds_raised_millions order by company) AS row_num
	FROM layoffs_staging
	
--creating a cte to delete the duplicates

with duplicates (company, industry, total_laid_off,date, stage,country,location,percentage_laid_off, funds_raised_millions, row_num )
as
(
SELECT *,
ROW_NUMBER() OVER (PARTITION BY company, industry, total_laid_off,date, stage,country,location,percentage_laid_off, funds_raised_millions order by company) AS row_num
FROM dbo.layoffs
)
--select * from duplicates
--where row_num>1

--delete  from duplicates where row_num>1

select * from layoffs


---standardizing the data

select distinct(company) from layoffs

select company, trim(company) from layoffs

update layoffs
set company=trim(company);

--lets do the same for industry

select distinct(industry) from layoffs order by 1

-- we have 3 cryptos lets update it
update layoffs
set industry='crypto'
--select * from layoffs 
where industry like 'Crypto Currency'

update layoffs
set industry='crypto'
--select * from layoffs 
where industry like 'CryptoCurrency'

select distinct(industry) from layoffs order by 1


--lets look at location
select distinct(location) from layoffs order by 1

--lets look at country
select distinct(country) from layoffs order by 1

select distinct(country), trim(trailing '.' from country) from layoffs

update layoffs
set country=trim(trailing '.' from country)
where country like 'United States%'

select distinct(country) from layoffs order by 1

---lets look at date column

select date from layoffs

--3. looking at null and blank values

select * from layoffs
where [percentage_laid_off] is null

select * from layoffs
where industry is null

--lets populate the industry null values based on their company names. for doing this lets join the table

select *
from layoffs t1 
join layoffs t2
on t1.location= t2.location  and t1.company=t2.company
where t1.industry is null 
and t2.industry is not null

--lets write the update staement

update t1
set t1.industry = t2.industry
from layoffs t1
join layoffs t2
on t1.company=t2.company
where t1.industry is null 
and t2.industry is not null

--lets check whetehr they are updated or not
select t1.industry
from layoffs t1 
join layoffs t2
on t1.location= t2.location  and t1.company=t2.company
where t1.industry is null 
and t2.industry is not null


--4.lets delete the unwanted rows and columns

select * from layoffs
--where percentage_laid_off is null
where total_laid_off = 'null'

delete from layoffs
--where percentage_laid_off is null
where total_laid_off = 'null'

select * from layoffs
--where percentage_laid_off is null
where total_laid_off = 'null'






----- EDA

select * from layoffs

select max(total_laid_off) from layoffs

SELECT *
FROM layoffs
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT top 2 company, total_laid_off
FROM layoffs
ORDER BY 2 DESC

SELECT top 10 company, SUM(total_laid_off)
FROM layoffs
GROUP BY company
ORDER BY 2 DESC


