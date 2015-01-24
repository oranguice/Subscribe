select p_date, flag, count(*)
from
(
	select p_date, col_uid, sum(flag) as flag 
	from 
	( 
			select concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)) as p_date, substring(col_subscriberid, 9) as col_uid, 1 as flag 
				from subscribe.tb_hubble_subscriber_new
				where p_date >= {date-y-x} and p_date <= {date-x}
			group by concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), substring(col_subscriberid, 9)
		union all 
			select date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), {x}) as p_date, col_uid, 2 as flag 
				from android.tb_card_show
				where p_date >= {date-y} and p_date <= {date} and col_startpage_card_feed_name = 'SubscribeFeed' and col_uid > 0
			group by date_sub(concat(substring(p_date, 1, 4), '-', substring(p_date, 5, 2), '-', substring(p_date, 7, 2)), 1), col_uid
	)ta 
	group by p_date, col_uid
)tb
group by p_date, flag
