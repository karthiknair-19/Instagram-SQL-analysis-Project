use ig_clone ;

-- We want to reward the user who has been around the longest, Find the 5 oldest users

select * from users ;

with cte as (select * from users  order by created_at asc limit 5)                                         -- oldest 5 people

select * from cte order by id  ;                                                                           -- ordering the 5 people with id in ascending order for ease of understanding  

-- To target inactive users in an email ad campaign, find the users who have never posted a photo

with user_cte as ( select * from users ),                                                                  -- making a cte with user information

photo_cte as (select user_id,count(*) as No_of_posts_by_the_user  from photos group by user_id  ),         -- making a cte in which its grouped by user id ,and the count shows number of post done by the user 

join_cte as ( select A.id , A.username,B.No_of_posts_by_the_user as post_count from user_cte as A          -- making a cte join in which the tables are joined using left join because the users are present in left table
left join photo_cte as B on A.id=B.user_id )

select id,username,post_count  from join_cte where post_count is null ;

-- Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?

with user_cte as ( select * from users ),                                                                    -- making a cte with user information

likes_cte as ( select photo_id , count(*) as likes_obtained from likes group by photo_id  ),                          -- making a cte with likes where grouped by photoid to know the likes on each photo

photo_cte as ( select id , user_id from photos),                                                             -- making a cte with photos

join_cte as ( select A.id,A.username, C.likes_obtained from users as A inner join photo_cte as B on A.id = B.user_id 
inner join likes_cte as C on C.photo_id=B.id )                                                             -- making a cte with join tables 

select *   from join_cte where likes_obtained in ( select max(likes_obtained) from join_cte) ;


-- The investors want to know how many times does the average user post.

select * from photos ; 

with photo_cte as  (select user_id , count(*) as posts from photos group by user_id )                        -- making a cte with photos and grouping it by user id to know the count of post doen by  a user 

select round(avg(posts)) as average_post_of_user  from photo_cte ;



-- A brand wants to know which hashtag to use on a post, and find the top 5 most used hashtags

with tags_cte as ( select * from tags ),

photo_tags_cte as ( select count(*) as no_of_pics ,tag_id  from photo_tags group by tag_id ) ,               -- making a cte with group by of tag id to know which tag was used the most 

join_cte as ( select A.id ,A.tag_name, B. no_of_pics from tags_cte as A
 inner join photo_tags_cte as B where A.id=B.tag_id ) 
    
select * from join_cte order by  no_of_pics desc limit 5  ;        

-- To find out if there are bots, find users who have liked every single photo on the site.

with user_cte as ( select id,username from users ) ,

likes_cte as ( select user_id ,count(*) as no_of_likes   from likes group by user_id  ),                   --  making a cte with group by of user id using likes table to know how many likes did a person get 

join_cte as ( select A.id,A.username,B.no_of_likes from user_cte as A inner join 
likes_cte as B on A.id = B.user_id )

select * from join_cte where no_of_likes in ( select count(id) from photos ) ;                              -- to check for the person liked every pic , then the like should be equal to total number of post 


-- Find the users who have created instagramid in may and select top 5 newest joinees from it?

with user_cte as ( select * from users where extract(month from created_at) = 5 )   
                              
select * from user_cte order by created_at desc limit 5;

-- Can you help me find the users whose name starts with c and ends with any number and have posted the photos as well as liked the photos?

with users_cte as ( select * from users ),

photos_cte as ( select user_id , count(*) as photos_posted   from photos group by user_id),                  -- making a cte with  photos table and grouping it using user id to know the total pics posted by a person

likes_cte as ( select  user_id , count(*) as posts_liked   from likes group by user_id ),                          -- making a cte with likes table and grouping it using user id to know how much likes does each person get 

join_cte as ( select A.id,A.username,B.photos_posted,C.posts_liked from users_cte as A inner join
 photos_cte as B on A.id=B.user_id inner join   likes_cte as C on C.user_id=B.user_id )
 
select * from join_cte where  substr(username,1,1) = "c" and right(username,1) in (1,2,3,4,5,6,7,8,9,0) 
and photos_posted is not null and posts_liked is not null  ;  


-- Demonstrate the top 30 usernames to the company who have posted photos in the range of 3 to 5.

with users_cte as ( select * from users ),

photos_cte as ( select user_id , count(*) as photos_posted   from photos group by user_id),                    -- making a cte with  photos table and grouping it using user id to know the total pics posted by a person

join_cte as ( select A.id,A.username,B.photos_posted from users_cte as A inner join 
photos_cte as B on A.id=B.user_id)

select * from join_cte where photos_posted between 3 and 5 order by photos_posted desc limit 30;





