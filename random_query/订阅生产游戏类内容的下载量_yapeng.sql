select case when c.col_url_normalize is null then d.col_url_normalize else c.col_url_normalize end,
	case when c.col_user is null then d.col_user else c.col_user end,
	case when c.col_downloads is null then d.col_downloads else c.col_downloads end
from (
	select col_url_normalize, count(distinct col_udid) as col_user, count(*) as col_downloads
	from android.tb_click
	where col_name = '安装' and col_item_id like '%GAME%' and p_date = {date} and col_url_normalize not like '/search_result%'
	group by col_url_normalize) c
full outer join (
select '/detail/app?pn=' as col_url_normalize, count(distinct a.col_udid) as col_user, count(*) as col_downloads
from (
	select col_udid, regexp_extract(col_url, '^.*pn=([_0-9a-zA-Z\.]+).*$', 1) as col_pn
	from android.tb_click
	where col_url_normalize like '/detail/app?pn=%' and col_name = '安装' and (col_from_url_normalize like '/explore/subscribe%' or col_from_url_normalize like '/publisher_profile%' or col_from_url_normalize like '/subset_profile%' or col_from_url_normalize like '/topic%') and p_date = {date}) a
join (
select app_package_name
from datasystem.t_config_app
where app_type = 'GAME' and p_date = {date}) b
on a.col_pn = b.app_package_name) d
on c.col_url_normalize = d.col_url_normalize