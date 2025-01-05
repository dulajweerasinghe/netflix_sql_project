-- Create Netflix Table
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);

-- Find number of content 

		SELECT * FROM netflix; 

		select count(*) as total_content
		from netflix;

-- 2. Count the Number of Movies vs TV Shows
--- find no of types 

		select distinct type
		from netflix;

		select type, count(*) as total_content
		from netflix
		group by type;

-- 3. Find the Most Common Rating for Movies and TV Shows

select type, rating
From netflix;

select distinct rating
from netflix;

select type, rating, count(*)
-- max(rating)
FROM netflix
group by 1,2
order by 1,3 desc;

-- Most Common Rating -- 
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;

-- 4.  List All Movies and TV show Released in a Specific Year (e.g., 2020)

		select count (*)
		FROM netflix
		where release_year = 2020;

--- List All Movies  Released in a Specific Year (e.g., 2020)

		select *
		FROM netflix
		where type = 'Movie' and release_year = 2020;
		
-- 5.Find the Top 5 Countries with the Most Content on Netflix

		select country, count(show_id) as total_content
		from netflix
		group by 1;

		select UNNEST(string_to_array (country, ',')) as new_country 
		from netflix;

		select UNNEST(string_to_array (country, ',')) as new_country, count(show_id) as total_content
		from netflix
		group by 1
		order by total_content desc;
		
		select UNNEST(string_to_array (country, ',')) as new_country, count(show_id) as total_content
		from netflix
		group by 1
		order by total_content desc
		limit 5;
		
-- 6 Identify the Longest Movie

		select max(duration) from netflix;

		select *
		from netflix
		where type = 'Movie' and duration = (select max(duration) from netflix) ;
		
-- 7 Find Content Added in the Last 5 Years

		select current_date - INTERVAL '5 Years'
		
		select *
		from netflix
		where TO_DATE (date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
	
-- 8. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

		select * FROM netflix
		where director = 'Rajiv Chilaka';

		select count(*)
		FROM netflix
		where director = 'Rajiv Chilaka';
		
		select *
		FROM netflix
		where director LIKE '%Rajiv Chilaka%';
		
--  Find All Movies/TV Shows by Director 'Kirsten Johnson'
	
		select *
		FROM netflix
		where director LIKE '%Kirsten Johnson%';
		
	-- Delhiprasad Deenadayalan
		select *
		FROM netflix
		where director LIKE '%Delhiprasad Deenadayalan%';
	
		
--  9. List All TV Shows with More Than 5 Seasons

		select *
		from netflix
		where type = 'TV Show' and duration > '5 sessions'
		
		select *,
			duration
		from netflix
		where type = 'TV Show' and duration > '5 sessions'
		

		SELECT *
		FROM netflix
		WHERE type = 'TV Show'
  		AND SPLIT_PART(duration, ' ', 1)::INT > 5;
		
-- 10. Count the Number of Content Items in Each Genre

		select listed_in, show_id, 
		from netflix;
		
		select UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre, count(show_id) as total_content
		from netflix
		group by 1;
		
-- 11. Find each year and the average numbers of content release in India on netflix.
--- return top 5 year with highest avg content release!

		select *
		from netflix
		where country = 'India';
		
		select extract(year from TO_DATE(date_added, 'Month DD, YYYY')) as year, count(*)
		from netflix
		Group by 1;
	
		select extract(year from TO_DATE(date_added, 'Month DD, YYYY')) as year, count(*)
		from netflix
		where Country = 'India'
		Group by 1;
		
		-- avg content release United States
		
		select extract(year from TO_DATE(date_added, 'Month DD, YYYY')) as year, count(*)
		from netflix
		where Country = 'United States'
		Group by 1;
		
	
		-- avg content release India 
		
		select extract(year from TO_DATE(date_added, 'Month DD, YYYY')) as year, count(*) as yearly_content, 
			ROUND(count(*):: numeric/(select count (*) from netflix where country = 'India'):: numeric  * 100,2) as avg_content_per_year
		from netflix
		where Country = 'India'
		Group by 1;
		
		-- avg content release United States
		
		select extract(year from TO_DATE(date_added, 'Month DD, YYYY')) as year, count(*) as yearly_content, 
			ROUND(count(*):: numeric/(select count (*) from netflix where country = 'India'):: numeric  * 100,2) as avg_content_per_year
		from netflix
		where Country = 'United States'
		Group by 1;
		
		
-- 12. List All Movies that are Documentaries

		select *
		from netflix
		where listed_in LIKE  '%Documentaries%';

		select *
		from netflix
		where listed_in  ilike  
		'%documentaries%';
		
-- 13. Find All Content Without a Director

		select *
		from netflix
		where director is NULL;

		select count(*)
		from netflix
		where director is NULL;
		
-- 14. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 15 Years

		select *
		from netflix
		where casts ilike '%Salman Khan%';

		select *
		from netflix
		where casts ilike '%Salman Khan%' and release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15

--  Find How Many Movies Actor 'Leonardo DiCaprio,' Appeared in the Last 15 Years

		select *
		from netflix
		where casts ilike '%Leonardo DiCaprio%' and release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15

--  Find How Many Movies Actor 'Vijay Sethupathi' Appeared in the Last 15 Years
		select *
		from netflix
		where casts ilike '%Vijay Sethupathi%' and release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 15
		
-- 15. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

		select show_id, casts, UNNEST(STRING_TO_ARRAY(casts,','))
		from netflix;
	
		select UNNEST(STRING_TO_ARRAY(casts,',')) as Actors, Count(*) as Total_content
		from netflix
		Group By 1
		ORDER BY 2 desc;
		
		select UNNEST(STRING_TO_ARRAY(casts,',')) as Actors, Count(*) as Total_content
		from netflix
		where country ILIKE '%India%'
		Group By 1
		ORDER BY 2 desc
		Limit 10;
		
		-- Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in United States
		
		select UNNEST(STRING_TO_ARRAY(casts,',')) as Actors, Count(*) as Total_content
		from netflix
		where country ILIKE '%United States%'
		Group By 1
		ORDER BY 2 desc
		Limit 10;
		
-- 16. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

		select *, CASE
					WHEN description ILIKE '%Kill%' OR 
					description ILIKE '%violence%' THEN 'Bad_Content' ELSE 'Good_Content'
					END category
		From netflix;
		
	-- No of Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
	
		with new_table
		AS ( select *, CASE
					WHEN description ILIKE '%Kill%' OR 
					description ILIKE '%violence%' THEN 'Bad_Content' ELSE 'Good_Content'
					END category
		From netflix)
		
		select category, count(*) As content_count
		from new_table
		group by 1
		
		
		
		
		
		

