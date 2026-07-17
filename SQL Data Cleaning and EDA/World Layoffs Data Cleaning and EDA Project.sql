-- DATA CLEANING AND EDA ON WORLD LAYOFFS DATA

-- DATA CLEANING
select *
from layoffs
;

select count(*)
from layoffs
;

create table layoffs_stg
like layoffs;

select *
from layoffs_stg
;

insert layoffs_stg
select *
from layoffs
;

select *
from layoffs_stg
;
-- here I created a copy of the dataset to keep the raw data untouched

-- first i will check for and remove duplicates

with dupe_cte as
(
select *,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num -- partitioning over all columns to catch any possible dupes
from layoffs_stg
)
select *
from dupe_cte
where row_num > 1
;

select *
from layoffs_stg
where company = 'Casper'
or company = 'Cazoo'
or company = 'Hibob'
or company = 'Wildlife Studios' 
or company = 'Yahoo'
order by 1
; -- checking that we really do have duplicates

CREATE TABLE `layoffs_stg2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_stg2;

insert into layoffs_stg2
select *,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) as row_num
from layoffs_stg
;

delete from layoffs_stg2
where row_num > 1
;

select *
from layoffs_stg2
where company = 'Casper'
; -- dupes have been removed

select distinct(company)
from layoffs_stg2
;

select company, trim(company)
from layoffs_stg2
;

 update layoffs_stg2
 set company = trim(company)
 ;
 
 select *
from layoffs_stg2
;

 select distinct(location)
from layoffs_stg2
order by location
; -- problems with malmo, malmA, 

select *
from layoffs_stg2
where location like 'malm%'
;

select distinct(company)
from layoffs_stg2
;

 update layoffs_stg2
 set location = 'Malmo'
 where location like 'malm%'
 ;
 
update layoffs_stg2
set location = trim(location)
;
 
select distinct(industry)
from layoffs_stg2
order by 1
;

select *
from layoffs_stg2
where industry like 'crypto%'
order by company desc
;

update layoffs_stg2
set industry = 'Crypto'
where industry like 'crypto%'
; -- multiple names for crypto industries. putting them all under Crypto

update layoffs_stg2
set industry = null
where industry = ''
; -- we have empty non-null industrty. standardising now to avoid problems later

select *
from layoffs_stg2
;

update layoffs_stg2
set industry = trim(industry)
;

update layoffs_stg2
set percentage_laid_off = trim(percentage_laid_off)
;

select *
from layoffs_stg2
where percentage_laid_off = ''
;

alter table layoffs_stg2
modify column percentage_laid_off double
; -- converting percentage laid off column from text to double precision

select `date`, str_to_date(`date`, '%m/%d/%Y')
from layoffs_stg2
;

update layoffs_stg2
set `date` = str_to_date(`date`, '%m/%d/%Y')
; -- formatting date column 

alter table layoffs_stg2
modify column `date` date
; --  converting date column from int to date

select *
from layoffs_stg2
;

update layoffs_stg2
set stage = trim(stage)
;

select distinct(stage)
from layoffs_stg2
order by 1
; -- we have null values here, but we dont know what to do with them yet

select *
from layoffs_stg2
where stage is null
;

select distinct(country), trim(trailing '.' from country), trim(country)
from layoffs_stg2
order by 1
;

update layoffs_stg2
set country = trim(country)
;

update layoffs_stg2
set country = trim(trailing '.' from country)
; -- removing . from end of united states

select * 
from layoffs_stg2
where funds_raised_millions is null
;

select *
from layoffs_stg2
where industry is null
;

select *
from layoffs_stg2
where company = 'airbnb'
;

select t1.industry, t2.industry
from layoffs_stg2 t1
join layoffs_stg2 t2
	on t1.company = t2.company
    and t1.location = t2.location
where t1.industry is null
and t2.industry is not null
;


update layoffs_stg2 t1
join layoffs_stg2 t2
	on t1.company = t2.company
    and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null
; -- populating the null industries with the other rows based on the company name and location it is in.

select *
from layoffs_stg2
where industry is null
;

select *
from layoffs_stg2
where company like 'bally%'
; -- this company only has one row entry so we could not populate it

select * 
from layoffs_stg2
where `date` is null
; 

select *
from layoffs_stg2
where company = 'blackbaud'
; -- null date

select * 
from layoffs_stg2
where stage = 'unknown'
; 
select * 
from layoffs_stg2
where stage is null
; 

select count(*)
from layoffs_stg2
;

create table layoffs_stg3
like layoffs_stg2;

insert layoffs_stg3 -- creating a table backup before removing rows
select *
from layoffs_stg2;

select *
from layoffs_stg2
where total_laid_off is null
and percentage_laid_off is null
; -- many rows where both total laid off and percentage laid off null. will be difficult to use these rows ans little insight can be made on layoffs.alter


delete
from layoffs_stg2
where total_laid_off is null
and percentage_laid_off is null
; -- removing these rows as little insight can be made on layoffs


select *
from layoffs_stg2
where percentage_laid_off is null
and funds_raised_millions is null
order by 1
; -- little insight can be made on layoff trends when both values are null

delete
from layoffs_stg2
where percentage_laid_off is null
and funds_raised_millions is null
;

select *
from layoffs_stg2
where total_laid_off is null
and funds_raised_millions is null
; -- little insight can be made on layoff trends when both values are null

delete
from layoffs_stg2
where total_laid_off is null
and funds_raised_millions is null
;


select *
from layoffs_stg2
where stage is null
;


-- at this point, I am happy with how my database currently looks for now and can start my EDA

alter table layoffs_stg2
drop column row_num
;

select * 
from layoffs_stg2
;

select count(*)
from layoffs_stg2
;
-- -------------------------------------------------------------------------------------------------------------------------
-- EDA


select min(`date`), max(`date`)
from layoffs_stg2 -- data is over a roughly 3 year time period
;

select max(total_laid_off), min(total_laid_off), avg(total_laid_off)
from layoffs_stg2
;

select *
from layoffs_stg2
where percentage_laid_off = 1
order by total_laid_off desc
;

select industry, sum(total_laid_off)
from layoffs_stg2
group by industry
order by 2 desc 
; -- the consumer industry washit the hardest in terms of layoffs

select country, sum(total_laid_off)
from layoffs_stg2
group by country
order by 2 desc
; -- usa had the most layoffs by a large margin

select company, sum(total_laid_off)
from layoffs_stg2
group by company
order by 2 desc
; -- amazon, google, meta

select stage, sum(total_laid_off)
from layoffs_stg2
group by stage
order by 2 desc
; -- most layoffs happened in the post ipo stage of a company,followed by aquisition


select funds_raised_millions, total_laid_off, percentage_laid_off
from layoffs_stg2
where funds_raised_millions is not null
and total_laid_off is not null
and percentage_laid_off is not null
order by 1 desc
;


select year(`date`), sum(total_laid_off)
from layoffs_stg2
group by year(`date`)
order by 1 desc
;

select month(`date`), sum(total_laid_off)
from layoffs_stg2
where month(`date`)
group by month(`date`)
order by 1 asc
;

select substring(`date`, 1,7) as `month`, sum(total_laid_off)
from layoffs_stg2 
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc
;

with rolling_total as 
(
select substring(`date`, 1,7) as `month`, sum(total_laid_off) as tot_layoff
from layoffs_stg2 
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc
)
select `month`, tot_layoff, 
sum(tot_layoff) over(order by `month`) as rolling_total
from rolling_total
;

select company, year(`date`),sum(total_laid_off)
from layoffs_stg2
group by company, year(`date`)
order by 3 desc
;

with company_year (company, years, total_laid_off) as 
(
select company, year(`date`),sum(total_laid_off)
from layoffs_stg2
group by company, year(`date`)
), company_years_rank as
(
select *, dense_rank() over( partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_years_rank
where ranking <= 5
;

select company, count(company)
from layoffs_stg2
group by company
order by 2 desc
;

select *
from layoffs_stg2
where company = 'loft'
order by `date`
;

select *
from layoffs_stg2
where company = 'uber'
order by `date`
;

select *
from layoffs_stg2
where company = 'netflix'
order by `date`
;

with company_stage (company, stage, total_laid_off) as 
(
select company, stage,sum(total_laid_off)
from layoffs_stg2
group by company, stage
), company_stage_rank as
(
select *, dense_rank() over( partition by stage order by total_laid_off desc) as ranking
from company_stage
where stage is not null
)
select *
from company_stage_rank
where ranking <= 5
;




select * from layoffs_stg2;


with company_layoffs as 
(
select company, `date`, total_laid_off, 
	lag(`date`) over(partition by company order by `date`) as previous_layoff_date
from layoffs_stg2
where `date` is not null
)
select company, `date` as current_layoff_date, previous_layoff_date, datediff(`date`, previous_layoff_date) as days_between_layoffs, total_laid_off
from company_layoffs
where previous_layoff_date is not null
order by company -- order by days_between_layoffs
; -- showing companies that had multiple layoff rounds and days between each round



with layoff_rounds as ( 
select company, `date`, total_laid_off,
	row_number() over(partition by company order by `date`) as roundnum
from layoffs_stg2
where total_laid_off is not null
)
select r1.company, r1.total_laid_off as round1_layoffs, 
	r2.total_laid_off as round2_layoffs, 
    (r2.total_laid_off - r1.total_laid_off) as headcount_difference,
    r1.date as round1_date,
    r2.date as round2_date
from layoff_rounds r1
join layoff_rounds r2
	on r1.company = r2.company
    and r1.roundnum = 1
    and r2.roundnum = 2
order by headcount_difference desc
; -- this shows the difference between the first round of layoffs compared to the next 

select * from layoffs_stg2 where company = 'twitter';

select 
case
	when percentage_laid_off = 1 then 'Full layoff'
    else 'Partial layoff'
    end as layoff_type,
    count(distinct(company)) as number_of_companies,
    round(avg(funds_raised_millions), 2) as avg_funds_raised_millions,
    sum(total_laid_off) as total_laid_off
from layoffs_stg2
where percentage_laid_off is not null
group by layoff_type
order by number_of_companies
; -- comparing raised funds of companies that shut down compared to those who only downsized.


select stage, 
	count(company) as bankrupt_companies,
	sum(funds_raised_millions) as total_funds_lost
from layoffs_stg2
where percentage_laid_off = 1
	and stage is not null
    and stage != 'Unknown'
group by stage
order by bankrupt_companies desc
; -- looking at which stage companies were in before going bankrupt


select * from layoffs_stg2
order by funds_raised_millions desc;

with headcount_efficiency as 
(
select company, industry, total_laid_off, funds_raised_millions, 
	round((total_laid_off / funds_raised_millions), 2) as layoffs_per_million
from layoffs_stg2
where total_laid_off is not null
and funds_raised_millions is not null
and funds_raised_millions > 0
),
funds_raised_percentiles as (
	select *, 
		ntile(10) over(order by funds_raised_millions desc) as funding_percentiles
	from headcount_efficiency
)
select funding_percentiles, count(company) as total_companies,
	round(avg(layoffs_per_million), 2) as avg_layoffs_per_million,
    round(avg(funds_raised_millions), 2) as avg_funds_raised_per_million,
    sum(total_laid_off) as total_percentile_layoffs
from funds_raised_percentiles
group by funding_percentiles
order by funding_percentiles
; -- showing layoffs per million based on company funding


with headcount_efficiency as 
(
select company, industry, total_laid_off, funds_raised_millions, 
	round((total_laid_off / funds_raised_millions), 2) as layoffs_per_million,
    ntile(10) over(order by funds_raised_millions desc) as funding_percentiles
from layoffs_stg2
where total_laid_off is not null
and funds_raised_millions is not null
and funds_raised_millions > 0
)
select company, industry, funds_raised_millions, total_laid_off, layoffs_per_million
from headcount_efficiency
where funding_percentiles = 1
order by layoffs_per_million desc
; -- looking at thelayoffs for the companies with the top 10% highest funding 



select country,
    sum(case when year(`date`) = 2020 then total_laid_off else 0 end) AS 2020_layoffs,
    sum(case when year(`date`) = 2021 then total_laid_off else 0 end) AS 2021_layoffs,
    sum(case when year(`date`) = 2022 then total_laid_off else 0 end) AS 2022_layoffs,
    sum(case when year(`date`) = 2023 then total_laid_off else 0 end) AS 2023_layoffs,
    sum(total_laid_off) as total_layoffs
from layoffs_stg2
where `date` is not null
group by country
order by total_layoffs desc
limit 10
; -- where countries were hit with layoffs per year

with yearly_layoffs as (
select country, 
	sum(case when year(`date`) = 2020 then total_laid_off else 0 end) AS 2020_layoffs,
    sum(case when year(`date`) = 2021 then total_laid_off else 0 end) AS 2021_layoffs,
    sum(case when year(`date`) = 2022 then total_laid_off else 0 end) AS 2022_layoffs,
    sum(case when year(`date`) = 2023 then total_laid_off else 0 end) AS 2023_layoffs,
    sum(total_laid_off) as total_layoffs
from layoffs_stg2
group by country
)
select country, 2020_layoffs, 2021_layoffs, 2022_layoffs, 2023_layoffs, total_layoffs,
case
	when 2020_layoffs = 0 then null
    else round(((2021_layoffs - 2020_layoffs) / 2020_layoffs) * 100, 2)
end as yoy_2020_to_2021,
case
	when 2021_layoffs = 0 then null
    else round(((2022_layoffs - 2021_layoffs) / 2021_layoffs) * 100, 2)
end as yoy_2021_to_2022,
case
	when 2022_layoffs = 0 then null
    else round(((2023_layoffs - 2022_layoffs) / 2022_layoffs) * 100, 2)
end as yoy_2022_to_2023
from yearly_layoffs
where 2020_layoffs > 1000
or 2021_layoffs > 1000
or 2022_layoffs > 1000
order by total_layoffs desc
; -- the year to year percentage change of layoff per countries


with ranked_layoffs as (
select industry, percentage_laid_off, 
	row_number() over(partition by industry order by percentage_laid_off) as rownum,
    count(*) over(partition by industry) as total_rows
from layoffs_stg2
where percentage_laid_off is not null
and industry is not null
)
select industry,
	round(avg(percentage_laid_off), 2) as median_percentage_laid_off
from ranked_layoffs
where rownum in (floor((total_rows +1) / 2), ceil((total_rows +1) / 2))
group by industry
order by median_percentage_laid_off desc
; -- mediands of percentage laid off for each indusrty

select * from layoffs_stg2;


select industry, 
	count(distinct(company)) as companies_impacted,
	sum(total_laid_off) as total_industry_layoffs,
    round(sum(total_laid_off) / count(distinct(company)), 0) as avg_layoffs_per_impacted_company
from layoffs_stg2
where industry is not null
group by industry
order by companies_impacted desc
; -- number of unique companies impacted by layoffs per industry


with company_cohorts as (
select company,
	min(year(`date`)) as cohort_year
from layoffs_stg2
where `date` is not null
group by company
),
layoffs_timeline as (
select l.company, c.cohort_year, 
	year(l.`date`) as layoff_year,
    (year(l.`date`) - c.cohort_year) as years_since_first_layoff,
    l.total_laid_off
from layoffs_stg2 l 
join company_cohorts c
	on l.company = c.company
where l.`date` is not null
and l.total_laid_off is not null
)
select cohort_year, 
	count(distinct(company)) as total_companies_in_cohort, 
    sum(case when years_since_first_layoff = 0 then total_laid_off else 0 end) as year0_layoffs,
    sum(case when years_since_first_layoff = 1 then total_laid_off else 0 end) as year1_layoffs,
    sum(case when years_since_first_layoff = 2 then total_laid_off else 0 end) as year2_layoffs,
    sum(case when years_since_first_layoff = 3 then total_laid_off else 0 end) as year3_layoffs
from layoffs_timeline
group by cohort_year
order by cohort_year
; -- company cohorted by year of first layoff, and layoffs since in the next years
    



    
