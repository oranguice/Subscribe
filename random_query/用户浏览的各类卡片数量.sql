select d.p_date, count(distinct d.col_uid), sum(d.col_app_item_num), sum(d.col_game_item_num), sum(d.col_video_item_num), sum(d.col_list_item_num)
from (
	select b.p_date, b.col_uid, sum(case when c.col_content_type = 'APP' then 1 else 0 end) as col_app_item_num, sum(case when c.col_content_type = 'GAME' then 1 else 0 end) as col_game_item_num, sum(case when c.col_content_type = 'VIDEO' then 1 else 0 end) as col_video_item_num, sum(case when c.col_content_type = 'LIST' then 1 else 0 end) as col_list_item_num
	from (
		select p_date, col_uid, col_card_id
		from (
				select p_date, col_uid, substring(col_startpage_card_id, 33, 18) as col_card_id
				from android.tb_card_show
				where col_uid > 0 and col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and p_date >= {date-6} and p_date <= {date}
			union all
				select p_date, col_uid, substring(col_startpage_card_id, 52, 18) as col_card_id
				from android.tb_card_show
				where col_uid > 0 and col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date >= {date-6} and p_date <= {date}
			union all
				select p_date, col_uid, substring(col_startpage_card_id, 71, 18) as col_card_id
				from android.tb_card_show
				where col_uid > 0 and col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date >= {date-6} and p_date <= {date}) a
			group by p_date, col_uid, col_card_id) b
	left outer join (
		select p_date, col_itemlist_id, col_content_type
		from subscribe.tb_daily_content
		where p_date >= {date-6} and p_date <= {date}) c
	on b.col_card_id = c.col_itemlist_id and b.p_date = c.p_date
	group by b.p_date, b.col_uid) d
join (
	select col_uid
	from subscribe.tb_daily_users
	where p_date >= {date-6} and p_date <= {date} )e
on d.col_uid = e.col_uid
group by d.p_date
--用户浏览的各类内容数量,应用、游戏、视频、专题