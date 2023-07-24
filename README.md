# **Klist (E-Commerce) Analysis - SQL & Tableau**

Klist is an e-commerce company that sells popular electronics to domestic and international customers. In this analysis, I investigated trends to surface insights into the company's performance from 2019-2022. The key areas of the analysis were the following:

- Sales Revenue
- Average Order Value (AOV)
- Product Popularity
- Operational Performance
- Marketing Channels

### **Technical Process**:

SQL queries can be found [here](https://github.com/thisivlozano/klist-analysis-sql-tableau/blob/main/klist_queries.sql). 
- Used SQL and BigQuery to calculate aggregate functions, use CASE statements, combine tables with JOIN clauses, filter records (e.g. WHERE), arrange records (e.g. GROUP BY, ORDER BY), and simplify queries with common table expressions (CTEs).

Interactive Tableau dashboard can be found [here](https://public.tableau.com/app/profile/vl8808/viz/KlistE-CommerceDashboard/Dashboard)
- Built a Tableau dashboard from these values with the key target audiences in mind—finance, marketing, operations, and product teams. Included graphs related to total sales, average time to ship, total orders, and filters related to purchase year, marketing channel, product name, region, and purchase platform.

<img width="800" alt="Klist (E-Commerce) Dashboard" src="https://github.com/thisivlozano/klist-analysis-sql-tableau/assets/136519035/b97ef51a-90c0-4d56-9faf-d441bf481b88">

# **Summary of Insights**

### **Sales Trends**: 

*North America*
- Between 2019-2022, Klist sold an average of 30 Macbooks each month and 89 Macbooks each quarter with an average order price of $1600.
- Monthly average sales were $47.8K and quarterly average sales were $143.5K.

*All Regions*
- From 2019 to 2022, the products with the lowest amount of sales were the Apple iPhone, Bose headphones, and Webcam.
- The Bose headphones were introduced in 2020 and account for 0.01% of total sales.

### **Order Trends**
- At the start of the pandemic, orders significantly increased with a spike in May 2020 across most products except for the webcam and Bose headphones.
- In May 2020, Airpods had the highest amount of orders (1,327) followed by the gaming monitor (575) and the charging pack (492). The spike significantly decreased and orders slowed down in the summer of 2020. A similar pattern was observed during the summer of 2021.

### **Refund Trends By Product**: 
- Products that get refunded the most are the Macbook Air Laptop (4.2%), ThinkPad Laptop (3.8%), and Apple iPhone. (3.5%). However, this does not mean these products have the highest count of refunds. In terms of refund count, the Macbook Air Laptop had 118 refunds, the ThinkPad Laptop had 79 funds, and Apple iPhone had 7 refunds. 
- Apple Airpods Headphones have the greatest amount of refunds with 647 refunds across all years. The 27In 4K Gaming Monitor and the Macbook Air Laptop have the second and third highest count of refunds with 395 and 118 refunds, respectively.

### **Refund Trends (2020-2021)**: 
- In 2020, the monthly refund rates of orders ranged from 2.5% to 3.9%, with May 2020 having the highest number of refunds.
- In 2021, Apple products had 6 to 33 monthly refunds, with March 2021 being the highest refunded month.

### **Account Creation Method Trends (Jan and Feb 2022)**:
- During the first two months of 2022, accounts created on desktop had the most amount of new customers with 2.5K new customers in comparison to 701 new customers via mobile. 
- Desktop-created accounts made more expensive purchases with an AOV of $236 compared to mobile-created accounts with an AOV of $185. While tablet-created accounts only accounted for 25 purchases during this period, the AOV is slightly higher than desktop-created accounts with an AOV of $287.
- On average, people become customers within 64 days (2 months) of creating an account.

### **Time to Purchase and Delivery**:
- On average, customers make a purchase about 64 days (two months) after creating an account.
- There is an average time of 14 days to delivery from the time a customer makes a purchase.

### **Shipping Times**:
- Compared to other products, the Apple iPhone and Bose headphones have highly varied shipping times. This could be due to the lower order amounts for these products.

### **Marketing**
- In this case, “best” was defined as having the highest sales revenue. Across all regions, direct has the highest total sales. 
- However, it is vital to note direct is not really a marketing channel as it indicates customers are arriving directly on the site to purchase. After direct traffic on the website, email marketing is the second largest sales driver across all geographic regions, except where the region is unknown (where affiliate marketing has the highest sales).

# **Recommendations & Next Steps**
- Investigate why product orders exhibit a dip in summer months. Are there incentives that could be implemented to combat this dip?
- Due to Bose headphones and Apple iPhone consistently having low sales, consider removing these products from the product inventory to be more strategic by focusing on better-performing products and adding products with growth potential.
- Look into the reasons behind the delay between account creation and the time a customer makes a purchase. How can this figure be improved to ensure conversions?
- Due to desktop being the most popular method for account creation (2487), it is important to ensure the website is optimized with a smooth sign-up process and to find on searches. It is important to note, mobile is the second most popular method for account creation for 701 customers. It is beneficial to provide customers with a great user experience; therefore, the team should regularly do performance checkups.
- Analyze the drop in orders in 2022, both internal and external factors, to develop actionable steps the team can take.
