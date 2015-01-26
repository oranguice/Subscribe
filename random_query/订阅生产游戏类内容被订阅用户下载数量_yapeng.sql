select d.col_udid, sum(d.col_downloads)
from (
	select col_udid, sum(col_downloads) as col_downloads
	from (
		select col_udid, count(*) as col_downloads
		from android.tb_click
		where col_name = '安装' and col_item_id like '%GAME%' and p_date = {date} and col_url_normalize not like '/search_result%'
		group by col_udid
		union all
		select a.col_udid, count(a.col_pn) as col_downloads
		from (
			select col_udid, regexp_extract(col_url, '^.*pn=([_0-9a-zA-Z\.]+).*$', 1) as col_pn
			from android.tb_click
			where  col_url_normalize like '/detail/app?pn=%' and col_name = '安装' and (col_from_url_normalize like '/explore/subscribe%' or col_from_url_normalize like '/publisher_profile%' or col_from_url_normalize like '/subset_profile%' or col_from_url_normalize like '/topic%') and p_date = {date}) a
			join (
			select app_package_name
			from datasystem.t_config_app
			where app_type = 'GAME' and p_date = {date}) b
		on a.col_pn = b.app_package_name
		group by a.col_udid) c
	) d join (
	select distinct col_udid
	from android.tb_card_show
	where p_date = {date} and col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id not like '%RECOMMENDATION%') e
on d.col_udid = e.col_udid





