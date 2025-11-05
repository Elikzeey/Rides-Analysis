WITH DriverCityRevenue AS (
    SELECT
        pickup_city,
        driver_id,
        SUM(amount) AS total_revenue,
        -- Rank drivers within each city by total revenue
        ROW_NUMBER() OVER (PARTITION BY pickup_city ORDER BY SUM(amount) DESC) AS city_rank
    FROM
        Rides_Payments
    WHERE
        amount > 0 -- Completed rides
    GROUP BY
        pickup_city, driver_id
)
SELECT
    dcr.pickup_city,
    d.name AS driver_name,
    dcr.total_revenue
FROM
    DriverCityRevenue dcr
JOIN
    Drivers d ON dcr.driver_id = d.driver_id
WHERE
    dcr.city_rank <= 3 
ORDER BY
    dcr.pickup_city, dcr.city_rank;