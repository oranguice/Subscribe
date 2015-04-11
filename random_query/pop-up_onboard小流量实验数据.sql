select p_date, count(distinct case when col_version = '4.25.1.7962' then col_udid else null end),
count(distinct case when col_version = '4.25.1.7962' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7963' then col_udid else null end),
count(distinct case when col_version = '4.25.1.7963' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7964' then col_udid else null end),
count(distinct case when col_version = '4.25.1.7964' then col_uid else null end)
from android.tb_application_start
where p_date >= 20150323 and p_date <= 20150324
group by p_date
--分天记各个版本的 DLU 数量，按 UDID 和 UID 区分


select count(distinct case when col_version = '4.25.1.7962' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7963' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7964' then col_uid else null end)
from android.tb_page_show
where p_date >= 20150323 and p_date <= 20150324 and col_url = '/subscribe_welcome'
--不分天记各个版本的 welcome DLU 数量


select p_date, count(distinct case when col_version = '4.25.1.7962' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7963' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7964' then col_uid else null end)
from android.tb_click
where p_date >= 20150323 and p_date <= 20150324 and col_name = 'subscribe_welcome_next_button'
group by p_date
--分天记各个版本第一欢迎页面点击下一步人数


select count(distinct case when col_version = '4.25.1.7962' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7963' then col_uid else null end),
count(distinct case when col_version = '4.25.1.7964' then col_uid else null end)
from android.tb_click
where p_date >= 20150323 and p_date <= 20150324 and col_name = 'subscribe_welcome_next_button'
--不分天记各个版本第一欢迎页面点击下一步人数



select count(distinct case when col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK=' then col_uid else null end),
count(distinct case when col_url = '/subscribe_onboard?CATEGORY=PUBLISHER&RANK=0' then col_uid else null end),
count(distinct case when col_url = '/subscribe_onboard?CATEGORY=PUBLISHER&RANK=1' then col_uid else null end),
count(distinct case when col_url = '/subscribe_onboard?CATEGORY=PUBLISHER&RANK=2' then col_uid else null end)
from android.tb_page_show
where p_date >= 20150323 and p_date <= 20150324 and col_version = '4.25.1.7962'
--A方案，选择页面访问人数



select count(distinct col_uid)
from android.tb_page_show
where p_date >= 20150323 and p_date <= 20150324 and col_version = '4.25.1.7963' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK='
--B方案，选择页面访问人数


select count(distinct col_uid)
from android.tb_page_show
where p_date >= 20150323 and p_date <= 20150324 and col_version = '4.25.1.7964' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK='
--C方案，选择页面访问人数


select count(distinct case when col_name = '选好了' then col_uid else null end),
count(distinct case when col_name = 'subscribe_onboard_close' then col_uid else null end),
count(distinct case when (col_action = 'SELECT' or col_action = 'UNSELECT') then col_uid else null end),
sum(case when col_action = 'SELECT' then 1 else 0 end),
sum(case when col_action = 'UNSELECT' then 1 else 0 end)
from android.tb_click
where p_date >= 20150323 and p_date <= 20150324 and col_version = '4.25.1.7962' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK='
--A方案：选好了、关闭、选择人数、加选量、减选量


select count(distinct case when col_name = '选好了' then col_uid else null end),
count(distinct case when col_name = 'subscribe_onboard_close' then col_uid else null end),
count(distinct case when (col_action = 'SELECT' or col_action = 'UNSELECT') then col_uid else null end),
sum(case when col_action = 'SELECT' then 1 else 0 end),
sum(case when col_action = 'UNSELECT' then 1 else 0 end)
from android.tb_click
where p_date >= 20150323 and p_date <= 20150324 and col_version = '4.25.1.7963' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK='
--B方案：选好了、关闭、选择人数、加选量、减选量


select count(distinct case when col_name = '选好了' then col_uid else null end),
count(distinct case when col_name = 'subscribe_onboard_close' then col_uid else null end),
count(distinct case when (col_action = 'SELECT' or col_action = 'UNSELECT') then col_uid else null end),
sum(case when col_action = 'SELECT' then 1 else 0 end),
sum(case when col_action = 'UNSELECT' then 1 else 0 end)
from android.tb_click
where p_date >= 20150323 and p_date <= 20150324 and col_version = '4.25.1.7964' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK='
--C方案：选好了、关闭、选择人数、加选量、减选量


select a.col_subscriberid, a.num
from (
	select col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', ''))) as num
	from subscribe.tb_hubble_report_subscriber
	where p_date = 20150325
	group by col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', '')))) a
join (
	select distinct col_uid
	from android.tb_click
	where p_date >= 20150323 and p_date <= 20150324 and col_name = '选好了' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK=' and col_version = '4.25.1.7962') b
on a.col_subscriberid = b.col_uid
--A方案订阅者订阅数


select a.col_subscriberid, a.num
from (
	select col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', ''))) as num
	from subscribe.tb_hubble_report_subscriber
	where p_date = 20150325
	group by col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', '')))) a
join (
	select distinct col_uid
	from android.tb_click
	where p_date >= 20150323 and p_date <= 20150324 and col_name = '选好了' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK=' and col_version = '4.25.1.7963') b
on a.col_subscriberid = b.col_uid
--B方案订阅者订阅数


select a.col_subscriberid, a.num
from (
	select col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', ''))) as num
	from subscribe.tb_hubble_report_subscriber
	where p_date = 20150325
	group by col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', '')))) a
join (
	select distinct col_uid
	from android.tb_click
	where p_date >= 20150323 and p_date <= 20150324 and col_name = '选好了' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK=' and col_version = '4.25.1.7964') b
on a.col_subscriberid = b.col_uid
--C方案订阅者订阅数


select distinct col_uid
from android.tb_click
where p_date >= 20150323 and p_date <= 20150324 and col_name = '选好了' and col_url_normalize = '/subscribe_onboard?CATEGORY=&RANK=' and (col_version = '4.25.1.7962' or col_version = '4.25.1.7963' or col_version = '4.25.1.7964')
--点击过「选好了」的UID




select c.col_uid, c.col_udid, c.col_launch_days
from (
	select a.col_uid, a.col_udid, a.col_launch_days
	from (
		select col_uid, col_udid, count(distinct p_date) as col_launch_days
		from android.tb_application_start
		where p_date >= 20150122 and p_date <= 20150322 and col_uid > 0 and col_ch = 'wandoujia_pc_wandoujia2_homepage'
		group by col_uid, col_udid) a
	left outer join (
		select col_uid, count(distinct p_date) as col_launch_days
		from android.tb_application_start
		where p_date >= 20150221 and p_date <= 20150322 and col_uid > 0
		group by col_uid
		order by col_launch_days desc
		limit 600000) b
	on a.col_uid = b.col_uid
	where b.col_uid is null) c
left outer join (
	select distinct col_uid
	from subscribe.tb_daily_users
	where p_date >= 20140101 and p_date <= 20150322) d
on c.col_uid = d.col_uid
where d.col_uid is null
--- 第二次小流量用户 udid，排除掉第一次小流量的活跃用户



select a.col_udid, a.num
from (
	select col_uid, col_udid
	from subscribe.tb_daily_users
	where p_date >= 20141201 and p_date <= 20150322
	group by col_uid, col_udid) a
join (
	select p_date, col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', ''))) as num
	from subscribe.tb_hubble_report_subscriber
	where p_date = 20150322
	group by p_date, col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', '')))) b
on a.col_uid = b.col_subscriberid
where a.num > 4
---选出关注数量超过 4 的用户