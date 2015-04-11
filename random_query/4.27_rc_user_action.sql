select p_date,count(distinct col_uid),sum(col_feed_clicks),
sum(col_feed_impressions),sum(col_launches),sum(col_content_card)
from subscribe.tb_daily_users
where p_date >= 20150410 and p_date <= 20150413 and col_version = '4.27.0.7997'
--- 登陆用户数量，total click/show/lauches/card


select p_date,count(distinct col_uid),sum(col_feed_clicks),
sum(col_feed_impressions),sum(col_launches),sum(col_content_card)
from subscribe.tb_daily_users
where p_date >= 20150410 and p_date <= 20150413 
and col_version = '4.27.0.7997' and col_feed_clicks > 0
--- 点击用户数量，点击用户的 total click/show/lauches/card


select replace(date_add(p_date, interval 1 day),'-','') as p_date, col_flag, count(*) as col_num
	from
	(
		select p_date, col_uid, sum(col_flag) as col_flag 
		from 
		( 
				select concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)) as p_date, col_uid, 1 as col_flag 
					from subscribe.tb_daily_users
					where col_new_user = 1 and p_date >= 20150410 and p_date <= 20150412 and col_version = '4.27.0.7997'
				group by concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), col_uid
			union all 
				select date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), interval 1 day) as p_date, col_uid, 2 as col_flag 
					from subscribe.tb_daily_users
					where p_date >= 20150411 and p_date <= 20150413 and col_version = '4.27.0.7997'
				group by date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), interval 1 day), col_uid
		)ta 
		group by p_date, col_uid
	)tb
group by replace(date_add(p_date, interval 1 day),'-',''), col_flag
---New User 1st Day Retention
