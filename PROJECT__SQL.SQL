create database ZOMATO;
use zomato;
select*from zomato;

--  TOTAL NO OF RESTAURANT (COUNT)
select count(*) from zomato;

-- total no of restaurant providing online service and having rating greater than 4.5
select count(*) from zomato where Has_Online_delivery="yes" and rating >= "4.5";

-- retract the restaurant which as indian cuisines
select restaurantname,city from zomato where cuisines like "indian%";

-- retract the restaurant which as chinese cuisines
select restaurantname,city from zomato where cuisines like "chinese%";

-- highest rated restaurant
select max(rating), RestaurantName,City from zomato 
group by RestaurantName,City,rating order by rating desc ;

-- COUNTRY WISE COUNT OF RESTAURANT
select count(*),countrycode  from zomato group by countrycode order by countrycode;

-- City WISE COUNT OF RESTAURANT
select count(*),countrycode ,city from zomato group by countrycode,city order by countrycode;
select count(*),countrycode ,city from zomato group by countrycode,city order by count(*) desc limit  5;

-- add a coloumn about the ambience 
alter table zomato add column ambiance char(10) ;
insert  into zomato(ambiance) values("yes");
select*from zomato;

--  MAX , AVERAGE COST FOR TWO
select max(Average_Cost_for_two),RestaurantName , city from zomato 
group by RestaurantName ,Average_Cost_for_two,city  
order by Average_Cost_for_two desc ;

--  MAX, MIN RATING USING WINDOW
select restaurantname,countrycode, max(rating) over(partition by countrycode  ) as ratings from zomato;
select restaurantname, min(rating) over()  from zomato;

--  rank the restaurant on the basic of votes and rating
select city,restaurantname,votes, dense_rank() over(partition by city order by votes desc  ,rating desc) as max_votes from zomato;

--  select a city having highest price range and in india 
select restaurantname,city , price_range from zomato where CountryCode="1" and Price_range=(select max(Price_range) from zomato) ;

-- AVG RATING OF RESTS LOCATION WISE 
select avg(rating),city from zomato where countrycode=1 group by city; /* will show 43 rows*/
select city,avg(rating) over(partition by city)  from zomato where countrycode=1; /* will show 8652 rows*/

 -- FINDING THE BEST RESTAURANTS IN TERMS OF VOTES WITH MODRATE COST FOR TWO IN INDIA HAVING INDIAN CUISINES
select Average_Cost_for_two,restaurantname,cuisines,city,max(votes) from zomato 
where Average_Cost_for_two between 750 and 1500 
group by Average_Cost_for_two, restaurantname,votes,cuisines,city having Cuisines="North Indian| Mughlai";

select*from zomato where Average_Cost_for_two between 750 and 1500 and votes=(select max(votes) from zomato)
 and  Cuisines="North Indian| Mughlai";


-- FIND ALL THE RESTAURANTS THOSE WHO ARE OFFERING TABLE BOOKING OPTIONS WITH PRICE RANGE AND HAS HIGH RATING
WITH high_rated_restaurants as (
    SELECT RestaurantName, Price_Range, Rating, Has_Table_booking from zomato
    where  Has_Table_booking = 'Yes'  and Rating >= 4                    
)
select RestaurantName, Price_Range, Rating from high_rated_restaurants;

-- restaurant having table_booking,online_delhivery and having good rating
 select restaurantname,city,Has_Table_booking,Has_Online_delivery,Is_delivering_now, max(rating) from zomato group by restaurantname,city,Has_Table_booking,Has_Online_delivery,Is_delivering_now
 having Has_Table_booking="yes"and Has_Online_delivery="yes"and Is_delivering_now="yes";
 
 select restaurantname,city,Has_Table_booking,Has_Online_delivery,Is_delivering_now, max(rating) over() from zomato 
 having Has_Table_booking="yes"and Has_Online_delivery="yes"and Is_delivering_now="yes";
 
