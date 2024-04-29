create database casestudy
use casestudy


/* Basic Data Understanding Proccess */

select COUNT(*)Total_rows from creditcard_analysis

SELECT COUNT (*)Total_columns FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG='casestudy' and TABLE_SCHEMA = 'dbo' 
AND TABLE_NAME = 'creditcard_analysis'

select * from INFORMATION_SCHEMA.COLUMNS where TABLE_NAME='creditcard_analysis'




select COUNT(distinct [index])Index_unique_value from creditcard_analysis

select COUNT(distinct City)City_unique_vale from creditcard_analysis

select COUNT(distinct date)Date_unique_value from creditcard_analysis

select COUNT(distinct [Card Type])Cardtype_unique_value from creditcard_analysis

select COUNT(distinct [Exp Type])Exptype_unique_value from creditcard_analysis

select COUNT(distinct Gender)gender_unique_value from creditcard_analysis

select COUNT(distinct Amount)amount_unique_value from creditcard_analysis


/*
RangeIndex: 26052 entries, 0 to 26051
Data columns (total 7 columns):

index, has 26052 unique values.
City, has 986 unique values.
Date, has 600 unique values.
Card Type, has 4 unique values.
Exp Type, has 6 unique values.
Gender, has 2 unique values.
Amount, has 24972 unique values. */


select * from creditcard_analysis
/* Data Wrangling and Feature Engineering */


select b.*, case when a.Date=b.Date then DAY(a.Date) end [Day],
case when a.Date=b.Date then month(a.Date) end [Month],
case when a.Date=b.Date then year(a.Date) end [Year]
from creditcard_analysis a join creditcard_analysis b
on a.[index]=b.[index]



---26052 rows × 10 columns

---(we have updated the table in further queries thats why here it is showing 11 tables)



---Updated Table

---(we have segregated the city column in two columns one is city and the other one is country)


with cte1 as(
select *,day(Date)day,MONTH(Date)month,YEAR(Date)year from creditcard_analysis
) ,
cte2 as
(
select [index],SUBSTRING(City,1,CHARINDEX(',',city)-1) city,
SUBSTRING(City,CHARINDEX(',',city)+1,(LEN(city)-len(SUBSTRING(City,1,CHARINDEX(',',city)-1))))country
from creditcard_analysis
)select cte1.[index],cte2.city,cte2.country,cte1.day,cte1.month,cte1.year,cte1.[card type],cte1.[exp type],
cte1.[gender],cte1.[amount],cte1.deal_size
 from cte2  join cte1  
on cte1.[index]=cte2.[index]


---26052 rows × 11 columns



/*percentage of each gender */ 



select count(Gender)total_count,count(case when Gender='m' then gender  end )male_count,
count(case when Gender='f' then gender end)female_count,
round(count(case when Gender='m' then gender  end )*1.0/count(Gender)*100,1) male_percentage,
round(count(case when Gender='f' then gender  end )*1.0/count(Gender)*100,1) female_percentage,
round(count(case when Gender='f' then gender  end )*1.0/count(Gender)*100,1)-
round(count(case when Gender='m' then gender  end )*1.0/count(Gender)*100,1)difference
from creditcard_analysis




/* percentage of each card type*/




with cte as(
select [Card Type], count([Card Type])countn
from creditcard_analysis 
group by [Card Type])select *,sum(countn) over()total_count,
round(1.0*countn/sum(countn) over()*100,1)percentage_share
from cte




/* percentage of each exp type */



with cte as(
select [Exp Type],count([Exp Type])countn
from creditcard_analysis
group by [Exp Type])select *,sum(countn) over ()total_count,
round(1.0*countn/sum(countn) over ()*100,2)percentage_share
from cte order by percentage_share desc






/* percentage of each deal size */




alter table creditcard_analysis
alter column amount float




select *,sum(count_of_amount) over()total_sum,
round(1.0*count_of_amount/sum(count_of_amount) over()*100,2) percentage_share
from
(select deal_size,COUNT(Amount)count_of_amount from
(select case when amount<= 77120 then 'small' 
when amount>77120 and Amount <= 153106 then 'medium'
when amount>153106 and Amount<= 228050 then 'large'
else 'extra_large' end deal_size,amount
from creditcard_analysis)a group by deal_size)b




