
# Sales Revenue Analysis

Analysis
You will need to understand and analyze the data in the AdventureWorks2017DW database. (This is the data warehouse, not the database you have used for other efforts).

Key points to remember:

The sales data is found in two tables that may need to be joined for some analysis and separate for others.
Internet sales (factInternetSales) are direct, online sales
Reseller sales (factResellerSales) are through reseller network
The data warehouse also contains important information that will be relevant for your analysis, including the following:

Customer data that provides interesting demographic data
Product data that can be segregated into categories and subcategories
Promotion data that may give insights to success of promotions
Geography data to analyze data by region
Territory data that can be joined with sales data to look at sales group performance.
Your objectives:

In each of the following objectives you need to provide the minimum in a clear, concise, and professional manner. Feel free to expand on the objectives if you see something interesting in the data, but make sure you are able to explain your reasoning and your findings. The first three are rather prescriptive and you’ll need to follow the requests. The last two are open to interpretation, as long as you meet the intent of the objective.

Provide a detailed list of Internet sales with the following columns for the financial analyst team to review (Category, Model, CustomerKey, Region, IncomeGroup, CalendarYear, FiscalYear, Month, OrderNumber, Quantity, and Amount). Income group should categorize the people based on "Low" being less than 40,000, "High" being greater than 60,000, and the rest will be "Moderate".
Provide a similar analysis for Reseller sales with the following columns (Category, Model, CalendarYear, FiscalYear, Month, OrderNumber, Quantity, Amount).
Show the total sales (overall) by year rolled up by the Territory group and country. A special request is that the United Kingdom is no longer part of Europe and management wants to see their totals as a separate Territory group. You cannot modify the data, so you will need to address this request in your query.
Provide an analysis of sales performance by Promotion. It would be interesting to see how different types of promotions drive sales (quantity and revenue), especially by product category or region. The comparison between Internet and Reseller sales is probably interesting too. Don’t attempt to do everything, but show some good analysis related to Promotion.
Our customers are always a big discussion topic with management and the sales team. The Customer table has a wealth of data categories that could be joined with Internet sales and all the extra data that brings along. This request will likely separate the high-performing analysts from the rest.

##
Technologies used:
* SQL Server
* Azure Data Studio 
* Docker Desktop for Mac

