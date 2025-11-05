SELECT
    COUNT(DISTINCT r.rider_id) AS "Riders_2021_SignedUp_Active_2024"
FROM
    Riders r
JOIN
    Rides_Payments rp ON r.rider_id = rp.rider_id
WHERE
    -- Riders who signed up in 2021
    EXTRACT(YEAR FROM r.signup_date) = 2021
    -- And took a completed ride in 2024
    AND EXTRACT(YEAR FROM rp.pickup_time) = 2024
    AND rp.amount > 0; -- Completed rides