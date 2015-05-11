select col_card_id, col_content_type, col_content_detail, col_ctr
from (
	select b.col_card_id, c.col_content_type, c.col_content_detail, (case when b.col_feed_impressions < 1000 then 0.00 else b.col_feed_clicks/b.col_feed_impressions end) as col_ctr
	from (
		select col_card_id, sum(case when col_action = 'CLICK' then 1 else 0 end) as col_feed_clicks, sum(case when col_action = 'SHOW' then 1 else 0 end) as col_feed_impressions
		from (
			select substring(col_item_id, 18, 18) as col_card_id, 'CLICK' as col_action
			from android.tb_click
			where col_startpage_card_feed_name = 'SubscribeFeed' and col_item_id like 'SubscribeFeed_v1-%' and p_date = {date} and col_vc >= 7857
		union all
			select substring(col_startpage_card_id, 33, 18) as col_card_id, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and p_date = {date}
		union all
			select substring(col_startpage_card_id, 52, 18) as col_card_id, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date = {date}
		union all
			select substring(col_startpage_card_id, 71, 18) as col_card_id, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date = {date}) a
		group by col_card_id) b
	join (
		select col_itemlist_id, col_content_type, col_content_detail
		from subscribe.tb_daily_content
		where p_date = {date} and col_new_published = 1) c
	on b.col_card_id = c.col_itemlist_id
	where c.col_content_type = 'APP' or c.col_content_type = 'GAME') d
order by col_ctr desc
--针对每日内容榜单的内容排序算法，参见 Follow v1.12，P4 4.30 产品设计文档，https://docs.google.com/document/d/1e1PKYw4_b6sx6mgRNct5eF9RkAji--xzOvZM_5FBnQs/edit