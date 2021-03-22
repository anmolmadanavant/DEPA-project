Select distinct f.msa_id, d.* 
from fact_msa f
join dim_location d
on f.msa_id = d.msa_id
where f.date_id = 24
Order by gdp desc;

SELECT y.year, sum(GDP), sum(personal_income), sum(population), avg(zillow_home_value_index)
from fact_msa f
join dim_location d
on f.msa_id = d.msa_id
join dim_year y 
on f.date_id = y.date_id
where state = "DC"
group by 1
order by 1
;

-- Which cities have the best growth potential (GDP growth by industry) and cheap HVI


SELECT a.*, CONCAT('$', FORMAT(b.zillow_home_value_index,0)) AS 'Home Value Index' FROM
(SELECT 
	name AS MSA, industry_name as Industry, avg(gdp_change) AS 'Average Change in GDP'
FROM fact_industry f
	JOIN dim_industry i ON f.industry_id = i.industry_id
		JOIN dim_location l ON l.msa_id = f.msa_id2
			JOIN dim_year y on y.date_id = f.date_id2
WHERE industry_name IN 
		('Natural resources and mining','Trade','Transportation and utilities','Government and government enterprises','Manufacturing','Information'
         , 'Professional and business services','Arts, entertainment, recreation, accommodation, and food services', 'Finance and insurance', 'Real estate and rental and leasing'
         , 'Educational services', 'Health care and social assistance' )
	AND year = 2019 
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 100) AS a
JOIN 
(SELECT name,  zillow_home_value_index
FROM fact_msa f
	JOIN dim_location l ON f.msa_id = l.msa_id
		JOIN dim_year y on y.date_id = f.date_id
WHERE year = 2019 
	  AND zillow_home_value_index != 0
ORDER BY zillow_home_value_index
) AS b 
on a.MSA = b.name
ORDER BY 3 DESC, 4;


SELECT
    s.msa_id,
    s.name,
   f.zillow_home_value_index,
   (f.personal_income/f.population)*1000 AS PersonalInc_per_Capita
FROM
    fact_msa AS f
        INNER JOIN
    dim_location AS s ON f.msa_id = s.msa_id
WHERE f.date_id = 24 and s.msa_id = 355
HAVING HVI_Per_PersonalInc_per_Capita <>0
ORDER BY HVI_Per_PersonalInc_per_Capita ASC;




# How do different MSAs rank by HVI and is that linked to land_area?


