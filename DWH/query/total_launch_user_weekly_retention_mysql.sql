select col_flag, count(*) as col_num
	from
	(
		select col_uid, sum(col_flag) as col_flag 
		from 
		( 
				select col_uid, 1 as col_flag 
					from subscribe.tb_daily_users
					where p_date >= {date-13} and p_date <= {date-7} and col_udid is not null
				group by col_uid
			union all 
				select col_uid, 2 as col_flag 
					from subscribe.tb_daily_users
					where p_date >= {date-6} and p_date <= {date} and col_udid is not null
				group by col_uid
		)ta 
		group by col_uid
	)tb
group by col_flag