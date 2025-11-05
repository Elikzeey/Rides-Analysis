SELECT
    rp.distance_miles,
    d.name AS driver_name,
    r.name AS rider_name,
    rp.pickup_city,
    rp.dropoff_city,
    rp.method AS payment_method
FROM
    Rides_Payments rp
JOIN
    Drivers d ON rp.driver_id = d.driver_id
JOIN
    Riders r ON rp.rider_id = r.rider_id
WHERE
    rp.amount > 0 -- Completed rides
ORDER BY
    rp.distance_miles DESC
LIMIT 10;
