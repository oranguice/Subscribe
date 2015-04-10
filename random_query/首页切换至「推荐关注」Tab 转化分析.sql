select p_date, count(distinct col_udid)
from startpage.tb_card
where p_date >= 20150320 and p_date <= 20150323 and col_client_version like '4.25%'
group by p_date
--每天看到 Tab 的人



select p_date, count(distinct col_udid)
from android.tb_click
where p_date >= 20150320 and p_date <= 20150323 and col_url_normalize = '/explore/subscribe_page' and col_name = 'SWITCH_START_ENTRANCE' and col_vn like '4.25%'
group by p_date
--每天从首页点击去关注 Tab 的人




select a.p_date, count(distinct a.col_udid)
from (
	select p_date, col_udid
	from android.tb_click
	where p_date >= 20150320 and p_date <= 20150323 and col_url_normalize = '/explore/subscribe_page' and col_name = 'SWITCH_START_ENTRANCE' and col_vn like '4.25%'
	group by p_date, col_udid) a
left outer join (
	select p_date, col_udid
	from subscribe.tb_daily_users
	where p_date >= 20150320 and p_date <= 20150323 and col_new_user != 1 and col_version like '4.25%'
	group by p_date, col_udid) b
on a.p_date = b.p_date and a.col_udid = b.col_udid
where b.col_udid is null
group by a.p_date
--点击订阅 Tab 的人数（包括订阅新用户，但排除订阅老用户）




select p_date, count(distinct col_udid)
from android.tb_click
where p_date >= 20150320 and p_date <= 20150323 and col_url_normalize = '/explore/subscribe_page' and col_action = 'SUBSCRIBE' and col_vn like '4.25%'
group by p_date
--点击订阅 Tab 中「关注」按钮的用户数





select a.p_date, count(distinct a.col_udid)
from (
	select p_date, col_udid
	from android.tb_click
	where p_date >= 20150320 and p_date <= 20150323 and col_url_normalize = '/explore/subscribe_page' and col_action = 'SUBSCRIBE' and col_vn like '4.25%'
	group by p_date, col_udid) a
join (
	select p_date, col_udid
	from subscribe.tb_daily_users
	where p_date >= 20150320 and p_date <= 20150323 and col_new_user = 1 and col_version like '4.25%'
	group by p_date, col_udid) b
on a.col_udid = b.col_udid and a.p_date = b.p_date
group by a.p_date
--点击订阅 Tab 中「关注」按钮，且成功成为订阅用户的数量





select c.p_date, c.col_subscriberid, c.num
from (
	select p_date, col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', ''))) as num
	from subscribe.tb_hubble_report_subscriber
	where p_date = 20150324
	group by p_date, col_subscriberid, (length(col_publisherids) - length(regexp_replace(col_publisherids, ',', '')))) c
join (
	select b.p_date, b.col_uid 
	from (
		select p_date, col_udid
		from android.tb_click
		where p_date >= 20150320 and p_date <= 20150323 and col_url_normalize = '/explore/subscribe_page' and col_action = 'SUBSCRIBE' and col_vn like '4.25%'
		group by p_date, col_udid) a
	join (
		select p_date, col_udid, col_uid
		from subscribe.tb_daily_users
		where p_date >= 20150320 and p_date <= 20150323 and col_new_user = 1 and col_version like '4.25%'
		group by p_date, col_udid, col_uid) b
	on a.col_udid = b.col_udid and a.p_date = b.p_date
	group by b.p_date, b.col_uid) d
on c.col_subscriberid = d.col_uid
group by c.p_date, c.col_subscriberid, c.num
--点击订阅 Tab 中「关注」按钮，且成功成为订阅用户时，多少个订阅源