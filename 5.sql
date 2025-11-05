WITH CityRides AS (
    SELECT
        pickup_city,
        COUNT(ride_id) AS total_rides, -- All rides (Completed + Cancelled)
        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_rides
    FROM
        Rides_Payments
    GROUP BY
        pickup_city
)
SELECT
    pickup_city,
    total_rides,
    cancelled_rides,
    -- Calculate Cancellation Rate: (Cancelled Rides / Total Rides) * 100
    (cancelled_rides * 100.0 / NULLIF(total_rides, 0)) AS cancellation_rate_percent
FROM
    CityRides
ORDER BY
    cancellation_rate_percent DESC;