select b.col_publisherid, case when col_feed_impressions < 10000 then 0.00 else b.col_feed_clicks/b.col_feed_impressions end
from (
	select a.col_publisherid, sum(case when col_action = 'CLICK' then 1 else 0 end) as col_feed_clicks, sum(case when col_action = 'SHOW' then 1 else 0 end) as col_feed_impressions
	from (
			select substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, 'CLICK' as col_action
			from android.tb_click
			where col_startpage_card_feed_name = 'SubscribeFeed' and col_item_id like 'SubscribeFeed_v1-%' and p_date >= {date-6} and p_date <= {date} and col_vc >= 7857
		union all
			select substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and p_date >= {date-6} and p_date <= {date}
		union all
			select substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date >= {date-6} and p_date <= {date}
		union all
			select substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date >= {date-6} and p_date <= {date}) a
	group by a.col_publisherid) b
--针对Feed流排序优化策略的订阅源权重算法，参见 Follow v1.12，P4 4.30 产品设计文档，https://docs.google.com/document/d/1e1PKYw4_b6sx6mgRNct5eF9RkAji--xzOvZM_5FBnQs/edit