USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`. 

SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in 
--     upper case letters. Name the column `Actor Name`. 

SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

-- 2a.  You need to find the ID number, first name, and last name of 
--      an actor, of whom you know only the first name, "Joe." What is 
--      one query would you use to obtain this information?


SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = "Joe";
-- 2b.  Find all actors whose last name contain the letters `GEN`


SELECT actor_id, first_name, last_name  
FROM actor
WHERE last_name like '%GEN%';


-- 2c. Find all actors whose last names contain the letters `LI`. 
--     This time, order the rows by last name and first name, in that order:

	
SELECT actor_id, last_name, first_name 
FROM actor
WHERE last_name like '%LI%';


-- 2d. Using `IN`, display the `country_id` and `country` columns of 
--     the following countries: Afghanistan, Bangladesh, and China

SELECT country_id, country
FROM country
WHERE country IN 
('Afghanistan', 'Bangladesh', 'China');


-- 3a. Add a `middle_name` column to the table `actor`. Position it between
--     `first_name` and `last_name`. Hint: you will need to specify the data type

ALTER TABLE actor
ADD column middle_name VARCHAR(25) AFTER first_name;


-- 3b. You realize that some of these actors have tremendously long middle names. 
-- Change the data type of the `middle_name` column to `blobs`.

ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;


-- 3c. Now delete the `middle_name` column.

ALTER TABLE actor
DROP COLUMN middle_name;


-- * 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS 'Number of Actors' 
FROM actor GROUP BY last_name;



-- 4b. List last names of actors and the number of actors who have that last name, 
--     but only for names that are shared by at least two actors


SELECT last_name, COUNT(*) AS 'Number of Actors' 
FROM actor GROUP BY last_name HAVING COUNT(*) >=2;


-- 4c.The actor `HARPO WILLIAMS` was accidentally entered in the `actor` 
--     table as `GROUCHO WILLIAMS`, Write the quary to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";



-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that 
-- GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently

UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;



-- 5a. You cannot locate the schema of the `address` table. Which query
--     would you use to re-create it?

DESCRIBE sakila.address;


-- 6a. Use `JOIN` to display the first and last names, as well as the
--     address, of each staff member. Use the tables `staff` and `address`:

SELECT first_name, last_name, address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;

-- 6b. Use `JOIN` to display the total amount rung up by each staff member
--     in August of 2005. Use tables `staff` and `payment`.

SELECT p.staff_id, s.last_name, p.amount, p.payment_date, p.last_update
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id AND p.payment_date LIKE '2005-08%';

-- 6c. List each film and the number of actors who are listed for that film. 
--     Use tables `film_actor` and `film`. Use inner join.

SELECT f.title AS 'Film Tittle', COUNT(fa.actor_id) AS 'Number of Actors'
FROM film_actor fa
JOIN film f
ON fa.film_id = f.film_id
GROUP BY f.title;

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT f.title,count(i.inventory_id)
FROM film f
JOIN inventory as i ON f.film_id = i.film_id 
WHERE f.title = "Hunchback Impossible";

-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total
--     paid by each customer. List the customers alphabetically by last name:

SELECT c.first_name, c.last_name, c.customer_id, SUM(p.amount) AS `Total Paid`
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY customer_id
ORDER BY c.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
--     As an unintended consequence, films starting with the letters `K` and `Q` have
--     also soared in popularity. Use subqueries to display the titles of movies
--     starting with the letters `K` and `Q` whose language is English.

SELECT title FROM film
WHERE language_id IN (
SELECT language_id FROM language 
WHERE name = 'English') AND (title like 'K%') OR (title like 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name FROM actor
WHERE actor_id IN (
SELECT actor_id FROM film_actor
WHERE film_id IN(
SELECT film_id FROM film
WHERE title = 'Alone Trip'));


-- 7c. You want to run an email marketing campaign in Canada, for which you 
--     will need the names and email addresses of all Canadian customers. 
--     Use joins to retrieve this information.

SELECT c.first_name, c.last_name, c.email, country.country
FROM customer c
JOIN country on country.country_id = c.customer_id
WHERE country.country = "Canada";

-- * 7d. Sales have been lagging among young families, and you wish
--       to target all family movies for a promotion. Identify all movies 
--       categorized as famiy films.
select c.name, title from category c
join film_category fc on c.category_id = fc.category_id
join film f on fc.film_id = f.film_id
where name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);

--  7h. List the top five genres in gross revenue in descending order. 
--      (**Hint**: you may need to use the following tables: category,
--       film_category, inventory, payment, and rental.)

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

--  8a. In your new role as an executive, you would like to have an easy 
--      way of viewing the Top five genres by gross revenue. Use the solution
--      from the problem above to create a view. If you haven't solved 7h, you
--      can substitute another query to create a view.

CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

--  8b. How would you display the view that you created in 8a?

SELECT * FROM genre_revenue;

--  8c. You find that you no longer need the view `top_five_genres`. 
--      Write a query to delete it.

DROP VIEW genre_revenue;