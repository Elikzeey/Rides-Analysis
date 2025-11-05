WITH DriverRides AS (
    -- Total completed rides per driver
    SELECT
        driver_id,
        COUNT(ride_id) AS total_rides
    FROM
        Rides_Payments
    WHERE
        amount > 0 -- Completed rides
    GROUP BY 1
),
ActiveMonths AS (
    -- Number of distinct months a driver was active
    SELECT
        driver_id,
        COUNT(DISTINCT DATE_TRUNC('month', pickup_time)) AS active_months
    FROM
        Rides_Payments
    WHERE
        amount > 0
    GROUP BY 1
)
SELECT
    d.name AS driver_name,
    dr.total_rides,
    am.active_months,
    -- Calculate consistency: Total Rides / Active Months
    (dr.total_rides * 1.0) / am.active_months AS avg_monthly_rides
FROM
    Drivers d
JOIN
    DriverRides dr ON d.driver_id = dr.driver_id
JOIN
    ActiveMonths am ON d.driver_id = am.driver_id
ORDER BY
    avg_monthly_rides DESC
LIMIT 5;
