-- ==========================================================
-- E-COMMERCE DELIVERY & CUSTOMER SEGMENTATION ANALYSIS
-- ==========================================================

-- ==========================================================
-- 1. CUSTOMER SEGMENTATION
-- ==========================================================

-- 1.1 Total Unique Customers
SELECT 
    COUNT(DISTINCT Customer_Unique_Id) AS Total_Customers
FROM
    Customers;
-- Insight: 99,441 unique customers in the dataset.    

-- 1.2 High Value Customers
SELECT 
    c.Customer_Unique_Id AS Customer,
    SUM(i.Price) AS Total_Spending,
    CONCAT(ROUND(SUM(i.Price) * 100.0 / SUM(SUM(i.Price)) OVER (), 2), '%') AS Percentage 
FROM
    Customers c
        LEFT JOIN Orders o ON o.Customer_Id = c.Customer_Id
        LEFT JOIN Order_Items i ON i.Order_Id = o.Order_Id
GROUP BY c.Customer_Unique_Id
ORDER BY SUM(i.Price) DESC;
/* 
Insights:
- 6 customers out of 96,219 contributed >= 0.5% of total revenue.
- Only 1 contributed up to 0.1% of revenue.
*/

-- 1.3 Most Frequent Customers
SELECT 
    c.Customer_Unique_Id AS Customer, 
    COUNT(o.Order_Id) AS Total_Orders,
    ROUND(COUNT(o.Order_Id) * 100.0 / SUM(COUNT(o.Order_Id)) OVER (), 2) AS Percentage
FROM
    Customers c
        LEFT JOIN Orders o ON c.Customer_Id = o.Customer_Id
GROUP BY c.Customer_Unique_Id
ORDER BY Total_Orders DESC;
/* 
Insights:
- Only 2,997 customers made at least 2 purchases.
- Only 19 customers made 5 or more purchases.
- All customers but 1 (0.02%) represent 0.01% or less of orders.
*/


-- ==========================================================
-- 2. GEOGRAPHIC SEGMENTATION
-- ==========================================================

-- 2.1 States
SELECT
    Customer_State AS State,
    COUNT(Customer_Unique_Id) AS Total_Customers,
    ROUND(COUNT(Customer_Unique_Id) * 100.0 / SUM(COUNT(Customer_Unique_Id)) OVER (), 2) AS Percentage
FROM
    Customers
GROUP BY Customer_State
ORDER BY Total_Customers DESC;
/*
Insights:
- The top 3 states account for two-thirds of the customer base.
- Most customers are located in São Paulo (SP).
*/

-- 2.2 Highest Value States
SELECT
    c.Customer_State AS State,
    SUM(i.Price) AS Total_Spending,
    ROUND(SUM(i.Price) * 100.0 / SUM(SUM(i.Price)) OVER (), 2) AS Percentage
FROM
    Customers c
        LEFT JOIN Orders o ON c.Customer_Id = o.Customer_Id
        LEFT JOIN Order_Items i ON o.Order_Id = i.Order_Id
GROUP BY c.Customer_State
ORDER BY Total_Spending DESC;
/*
Insights:
- SP accounts for over 40% of spending.
- The top 3 states account for two-thirds of total spending.
*/

-- 2.3 Cities
SELECT 
    c.Customer_City AS City,
    COUNT(c.Customer_unique_Id) AS Total_Customers,
    ROUND(COUNT(c.Customer_unique_Id) * 100.0 / SUM(COUNT(c.Customer_unique_Id)) OVER (), 2) AS Percentage
FROM
    Customers c
GROUP BY c.Customer_City
ORDER BY Total_Customers DESC;
/*
Insights:
- The top 9 out of 4,119 cities account for over 30% of customers.
- São Paulo alone contributes 15.63%.
*/

-- 2.4 Highest Value Cities
SELECT
    c.Customer_City AS City,
    SUM(i.Price) AS Total_Spending,
    ROUND(SUM(i.Price) * 100.0 / SUM(SUM(i.Price)) OVER (), 2) AS Percentage
FROM
    Customers c
        LEFT JOIN Orders o ON c.Customer_Id = o.Customer_Id
        LEFT JOIN Order_Items i ON o.Order_Id = i.Order_Id
WHERE customer_city LIKE '%sao%'
GROUP BY c.Customer_City
ORDER BY Total_Spending DESC;
/*
Insights:
- The top 9 out of 4,119 cities account for over 30% of revenue.
- São Paulo alone contributes 14.09%.
*/


-- ==========================================================
-- 3. FUNNEL ANALYSIS
-- ==========================================================

-- 3.1 Orders by Status
SELECT
    o.Order_Status AS Order_Status,
    COUNT(o.Order_Id) AS Total_Orders,
    ROUND(COUNT(o.Order_Id) * 100.0 / SUM(COUNT(o.Order_Id)) OVER (), 2) AS Percentage
FROM 
    Orders o
        LEFT JOIN Order_Items i ON o.Order_Id = i.Order_Id
GROUP BY o.Order_Status
ORDER BY Total_Orders DESC;
/*
Insights:
- 97% of all orders were completed.
- 1,316 orders were either cancelled or unavailable, accounting for 1.16% of orders.
*/

-- 3.2 Average order delivery time after approval
SELECT 
    ROUND(AVG(TIMESTAMPDIFF(DAY,
                Order_Approved_At,
                Order_Delivered_Customer_Date)),
            2) AS 'Average Delivery Time'
FROM
    Orders;
-- 11.64 days

-- 3.3 Delivery Performance
SELECT
    CASE
        WHEN cast(order_delivered_customer_date AS DATE) < order_estimated_delivery_date THEN 'Early'
        WHEN cast(order_delivered_customer_date AS DATE) = order_estimated_delivery_date THEN 'On Time'
        WHEN cast(order_delivered_customer_date AS DATE) > order_estimated_delivery_date THEN 'Late'
        ELSE 'Unknown'
    END AS delivery_status,
    COUNT(order_id) AS total_orders,
    ROUND(COUNT(order_id) * 100.0 / SUM(COUNT(order_id)) OVER (), 2) AS percentage
FROM Orders
GROUP BY delivery_status
ORDER BY total_orders DESC;
/* Early - 92%
ON time - 1.3%
Late - 6.57
*/


-- ==========================================================
-- 4. TIME SERIES ANALYSIS
-- ==========================================================

SELECT 
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS YearMonth,
    COUNT(o.order_id) AS Total_Orders,
    COUNT(CASE WHEN o.order_status <> 'delivered' THEN 1 END) AS Not_Delivered,
    SUM(i.price) AS Total_Spending
FROM Orders o
LEFT JOIN Order_Items i 
    ON o.order_id = i.order_id
GROUP BY YearMonth
ORDER BY YearMonth;
/*
Insights:
- 2018 saw the highest number of orders.
- September and October saw a complete halt in orders.
*/

-- ==========================================================
-- 5. MONTHLY AVERAGE REVIEWS
-- ==========================================================

SELECT 
    DATE_FORMAT(review_creation_date, '%Y-%m') AS YearMonth,
    AVG(review_score) AS Average_Review_Score
FROM
    reviews
GROUP BY YearMonth;
/*
Review scores remained strong with the last five months averaging 4.1 or higher.
*/


-- ==========================================================
-- 6. FINAL ORDER 
-- ==========================================================

-- Latest Order
SELECT 
    *
FROM
    orders
WHERE
    order_purchase_timestamp = (SELECT MAX(order_purchase_timestamp) FROM orders);
/*
Last order was on October 17th; cancelled
*/
