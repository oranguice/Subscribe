select count(a.col_udid)
from (
	select distinct col_udid
	from android.tb_click
	where p_date = {date} and col_name = 'SWITCH_SUBSCRIBE_ENTRANCE'
) a join (
	select distinct col_udid
	from android.tb_card_show
	where p_date = {date} and col_startpage_card_id like '%RECOMMENDATION%') b
on a.col_udid = b.col_udid