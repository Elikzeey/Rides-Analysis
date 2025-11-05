WITH DriverRideStats AS (
    SELECT
        driver_id,
        COUNT(ride_id) AS total_rides, -- All rides (completed + cancelled)
        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_rides,
        SUM(CASE WHEN amount > 0 THEN 1 ELSE 0 END) AS completed_rides
    FROM
        Rides_Payments
    GROUP BY
        driver_id
)
SELECT
    d.name AS driver_name,
    drs.completed_rides,
    d.rating AS average_rating, -- Using driver's static average rating from drivers table
    (drs.cancelled_rides * 100.0 / NULLIF(drs.total_rides, 0)) AS cancellation_rate_percent
FROM
    Drivers d
JOIN
    DriverRideStats drs ON d.driver_id = drs.driver_id
WHERE
    drs.completed_rides >= 30 -- Criteria 1
    AND d.rating >= 4.5 -- Criteria 2 
    AND (drs.cancelled_rides * 100.0 / NULLIF(drs.total_rides, 0)) < 5.0 -- Criteria 3
ORDER BY
    drs.completed_rides DESC 
LIMIT 10;