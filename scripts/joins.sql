-- ** How to import your data. **

-- 1. In PgAdmin, right click on Databases (under Servers -> Postgresql 15). Hover over Create, then click Database.

-- 2. Enter in the name ‘Joins’ (not the apostrophes). Click Save.

-- 3. Left click the server ‘Joins’. Left click Schemas. 

-- 4. Right click public and select Restore.

-- 5. Select the folder icon in the filename row. Navigate to the data folder of your repo and select the file movies.backup. Click Restore.


-- ** Movie Database project. See the file movies_erd for table\column info. **

-- 1. Give the name, release year, and worldwide gross of the lowest grossing movie.


SELECT specs.film_title, specs.release_year, MIN(revenue.worldwide_gross) AS min_gross
FROM specs
LEFT JOIN revenue 
ON specs.movie_id = revenue.movie_id
GROUP BY specs.film_title, specs.release_year
ORDER BY min_gross;
--ANSWER Semi-Tough

-- 2. What year has the highest average imdb rating?


SELECT specs.release_year, AVG(imdb_rating) AS avg_rating
FROM specs
LEFT JOIN rating 
ON specs.movie_id = rating.movie_id
GROUP BY specs.release_year
ORDER BY avg_rating DESC;

--ANSWER 1991


-- 3. What is the highest grossing G-rated movie? Which company distributed it?

 
 
SELECT film_title ,mpaa_rating, worldwide_gross, company_name
FROM specs
INNER JOIN revenue
ON specs.movie_id=revenue.movie_id
INNER JOIN distributors
ON specs.domestic_distributor_id= distributors.distributor_id
WHERE mpaa_rating='G'
ORDER BY worldwide_gross DESC
LIMIT 1;

---ANSWER: Toy Story 4 distributed by Walt Disney



-- 4. Write a query that returns, for each distributor in the distributors table, the distributor name and the number of movies associated with that distributor in the movies 
-- table. Your result set should include all of the distributors, whether or not they have any movies in the movies table.


SELECT company_name AS distributor_name, COUNT(movie_id)
FROM distributors 
FULL JOIN specs
ON distributors.distributor_id=specs.domestic_distributor_id
GROUP BY company_name;



-- 5. Write a query that returns the five distributors with the highest average movie budget.
SELECT company_name, ROUND(AVG(revenue.film_budget),0)
FROM specs
INNER JOIN distributors
ON specs.domestic_distributor_id=distributors.distributor_id
INNER JOIN revenue
ON specs.movie_id = revenue.movie_id
GROUP BY company_name 
ORDER BY AVG(revenue.film_budget) DESC
LIMIT 5;

--ANSWER Walt Disney, Sony PIctures, Lionsgate, Dreamworks, Warner Bros.


-- 6. How many movies in the dataset are distributed by a company which is not headquartered in California? Which of these movies has the highest imdb rating?
-- SELECT *
-- FROM distributors

-- SELECT *
-- FROM rating 
-- ORDER BY imdb_rating  DESC;


-- SELECT company_name
-- FROM distributors
-- WHERE headquarters NOT LIKE '%CA%'; 
SELECT 
		specs.film_title,
		distributors.company_name,
		headquarters,
		rating.imdb_rating
FROM distributors
	INNER JOIN specs 
		ON distributors.distributor_id = specs.domestic_distributor_id
	INNER JOIN rating
		ON specs.movie_id = rating.movie_id
WHERE headquarters NOT LIKE '%CA%'
ORDER BY imdb_rating DESC;

--ANSWER: Dirty Dancing distibuted by Vestron Pictures based in Chicago, IL, rating of 7
--My Big Fat Greek Wedding distributed by IFC Films based in New York, NY, rating        of 6.5 
			


-- 7. Which have a higher average rating, movies which are over two hours long or movies which are under two hours?


SELECT ROUND(AVG(imdb_rating),1)
FROM specs
INNER JOIN rating
ON specs.movie_id=rating.movie_id
WHERE length_in_min <=120
--ANSWER: movies that were under 2 hrs had an avg imdb rating of 6.9 
-------------------
SELECT ROUND(AVG(imdb_rating),1)
FROM specs
INNER JOIN rating
ON specs.movie_id=rating.movie_id
WHERE length_in_min>=121
--ANSWER movies that were over 2 hrs had and avg imdb rating of 7.3

 

	


