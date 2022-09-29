/*
THE GREAT CHICKEN SANDWICH SHOWDOWN OF 2022
Five dudes rate every fast food chicken sandwich in a six mile radius

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

--DATA CLEANSING
--Update SandwichList
--Set SandwichName = 'Zaxbys Signature Chicken Sandwich'
--Where SandwichID=1


Select *
From ChickenSand..SandwichList
Where SandwichName like '%chicken%'

-- WHICH CHICKEN SANDWICH OFFERS THE BEST VALUE BASED ON CALORIES TO PRICE RATION?
Select SandwichName, Round ((SandwichPrice / SandwichCalories), 4) as PricePerCalorie, SandwichPrice, SandwichCalories
From ChickenSand..SandwichList
Where SandwichName like '%chicken%'
Order By PricePerCalorie 



-- TOTAL PRICE IF I BUY ONE REGULAR AND ONE SPICY SANDWICH AT EACH RESTAURANT
Select RestaurantName, (SUM(SandwichPrice)) as TotalCost
From ChickenSand..SandwichList
Where SandwichName like '%chicken%' 
GROUP BY RestaurantName
Order By TotalCost


-- WHICH CHICKEN SANDWICH COSTS THE LEAST BASED ON PRICE AND TRAVEL? 
-- ASSUMES A COST OF 62 CENTS PER MILE
Select SandwichName
, (Distance * 0.62 + SandwichPrice) as TotalCost
, SandwichPrice
, (Distance * 0.62) as Travel
From ChickenSand..SandwichList
Where SandwichName like '%chicken%'
Order By TotalCost 


-- HOW MUCH DID I SPEND ON PURCHASING 24 TOTAL SANDWICHES FOR THE TASTE TEST, PLUS SALES TAX? (WITH CAST, $ FORMATTING)
-- *** I AM NOT PROUD OF THIS NUMBER ***
Select Count(SandwichName) * 2 as TotalSandwiches
, '$'+convert(varchar,cast(sum(SandwichPrice * 2) as money)) as CostofSandwiches
, '$'+convert(varchar,cast(sum (SandwichPrice * .045) as money)) as SalesTax
, '$'+convert(varchar,cast(sum (SandwichPrice * 2 + SandwichPrice * .045) as money)) as TotalSpent
From ChickenSand..SandwichList
Where SandwichName like '%chicken%'


-- CHICKEN SANDWICH SCORES DISPLAYED WITH PRICES
Select rat.SandwichName
, '$'+convert(varchar,cast(lis.SandwichPrice as money)) as SandwichPrice
, rat.Dane, rat.Logan, rat.Skyler, rat.Vinnie, rat.Chad
From ChickenSand..SandwichList lis
Join ChickenSand..SandwichRatings rat
On lis.SandwichID = rat.SandwichID
Where rat.SandwichName like '%chicken%'
Order By rat.SandwichName


-- AVERAGE SCORE FOR EACH CHICKEN SANDWICH
Select rat.SandwichName, (rat.Dane+rat.Logan+rat.Skyler+rat.Vinnie+rat.Chad)/5 as AvgScore, '$'+convert(varchar,cast(lis.SandwichPrice as money)) as SandwichPrice
FROM SandwichRatings rat
Join ChickenSand..SandwichList lis
On lis.SandwichID = rat.SandwichID
Where lis.SandwichName like '%chicken%'
Order By AvgScore desc
