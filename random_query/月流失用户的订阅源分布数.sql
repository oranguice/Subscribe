select f.col_sub_num, count(e.col_uid)
from (
	--e.筛选3月活跃但至4月流失的用户--start
	select c.col_uid
	from (
		select distinct col_uid
		from subscribe.tb_daily_users
		where p_date >= 20150227 and p_date <= 20150328) c
	left outer join (
		--d.筛选4月活跃的非新用户--start
		select a.col_uid
		from (
			select distinct col_uid
			from subscribe.tb_daily_users
			where p_date >= 20150329 and p_date <= 20150427) a
		left outer join (
			select col_uid
			from subscribe.tb_daily_users
			where p_date >= 20150329 and p_date <= 20150427 and col_new_user = 1) b
		on a.col_uid = b.col_uid
		where b.col_uid is null
		--d.筛选4月活跃的非新用户--end
		) d
	on c.col_uid = d.col_uid
	where d.col_uid is null
	--e.筛选3月活跃但至4月流失的用户--end
	) e
join (
	--f.用户订阅数--start
	select col_subscriberid, max(length(col_publisherids) - length(regexp_replace(col_publisherids, ',', '')) + 1) as col_sub_num
	from subscribe.tb_hubble_report_subscriber
	where p_date = 20150401
	group by col_subscriberid
	--f.用户订阅数--end
	) f
on e.col_uid = f.col_subscriberid
group by f.col_sub_num
--fin.月流失用户的订阅源分布数