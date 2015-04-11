select replace(date_add(p_date, interval 1 day),'-','') as p_date, col_flag, count(*) as col_num
	from
	(
		select p_date, col_uid, sum(col_flag) as col_flag 
		from 
		( 
				select concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)) as p_date, col_uid, 1 as col_flag 
					from subscribe.tb_daily_users
					where col_new_user = 1 and p_date = {date-1} and p_date >= {date-7}
				group by concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), col_uid
			union all 
				select date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), interval 1 day) as p_date, col_uid, 2 as col_flag 
					from subscribe.tb_daily_users
					where p_date >= {date-6} and p_date >= {date}
				group by date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), interval 1 day), col_uid
		)ta 
		group by p_date, col_uid
	)tb
group by replace(date_add(p_date, interval 1 day),'-',''), col_flag