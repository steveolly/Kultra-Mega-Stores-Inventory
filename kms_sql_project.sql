use project;

SELECT * FROM kms_sql;

-- Which product category had the highest sales? --

SELECT `Product Category` , sum(Sales) AS Total_sales
FROM kms_sql
GROUP BY `Product Category`
ORDER BY Total_sales DESC
LIMIT 1;

-- What are the Top 3 and Bottom 3 regions in terms of sales? --

SELECT * FROM (
	SELECT * FROM (
		SELECT Region , sum(sales) AS Total_sales
		FROM kms_sql
		GROUP BY Region
		ORDER BY Total_sales DESC
		LIMIT 3
	) 
	AS top_Region 

	UNION ALL

	SELECT * FROM (
		SELECT Region , sum(sales) AS Total_sales
		FROM kms_sql
		GROUP BY Region
		ORDER BY Total_sales ASC
		LIMIT 3
    )
    AS bottom_Region
) 
AS top_bottom_Region
ORDER BY Total_sales DESC;

-- What were the total sales of appliances in Ontario --

SELECT Province, `Product Sub-Category`, sum(sales) AS Total_sales
FROM kms_sql
WHERE Province = "Ontario" AND `Product Sub-Category` = "appliances";

-- Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers --

SELECT `Customer Name`, SUM(sales) AS `Total Sales`
FROM kms_sql
GROUP BY `Customer Name`
ORDER BY `Total Sales` ASC
LIMIT 10;

-- KMS incurred the most shipping cost using which shipping method --

SELECT `ship Mode`, sum(`shipping cost`) AS `Total shipping cost`
FROM kms_sql
GROUP BY `ship Mode`
ORDER BY `Total shipping cost` DESC
LIMIT 1;

-- Who are the most valuable customers, and what products or services do they typically purchase

SELECT ks.`Customer Name`, ks.`Product Category`, SUM(ks.Sales) AS Total_Sales
FROM kms_sql ks
JOIN (
	SELECT `Customer Name`
	FROM kms_sql
	GROUP BY `Customer Name`
	ORDER BY SUM(Sales) DESC
	LIMIT 10
) AS top_customers
ON ks.`Customer Name`= top_customers.`Customer Name`
GROUP BY ks.`Customer Name`,ks.`Product Category`
ORDER BY ks.`Customer Name`, Total_Sales DESC;

-- Which small business customer had the highest sales?

SELECT `Customer Name`, `Customer Segment`, SUM(Sales) AS Total_Sales
FROM kms_sql
Where `Customer Segment` = "Small Business"
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 1;

-- Which Corporate Customer placed the most number of orders in 2009 – 2012?

select `Customer Name`, COUNT(`customer segment`) AS `Number of orders`
FROM kms_sql
where `customer segment` = "corporate"
GROUP BY `Customer Name`
ORDER BY `Number of orders` DESC
LIMIT 1;

-- Which consumer customer was the most profitable one?

SELECT `Customer Name`, `Customer Segment`, SUM(Profit) AS Total_Profit
FROM kms_sql
Where `Customer Segment` = "Consumer"
GROUP BY `Customer Name`
ORDER BY Total_Profit DESC
LIMIT 1;

-- Which customer returned items, and what segment do they belong to?

SELECT ks.`Order ID`, ks.`Customer Name`, os.Status, ks.`Product Sub-Category`
FROM kms_sql ks
JOIN order_status os ON ks.`Order ID` = os.`Order ID`
ORDER BY ks.`Order ID`;


/* if the delivery truck is the most economical but the slowest shipping method and
Express Air is the fastest but the most expensive one, do you think the company
appropriately spent shipping costs based on the Order Priority? Explain your answer
*/

SELECT 
	`Order Priority`,
    `Ship Mode`,
    count(`Order ID`) AS `Number of Orders`,
	ROUND(SUM(Sales - Profit),2) AS `Estimated Shipping Cost`,
	ROUND(AVG(DATEDIFF(`Ship Date`, `Order Date`)), 2) AS `Avg Ship Days`
FROM kms_sql
GROUP BY `Order Priority`,`Ship Mode`
ORDER BY `Order Priority`, `Ship Mode`;
