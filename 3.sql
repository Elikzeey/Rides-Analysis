WITH QuarterlyRevenue AS (
    SELECT
        EXTRACT(YEAR FROM pickup_time) AS ride_year,
        EXTRACT(QUARTER FROM pickup_time) AS ride_quarter,
        SUM(amount) AS revenue
    FROM
        Rides_Payments
    WHERE
        amount > 0
    GROUP BY 1, 2
)
SELECT
    qr.ride_year,
    qr.ride_quarter,
    qr.revenue AS current_revenue,
    LAG(qr.revenue, 1) OVER (PARTITION BY qr.ride_quarter ORDER BY qr.ride_year) AS previous_year_revenue,
    ((qr.revenue - LAG(qr.revenue, 1) OVER (PARTITION BY qr.ride_quarter ORDER BY qr.ride_year)) * 100.0 / NULLIF(LAG(qr.revenue, 1) 
	OVER (PARTITION BY qr.ride_quarter ORDER BY qr.ride_year), 0)) AS yoy_growth_percent
FROM
    QuarterlyRevenue qr
WHERE
    qr.ride_year > 2021 
ORDER BY
    yoy_growth_percent DESC NULLS LAST
LIMIT 1;