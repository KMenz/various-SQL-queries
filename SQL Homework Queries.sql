-- 1a and b. Display First And Last Names Of Actors
select a.first_name, a.last_name, concat(a.first_name, ' ', a.last_name) as Actor_Name
from sakila.actor a;

-- 2a. Find id, fn, ln of Joe
select a.actor_id, a.first_name, a.last_name
from sakila.actor a
where a.first_name = 'Joe';

-- 2b. Actors who's name contains GEN
select a.actor_id, a.first_name, a.last_name
from sakila.actor a
where a.last_name like '%GEN%';

-- 2c. Actors who's name contains LI, with order
select a.actor_id, a.first_name, a.last_name
from sakila.actor a
where a.last_name like '%LI%'
order by a.last_name and a.first_name;

-- 2d. Locate countries 
select c.country_id, c.country
from sakila.country c
where c.country in ('Afghanistan','Bangladesh','China');

-- 3a. Create New Column For Description
ALTER TABLE sakila.actor ADD description BLOB;

-- 3b. Remove Column
ALTER TABLE sakila.actor DROP description;

-- 4a. List Last Names and Counts
select a.last_name, count(a.last_name) ln_count
from sakila.actor a
group by a.last_name;

-- 4b. List Last Names and Counts For Duplicates
select a.last_name, count(a.last_name) ln_count
from sakila.actor a
group by a.last_name
having count(a.last_name) >= 2;

-- 4c. Change Record
update sakila.actor
set first_name = 'HARPO'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS';

-- 4d. Change Record Back
update sakila.actor
set first_name = 'GROUCHO'
where first_name = 'HARPO' and last_name = 'WILLIAMS';

-- 5a. Recreate Address Table
show create table sakila.address;

-- 6a. Join For Staff Info
select s.first_name, s.last_name, a.address
from sakila.staff s
inner join sakila.address a on s.address_id = a.address_id;

-- 6b. Join For Total Amount By Staff
select s.first_name, s.last_name, sum(p.amount) Total_Amount
from sakila.staff s
inner join sakila.payment p on s.staff_id = p.staff_id
where p.payment_date between '2005-08-01' and '2005-08-31'
group by s.first_name, s.last_name;

-- 6c. Join Film actor and film
select f.title, count(fa.actor_id) Actors_In_Film
from sakila.film_actor fa
inner join sakila.film f on fa.film_id = f.film_id
group by f.title;

-- 6d. Join inventory and film
select f.title, count(i.inventory_id) inventory_count
from sakila.film f
inner join sakila.inventory i on i.film_id = f.film_id
where title = 'Hunchback Impossible'
group by f.title;

-- 6e. List Total Payment Per Customer
select c.first_name, c.last_name, sum(p.amount) total_payment
from sakila.payment p
inner join sakila.customer c on p.customer_id = c.customer_id
group by c.first_name, c.last_name
order by c.last_name;

-- 7a. Subqueries for K and Q Movies
select a.title
from sakila.language l
inner join (
	select f.title, f.language_id
	from sakila.film f
	where f.title like 'Q%' or f.title like 'K%'
	group by f.title, f.language_id ) a on l.language_id = a.language_id
where l.name = 'English'
group by a.title;

-- 7b. All Actors In Alone Trip
select a.first_name, a.last_name
from sakila.actor a
inner join (
select f.film_id, f.title, fa.actor_id
	from sakila.film f
	inner join sakila.film_actor fa on f.film_id = fa.film_id
	where title = 'Alone Trip'
    group by film_id, title, actor_id ) b on a.actor_id = b.actor_id
group by a.first_name, a.last_name;

-- 7c. Names And Email For All Canadian Customers
select c.first_name, c.last_name, c.email
from sakila.customer c
inner join sakila.address a on a.address_id = c.address_id
inner join sakila.city ci on ci.city_id = a.city_id
inner join sakila.country co on co.country_id = ci.country_id
where co.country = 'Canada'
group by c.first_name, c.last_name, c.email;

-- 7d. Identify Family Films
select f.title
from sakila.film f
inner join sakila.film_category fc on f.film_id = fc.film_id
inner join sakila.category c on c.category_id = fc.category_id
where c.name = 'Family'
group by f.title;

-- 7e. Most Frequently Rented Moves In Descending Order
select f.title, count(r.rental_id) rental_count
from sakila.film f
inner join sakila.inventory i on f.film_id = i.film_id
inner join sakila.rental r on r.inventory_id = i.inventory_id
group by f.title
order by rental_count desc;

-- 7f. How much in business each store brought in.
select store, concat('$', format(sum(total_sales), '##,##0')) total_sales
from sakila.sales_by_store
group by store;

-- 7g. For each store, it's ID, City, and Country
select s.store_id, ci.city, co.country
from sakila.store s
inner join sakila.address a on s.address_id = a.address_id
inner join sakila.city ci on ci.city_id = a.city_id
inner join sakila.country co on co.country_id = ci.country_id
group by s.store_id, ci.city, co.country;

-- 7h. List Top 5 Genres Gross Revenue in descending order
select c.name, concat('$', format(sum(p.amount), '##,##0')) Gross_Revenue
from sakila.category c
inner join sakila.film_category fc on c.category_id = fc.category_id
inner join sakila.inventory i on i.film_id = fc.film_id
inner join sakila.rental r on r.inventory_id = i.inventory_id
inner join sakila.payment p on p.rental_id = r.rental_id
group by c.name
order by Gross_Revenue desc limit 5;

-- 8a. Create View
create View sakila.Top_Genres
as 
select c.name, concat('$', format(sum(p.amount), '##,##0')) Gross_Revenue
from sakila.category c
inner join sakila.film_category fc on c.category_id = fc.category_id
inner join sakila.inventory i on i.film_id = fc.film_id
inner join sakila.rental r on r.inventory_id = i.inventory_id
inner join sakila.payment p on p.rental_id = r.rental_id
group by c.name
order by Gross_Revenue desc limit 5;

-- 8b. Display View
select * from sakila.Top_Genres;


-- 8c. 
Drop View sakila.Top_Genres


