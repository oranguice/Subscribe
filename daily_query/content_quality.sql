select col_card_id, col_publisher_id, col_publisher_nick, col_action, sum(col_num)
from (
	select col_card_id, col_publisher_id, col_publisher_nick, col_action, count(*) as col_num
	from (
			select substring(col_item_id, 18, 18) as col_card_id, col_publisher_id, col_publisher_nick, 'CLICK' as col_action
			from android.tb_click
			where col_item_id like 'SubscribeFeed_v1-%' and col_vc >= 7857 and p_date = {date} and col_startpage_card_feed_name = 'SubscribeFeed'
		union all
			select substring(col_startpage_card_id, 33, 18) as col_card_id, col_publisher_id, col_publisher_nick, 'CLICK' as col_action
			from android.tb_click
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED-%' and col_vc < 7857 and p_date = {date}) a
	group by col_card_id, col_publisher_id, col_publisher_nick, col_action
	union all
	select col_card_id, col_publisher_id, col_publisher_nick, col_action, count(*) as col_num
	from (
			select substring(col_startpage_card_id, 33, 18) as col_card_id, col_publisher_id, col_publisher_nick, 'SHOW' as col_action
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and p_date = {date}
		union all
			select substring(col_startpage_card_id, 52, 18) as col_card_id, col_publisher_id, col_publisher_nick, 'SHOW' as col_action
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date = {date}
		union all
			select substring(col_startpage_card_id, 71, 18) as col_card_id, col_publisher_id, col_publisher_nick, 'SHOW' as col_action
			from android.tb_card_show
			where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date = {date}
		) b
	group by col_card_id, col_publisher_id, col_publisher_nick, col_action
	) ta
group by col_card_id, col_publisher_id, col_publisher_nick, col_action
