select b.p_date, count(distinct a.col_uid), sum(b.col_launches)
from
	(
	select p_date, col_uid, col_udid
	from android.tb_card_show
	where p_date = {date} and col_startpage_card_feed_name = 'SubscribeFeed' and col_uid > 0 and col_startpage_card_id not like '%RECOMMENDATION%'
	group by p_date, col_uid, col_udid)
a join (
	select p_date, col_uid, col_udid, count(*) as col_launches
	from android.tb_application_start
	where p_date = {date}
	group by p_date, col_uid, col_udid
	) b
on a.p_date = b.p_date and a.col_uid = b.col_uid and a.col_udid = b.col_udid
group by b.p_date