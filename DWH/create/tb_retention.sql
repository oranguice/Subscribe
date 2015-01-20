select regexp_replace(date_add(p_date, 1),'-',''), col_flag, count(*), 'new_user_1st' as col_retention_type
from
(
	select p_date, col_uid, sum(col_flag) as col_flag 
	from 
	( 
			select concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)) as p_date, col_uid, 1 as col_flag 
				from subscribe.tb_daily_user
				where col_new_user = 1 p_date = {date-1}
			group by concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), col_uid
		union all 
			select date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), 1) as p_date, col_uid, 2 as col_flag 
				from subscribe.tb_daily_user
				where p_date = {date}
			group by date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), 1), col_uid
	)ta 
	group by p_date, col_uid
)tb
group by regexp_replace(date_add(p_date, 1),'-',''), col_flag
--新用户次日 Retention



select regexp_replace(date_add(p_date, 1),'-',''), col_flag, count(*), 'new_user_7th' as col_retention_type
from
(
	select p_date, col_uid, sum(col_flag) as col_flag 
	from 
	( 
			select concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)) as p_date, col_uid, 1 as col_flag 
				from subscribe.tb_daily_user
				where col_new_user = 1 p_date = {date-7}
			group by concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), col_uid
		union all 
			select date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), 7) as p_date, col_uid, 2 as col_flag 
				from subscribe.tb_daily_user
				where p_date = {date}
			group by date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), 7), col_uid
	)ta 
	group by p_date, col_uid
)tb
group by regexp_replace(date_add(p_date, 1),'-',''), col_flag
--新用户第七日 Retention




select regexp_replace(date_add(p_date, 1),'-',''), col_flag, count(*), 'new_user_15th' as col_retention_type
from
(
	select p_date, col_uid, sum(col_flag) as col_flag 
	from 
	( 
			select concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)) as p_date, col_uid, 1 as col_flag 
				from subscribe.tb_daily_user
				where col_new_user = 1 p_date = {date-15}
			group by concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), col_uid
		union all 
			select date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), 15) as p_date, col_uid, 2 as col_flag 
				from subscribe.tb_daily_user
				where p_date = {date}
			group by date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), 15), col_uid
	)ta 
	group by p_date, col_uid
)tb
group by regexp_replace(date_add(p_date, 1),'-',''), col_flag
--新用户第十五日 Retention



select '{date}' as p_date, col_flag, count(*), 'new_user_1week' as col_retention_type
from
(
	select col_uid, sum(col_flag) as col_flag 
	from 
	( 
			select col_uid, 1 as col_flag 
				from subscribe.tb_daily_user
				where col_new_user = 1 p_date >= {date-13} and p_date <= {date-7}
			group by col_uid
		union all 
			select col_uid, 2 as col_flag 
				from subscribe.tb_daily_user
				where p_date >= {date-6} and p_date <= {date}
			group by col_uid
	)ta 
	group by col_uid
)tb
group by col_flag
--新用户次周回访



select '{date}' as p_date, col_flag, count(*), 'user_1week' as col_retention_type
from
(
	select col_uid, sum(col_flag) as col_flag 
	from 
	( 
			select col_uid, 1 as col_flag 
				from subscribe.tb_daily_user
				where p_date >= {date-13} and p_date <= {date-7}
			group by col_uid
		union all 
			select col_uid, 2 as col_flag 
				from subscribe.tb_daily_user
				where p_date >= {date-6} and p_date <= {date}
			group by col_uid
	)ta 
	group by col_uid
)tb
group by col_flag
--所有用户次周回访



select '{date}' as p_date, col_flag, count(*), 'click_user_1week' as col_retention_type
from
(
	select col_uid, sum(col_flag) as col_flag 
	from 
	( 
			select col_uid, 1 as col_flag 
				from subscribe.tb_daily_user
				where col_feed_clicks > 0 and p_date >= {date-13} and p_date <= {date-7}
			group by col_uid
		union all 
			select col_uid, 2 as col_flag 
				from subscribe.tb_daily_user
				where p_date >= {date-6} and p_date <= {date}
			group by col_uid
	)ta 
	group by col_uid
)tb
group by col_flag
--所有点击用户次周回访