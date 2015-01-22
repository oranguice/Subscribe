select e.p_date, e.col_uid, e.col_udid, e.col_version, e.col_feed_card_num, e.col_content_card_num, case when e.col_udid is not null and e.col_feed_clicks is null then 0L else e.col_feed_clicks end, e.col_feed_impressions, case when e.col_udid is not null and e.col_subscribe_page_distribution is null then 0L else e.col_subscribe_page_distribution end, case when e.col_udid is not null and e.col_subscribe_page_detail_distribution is null then 0L else e.col_subscribe_page_detail_distribution end, case when e.col_udid is not null and e.col_publisher_distribution is null then 0L else e.col_publisher_distribution end, case when e.col_udid is not null and e.col_publisher_detail_distribution is null then 0L else e.col_publisher_detail_distribution end, case when e.col_udid is not null and e.col_subset_distribution is null then 0L else e.col_subset_distribution end, case when e.col_udid is not null and e.col_subset_detail_distribution is null then 0L else e.col_subset_detail_distribution end, f.col_launches, e.col_new_user
from (
	select c.p_date, c.col_uid, c.col_udid, c.col_version, c.col_feed_card_num, c.col_content_card_num, d.col_feed_clicks, c.col_feed_impressions, d.col_subscribe_page_distribution, d.col_subscribe_page_detail_distribution, d.col_publisher_distribution, d.col_publisher_detail_distribution, d.col_subset_distribution, d.col_subset_detail_distribution, c.col_new_user
	from (
		select case when a.p_date is null then b.p_date else a.p_date end as p_date, case when a.col_uid is null then b.col_uid else a.col_uid end as col_uid , a.col_udid, a.col_version, a.col_feed_card_num, a.col_content_card_num, a.col_feed_impressions, case when b.col_uid is null then 0 else 1 end as col_new_user
		from (
			select p_date, col_uid, col_udid, max(col_version) as col_version, count(distinct col_startpage_card_id) as col_feed_card_num, count(distinct case when col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%' then col_startpage_card_id else null end) as col_content_card_num, count(col_startpage_card_id) as col_feed_impressions
			from android.tb_card_show
			where col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id not like '%RECOMMENDATION%' and col_uid > 0 and p_date = {date}
			group by p_date, col_uid, col_udid) a
		full outer join (
			select p_date, substring(col_subscriberid, 9, 99) as col_uid
			from subscribe.tb_hubble_subscriber_new
			where p_date = {date}
			group by p_date, substring(col_subscriberid, 9, 99)
			) b
		on a.p_date = b.p_date and a.col_uid = b.col_uid) c
	left outer join (
		select p_date, col_uid, col_udid,
		sum(case when col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id not like '%RECOMMENDATION%' then 1 else 0 end) as col_feed_clicks,
		sum(case when col_name in ('安装','播放') and col_startpage_card_feed_name = 'SubscribeFeed' then 1 else 0 end) as col_subscribe_page_distribution,
		sum(case when col_name in ('安装','播放') and col_url_normalize like '/detail%' and col_from_url_normalize in ('/explore/subscribe_page','/explore/startpage') then 1 else 0 end) as col_subscribe_page_detail_distribution,
		sum(case when col_name in ('安装','播放') and col_url_normalize like '/publisher_profile%' then 1 else 0 end ) as col_publisher_distribution,
		sum(case when col_name in ('安装','播放') and col_url_normalize like '/detail%' and col_from_url_normalize like '/publisher_profile%' then 1 else 0 end) as col_publisher_detail_distribution,
		sum(case when col_name in ('安装','播放') and (col_url_normalize like '/subset_profile%' or col_url_normalize like '/topic%') then 1 else 0 end) as col_subset_distribution,
		sum(case when col_name in ('安装','播放') and col_url_normalize like '/detail%' and (col_from_url_normalize like '/subset_profile%' or col_from_url_normalize like '/topic%') then 1 else 0 end) as col_subset_detail_distribution
		from android.tb_click
		where col_uid > 0 and p_date = {date}
		group by p_date, col_uid, col_udid) d
	on c.col_udid = d.col_udid and c.p_date = d.p_date and c.col_uid = d.col_uid) e
left outer join (
	select p_date, col_uid, col_udid, count(*) as col_launches
	from android.tb_application_start
	where p_date = {date}
	group by p_date, col_uid, col_udid) f
on e.p_date = f.p_date and e.col_uid = f.col_uid and e.col_udid = f.col_udid