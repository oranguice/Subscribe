select g.col_uid, f.col_visible_num, g.col_readed_num
from (
	--f.对照用户的订阅列表，计算用户每日可见的最大内容发布量--start
	select c.col_subscriberid, sum(case when find_in_set(d.col_publisherid, c.col_publisherids) > 0 then d.col_published_num else 0L end) as col_visible_num
	from (
		--c.当日 DLU 的关注列表--start
		select b.col_subscriberid, b.col_publisherids
		from (
			select distinct col_uid
			from subscribe.tb_daily_users
			where p_date = 20150506) a
		join (
			select col_subscriberid, col_publisherids
			from subscribe.tb_hubble_report_subscriber
			where p_date = 20150507) b
		on a.col_uid = b.col_subscriberid
		--c.当日 DLU 的关注列表--end
		) c
	join (
		--d.订阅源日发布内容量--start
		select col_publisherid, count(*) as col_published_num
		from subscribe.tb_daily_content
		where p_date = 20150506 and col_new_published = 1
		group by col_publisherid
		--d.订阅源日发布内容量--end
		) d
	group by c.col_subscriberid
	--f.对照用户的订阅列表，计算用户每日可见的最大内容发布量--end
	) f
join (
	--g.用户阅读过的卡片数--start
	select col_uid, count(distinct col_card_id) as col_readed_num
	from (
		select col_uid, substring(col_startpage_card_id, 33, 18) as col_card_id
		from android.tb_card_show
		where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and p_date = 20150506
	union all
		select col_uid, substring(col_startpage_card_id, 52, 18) as col_card_id
		from android.tb_card_show
		where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date = 20150506
	union all
		select col_uid, substring(col_startpage_card_id, 71, 18) as col_card_id
		from android.tb_card_show
		where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date = 20150506) e
	group by col_uid
	--g.用户阅读过的不同卡片数--end
	) g
on f.col_subscriberid = g.col_uid
--fin.用户UID、可见的更新内容数、当日看过的内容数