--Calculate the average rental duration and total revenue for each customer/
SELECT
    se_c.customer_id,
    AVG(se_f.rental_duration) AS avg_rental_duration,
    SUM(se_p.amount) AS total_revenue
FROM
    customer as se_c
INNER JOIN
    rental as se_r ON se_c.customer_id = se_r.customer_id
INNER JOIN
    payment as se_p ON se_r.rental_id = se_p.rental_id
INNER JOIN
    inventory as se_i ON se_r.inventory_id = se_i.inventory_id
INNER JOIN
    film as se_f ON se_i.film_id = se_f.film_id
GROUP BY
    se_c.customer_id
-------------------------------------------------------------------------------------------------------------
--Identify customers who have never rented films but have made payments.
SELECT
    se_c.customer_id,
    se_c.first_name,
    se_c.last_name,
    se_c.email
FROM
    customer as se_c
LEFT OUTER JOIN
    rental as se_r ON se_c.customer_id = se_r.customer_id
LEFT OUTER JOIN
    payment as se_p ON se_c.customer_id = se_p.customer_id
WHERE
    se_r.customer_id IS NULL
    AND se_p.payment_id IS NOT NULL
----------------------------------------------------------------------------------------------------------------
--Calculate the replacement cost of lost films for each store, considering the rental history.
SELECT
    se_s.store_id,
    SUM(se_f.replacement_cost) AS total_replacement
FROM
    rental as se_r
INNER JOIN
    inventory as se_i ON se_r.inventory_id = se_i.inventory_id
INNER JOIN
    film as se_f ON se_i.film_id = se_f.film_id
INNER JOIN
    store as se_s ON se_i.store_id = se_s.store_id
WHERE
    se_r.return_date IS NULL
GROUP BY
    se_s.store_id
------------------------------------------------------------------------------------------------------------------
--Identify films that have been rented more than the average number of times and are currently not in inventory.
SELECT se_f.*
FROM film AS se_f
INNER JOIN (
    SELECT se_i.film_id, COUNT(*) AS rental_count
    FROM rental AS se_r
    INNER JOIN inventory AS se_i ON se_r.inventory_id = se_i.inventory_id
    GROUP BY se_i.film_id
) AS rental_counts ON se_f.film_id = rental_counts.film_id
LEFT OUTER JOIN inventory AS se_i ON se_f.film_id = se_i.film_id
WHERE se_i.film_id IS NULL
AND rental_counts.rental_count > (
    SELECT AVG(rental_count)
    FROM (
        SELECT se_i.film_id, COUNT(*) AS rental_count
        FROM rental AS se_r
        INNER JOIN inventory AS se_i ON se_r.inventory_id = se_i.inventory_id
        GROUP BY se_i.film_id
    ) AS se_r_count
)
------------------------------------------------------------------------------------------------------------------


	
	
	
	
	
	
	