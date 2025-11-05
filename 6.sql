WITH RiderCompletedRides AS (
    -- Riders with more than 10 completed rides
    SELECT
        rider_id,
        COUNT(ride_id) AS total_completed_rides
    FROM
        Rides_Payments
    WHERE
        amount > 0 -- Completed rides
    GROUP BY 1
    HAVING COUNT(ride_id) > 10
),
RiderCashPayments AS (
    -- Riders who have made at least one cash payment
    SELECT
        rider_id
    FROM
        Rides_Payments
    WHERE
        amount > 0 -- Completed rides
        AND method = 'cash' 
    GROUP BY 1
)
SELECT
    r.name AS rider_name,
    rcr.total_completed_rides
FROM
    Riders r
JOIN
    RiderCompletedRides rcr ON r.rider_id = rcr.rider_id
LEFT JOIN
    RiderCashPayments rcp ON r.rider_id = rcp.rider_id
WHERE
    rcp.rider_id IS NULL 
ORDER BY
    rcr.total_completed_rides DESC;