alter table creditcard_analysis
add  Deal_size varchar(50)

update creditcard_analysis
set deal_size=
(select case when amount<= 77120 then 'small' 
when amount>77120 and Amount <= 153106 then 'medium'
when amount>153106 and Amount<= 228050 then 'large'
else 'extra_large' end Deal_size
)





/*Observations 1: 

1. In the data, female users is 5% higher than male users.
2. The most common spending type is food->fuel->bills->entertainment->grocery and the least is travel
3. Silver is the most popular card type, slightly higher (1.5%) than 3 other card types
4. Deal size is segmented into 4 equal sizes, meets our expectation because it's defined by the amount 
   dispersion, I'm interested in the gender and spending type wthin 4 deal sizes

*/




/* Credit card using habit by Gender */


--card type cross gender

select *, sum(count_of_m_f) over()total_sum,
round(1.0*count_of_m_f/sum(count_of_m_f) over()*100,1)percentage_share
from 
(select [Card Type],Gender,case when Gender='m'then COUNT(gender)
when Gender='f' then COUNT(Gender)end count_of_m_f 
from creditcard_analysis
group by [Card Type],gender
)a group by Gender,[Card Type],count_of_m_f
order by [Card Type]



---card type cross exp_type

select *,SUM(sum_count) over ()total_count,
round(1.0*sum_count/SUM(sum_count) over ()*100,1) percentage_share from
(select [Exp Type],Gender,count(Gender)sum_count from creditcard_analysis
group by [Exp Type],gender 
)a order by [Exp Type]



---deal size cross gender


select *,SUM(count) over () total_count,
round(1.0*count/SUM(count) over ()*100,1) percentage_share
from
(select Deal_size, Gender,COUNT(deal_size)count from creditcard_analysis
group by Gender,deal_size)a order by deal_size


/* Observations 2:

1. In most of the label, Female users has higher percentage than male users.
2. While comparing expense type, fuel is the only label male users use credit card more than female, 
while food and bills female surpass male 
3. When the deal size gets bigger,the range of (female-male) percentage gets larger, 
which means higher the amount is,more female tend to use credit card and males tend to 
pay by other methods
*/

/* Spending Habit by Card type */



select [Card Type],Gender,SUM(Amount)sum_amount from creditcard_analysis
group by [Card Type],Gender order by [Card Type]


select [Card Type],[Exp Type],SUM(Amount)sum_amount from creditcard_analysis
group by [Card Type],[Exp Type] order by [Card Type]



/* Observations 3

1. Interesting finding is no matter which card type, the interaction with other labels looks indentical.
2. As far as gender, 4 card types male users spend around 0.3M
3. As far as expense type, Bills stand out of other expense, while other expenses locate lower than 0.4M. */


/* Spending Trend */


---Yearly spending trend

select YEAR(date)Year,sum(Amount)Total_amount from creditcard_analysis
group by YEAR(date)


---Monthly spending trend

select month(date)months,YEAR(date)years,sum(Amount)Total_amount from creditcard_analysis
group by month(date),YEAR(date) order by years,months


--------top 50 spending spots


select City,date,sum from
(select top 50 City,date,count(city)cnt,SUM(Amount)sum from creditcard_analysis
group by city,date
order by cnt desc
)a 


----top 10 money spent


select top 10 City,[Exp Type],sum(Amount)total_sum from creditcard_analysis 
group by City,[Exp Type]
order by total_sum desc


-----buying power of top 10 city

select * from creditcard_analysis

select City,sum_amount,SUM(sum_amount) over()total_sum,
round(1.0*sum_amount/SUM(sum_amount) over()*100,2) percentage_share
from
(select top 10 City,COUNT(city)cnt,SUM(Amount)sum_amount from creditcard_analysis
group by city
order by cnt desc)a



----Expense type for largest deal size

select [Exp Type],date,sum(Amount)sum_amount from creditcard_analysis
where Deal_size='extra_large'
group by [Exp Type],date
order by [Exp Type],[date]

