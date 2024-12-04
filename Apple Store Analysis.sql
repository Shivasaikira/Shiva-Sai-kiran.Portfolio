CREATE TABLE appleStore_description_combined AS
 Select * from appleStore_description1
 UNION ALL
 Select * from appleStore_description2
  UNION ALL
  Select * from appleStore_description3
   UNION ALL
  Select * from appleStore_description4 
  
  **EXPLORATORY DATA ANALYSIS**
   
   --check the number of unique apps from both tablesAppleStore
   
   SELECT COUNT(DISTINCT id) AS UniqueAppIDs
    FROM AppleStore
    
     SELECT COUNT(DISTINCT id) AS UniqueAppIDs
    FROM appleStore_description_combined
    
    --check for any missing values in key fieldsAppleStore
     
     SELECT COUNT(*) AS MissingValues
     FROM AppleStore
     WHERE track_name IS null OR user_rating IS null OR prime_genre IS null
    
     SELECT COUNT(*) AS MissingValues
     FROM appleStore_description_combined
     WHERE app_desc IS null 
     
     --Find out the number of apps per genre 
      
      SELECT prime_genre, COUNT(*) as NumApps
      FROM AppleStore
      group by prime_genre
      order by  NumApps DESC
      
      --Get an overview of apps ratings 
       Select min(user_rating) as MinRating,
       max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
       from AppleStore
       
       
    **DATA ANALYSIS**
    
    --Determine whether paid apps have higher ratings than free apps 
     
     SELECT CASE
               when  price > 0 then 'Paid'
               else 'Free'
               end as App_Type,
               avg(user_rating) as Avg_Rating
               from AppleStore
               group by App_Type
               
   -- Check if apps with more supported languages have higher ratings 
   
   SELECT case 
            when lang_num < 10 then '<10 languages'
            when lang_num between 10 and 30 then '10-30 languages'
            else '>30 languages'
            end as language_bucket,
            avg(user_rating) as Avg_Rating
            from AppleStore
            group by language_bucket
            order by Avg_Rating desc
            
     -- Check genres with low ratings 
     
     select prime_genre, avg(user_rating) aS Avg_Rating
     from AppleStore
     GROUP BY prime_genre
     order by Avg_Rating ASC
     limit 10
     
    -- Checek if there is any correlation between the length of the app description and user rating
   
   select case 
          when length(b.app_desc) <500 then 'Short'
          when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
          else 'Long'
          end as description_length_bucket, 
          avg(a.user_rating) as average_rating
          
         from AppleStore as a 
         join appleStore_description_combined as b 
         on
            a.id=b.id
            group by description_length_bucket
            order by  average_rating desc
            
     -- Check the top rated app for each genre
     
     Select prime_genre, user_rating, track_name
     FROM
          (
              Select prime_genre, 
                     user_rating, 
                      track_name,
            RANK() OVER(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) as rank
            from AppleStore
            ) as a 
             where a.rank=1
      
     
     
     
     
    
    
    
    