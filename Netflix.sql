--Netflix Project

DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id VARCHAR(10),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(250),
	castS VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating  VARCHAR(10),
	duration VARCHAR(50),
	listed_in VARCHAR(100),
	description VARCHAR(250)
) 
SELECT * FROM netflix;

SELECT
	COUNT(*) FROM netflix;

SELECT type, COUNT (*)
FROM netflix
GROUP BY type;


--Some Advanced Problems


--1. Count the number of movies and TV shows
SELECT type, COUNT(*)
FROM NETFLIX
group by type;


--2. Find the most common rating for movies and TV shows
SELECT type,rating
FROM 
(SELECT type, rating,
COUNT(*),
RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY 1,2) AS most_common_rating
WHERE ranking=1;


--3. List all the movies released in a specific year(eg. 2021)
SELECT release_year, title
FROM netflix
WHERE type = 'Movie'
ORDER BY release_year, title;


--4. Find the top 5 countries with the most content on Netflix
SELECT UNNEST(STRING_TO_ARRAY(country, ', ')) AS country_cleaned,
	   COUNT(show_id) AS total_content
FROM netflix
WHERE country IS NOT NULL
GROUP BY country_cleaned
ORDER BY total_content DESC
LIMIT 5;


--5. Identify the longest movie
SELECT title, duration
FROM netflix
WHERE type='Movie'
AND 
duration=(SELECT MAX(duration) FROM netflix);


--6. Find the content added in the last 5 years
SELECT type, date_added, title, rating
FROM netflix
WHERE TO_DATE(date_added,'Month DD, YYYY')>= CURRENT_DATE- INTERVAL '5 years';


--7. Find all the movies and shows by the director 'Rajiv Chilaka'
SELECT type, title, director
FROM netflix
WHERE director ILIKE'%Rajiv Chilaka%';


--8. List all TV shows with more than 5 seasons
SELECT title, release_year, rating, duration, listed_in
FROM netflix
WHERE type ='TV Show'
AND SPLIT_PART(duration, ' ',1)::numeric>5;


--9. Count the number of content items in each genre
SELECT UNNEST(STRING_TO_ARRAY(listed_in,',')) AS genre, COUNT(show_id)
FROM netflix
GROUP BY genre;


--10. Find the average amount of content released by India on Netflix and return to the top 5 year with the highest average amount of content released
SELECT EXTRACT(YEAR FROM TO_DATE(date_added,'Month DD, YYYY')) AS year,COUNT(*),
ROUND(COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country ='India')::numeric *100,2) AS avg_content_per_year
FROM netflix
WHERE country='India'
GROUP BY 1
ORDER BY 1;


--11. List all the movies that are documentaries
SELECT title,director,rating,listed_in
FROM netflix
WHERE type='Movie'
AND 
listed_in ILIKE'%Documentaries%';


--12. Find all the content without director
SELECT type, title, rating
FROM netflix
WHERE director IS NULL;


--13. Find how many movies 'Salman Khan' did in last 10 years
SELECT type, title, director, release_year, rating
FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND 
release_year>=EXTRACT(YEAR FROM CURRENT_DATE)-10
ORDER BY release_year;


--14. Find the top 10 actors who have appeared in the highest number of movies produced in India
SELECT
UNNEST(STRING_TO_ARRAY(casts, ',')) AS actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE'%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


--15. Categorise the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
SELECT type, title, director, rating, duration,
CASE
WHEN description ILIKE '%kill%'
OR  description ILIKE '%violence%'
THEN 'Bad Content'
ELSE 'Good Content'
End category
FROM netflix;
 






