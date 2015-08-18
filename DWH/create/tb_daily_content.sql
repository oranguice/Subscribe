select col_card_id, sum(case when col_action = 'CLICK' then 1 else 0 end) as col_feed_clicks, sum(case when col_action = 'SHOW' then 1 else 0 end) as col_feed_impressions
from (
	select p_date, substring(col_item_id, 18, 18) as col_card_id, 'CLICK' as col_action
	from android.tb_click
	where col_startpage_card_feed_name = 'SubscribeFeed' and col_item_id like 'SubscribeFeed_v1-%' and p_date = {date} and col_vc >= 7857
union all
	select p_date, substring(col_startpage_card_id, 33, 18) as col_card_id, 'SHOW' as col_action 
	from android.tb_card_show
	where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and p_date = {date}
union all
	select p_date, substring(col_startpage_card_id, 52, 18) as col_card_id, 'SHOW' as col_action 
	from android.tb_card_show
	where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date = {date}
union all
	select p_date, substring(col_startpage_card_id, 71, 18) as col_card_id, 'SHOW' as col_action 
	from android.tb_card_show
	where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date = {date}
union all
	select p_date, substring(col_startpage_card_id, 90, 18) as col_card_id, 'SHOW' as col_action 
	from android.tb_card_show
	where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 3 and p_date = {date}
union all
	select p_date, substring(col_startpage_card_id, 109, 18) as col_card_id, 'SHOW' as col_action 
	from android.tb_card_show
	where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 4 and p_date = {date}) a
group by col_card_id
--最简模式下的内容数据仓库 step-1

select c.p_date, c.col_publisherid, c.col_title, c.col_subscribedcount, c.col_card_id, c.col_feed_clicks, c.col_feed_impressions, case when d.col_card_id is null then 0 else 1 end
from (
	select a.p_date, a.col_publisherid, b.col_title, b.col_subscribedcount, a.col_card_id, a.col_feed_clicks, a.col_feed_impressions
	from (
		select p_date, col_publisherid, col_card_id, sum(case when col_action = 'CLICK' then 1 else 0 end) as col_feed_clicks, sum(case when col_action = 'SHOW' then 1 else 0 end) as col_feed_impressions
		from (
			select p_date, substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, substring(col_item_id, 18, 18) as col_card_id, 'CLICK' as col_action
			from android.tb_click
			where col_startpage_card_feed_name = 'SubscribeFeed' and col_item_id like 'SubscribeFeed_v1-%' and p_date = {date} and col_vc >= 7857
		union all
			select p_date, substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, substring(col_startpage_card_id, 33, 18) as col_card_id, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and p_date = {date}
		union all
			select p_date, substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, substring(col_startpage_card_id, 52, 18) as col_card_id, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date = {date}
		union all
			select p_date, substring(substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99), 1, locate('-', substring(col_startpage_card_id, locate('ACCOUNT:', col_startpage_card_id)+8, 99))-1) as col_publisherid, substring(col_startpage_card_id, 71, 18) as col_card_id, 'SHOW' as col_action 
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date = {date}) a
		group by p_date, col_publisherid, col_card_id) a
	left outer join (
		select substring(col_publisherid, 9, 99) as col_publisherid, col_title, max(col_subscribedcount) as col_subscribedcount
		from subscribe.tb_hubble_report_publisher
		where p_date = {date+1}
		group by substring(col_publisherid, 9, 99), col_title) b
	on a.col_publisherid = b.col_publisherid) c
left outer join (
	select substring(col_contentitemid, 10, 99) as col_card_id
	from subscribe.tb_subscribe_item_published
	where p_date = {date} and col_messagetype = 'CREATE' and col_contentitemlabel = 'ITEMLIST' and col_publisherlabel = 'ACCOUNT') d
on c.col_card_id = d.col_card_id
--最全模式下的内容数据仓库,日期,订阅源UID,订阅源名,订阅源粉丝数,内容卡片ID,点击数,展示数,是否为昨天新发布内容