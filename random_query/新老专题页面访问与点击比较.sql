select a.p_date,
count(distinct case when a.col_url like '/topic?id=%' then a.col_uid else null end),
count(case when a.col_url like '/topic?id=%' then a.col_uid else null end),
count(distinct case when a.col_url like '/subset_profil%' then a.col_uid else null end),
count(case when a.col_url like '/subset_profil%' then a.col_uid else null end)
from (
    select p_date, col_uid, col_url
    from android.tb_page_show
    where p_date = {date} and ((col_url like '/topic?id=%' and length(col_url) > 15) or col_url like '/subset_profil%')) a
join (
    select p_date, col_uid
    from subscribe.tb_daily_users
    where p_date = {date} and col_new_user = 0) b
on a.p_date = b.p_date and a.col_uid = b.col_uid
group by a.p_date
--New-订阅用户中看到：新专题人数；次数；老专题人数；次数



select a.p_date,
count(distinct case when a.col_url like '/topic?id=%' then a.col_udid else null end),
count(case when a.col_url like '/topic?id=%' then a.col_udid else null end),
count(distinct case when a.col_url like '/subset_profil%' then a.col_udid else null end),
count(case when a.col_url like '/subset_profil%' then a.col_udid else null end)
from (
    select p_date, col_udid, col_url
    from android.tb_page_show
    where p_date = {date} and ((col_url like '/topic?id=%' and length(col_url) > 15) or col_url like '/subset_profil%')) a
left outer join (
    select p_date, col_udid
    from subscribe.tb_daily_users
    where p_date = {date}) b
on a.p_date = b.p_date and a.col_udid = b.col_udid
where b.col_udid is null
group by a.p_date
--New-非订阅用户中看到：新专题人数；次数；老专题人数；次数



select a.p_date,
sum(case when a.col_url like '/topic?id=%' and a.col_name = '关注' then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and a.col_name = 'topic_item' then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and (a.col_name = '安装' or a.col_name = '播放') then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and a.col_name = 'topic_next' then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and a.col_name = 'topic_footer' then 1 else 0 end),
sum(case when a.col_url like '/subset_profil%' and a.col_name = '关注' then 1 else 0 end),
sum(case when a.col_url like '/subset_profil%' and a.col_name = 'subscribe_item' then 1 else 0 end),
sum(case when a.col_url like '/subset_profil%' and (a.col_name = '安装' or a.col_name = '播放') then 1 else 0 end)
from (
    select p_date, col_uid, col_url, col_name
    from android.tb_click
    where p_date = {date} and ((col_url like '/topic?id=%' and length(col_url) > 15) or col_url like '/subset_profil%')) a
join (
    select p_date, col_uid
    from subscribe.tb_daily_users
    where p_date = {date} and col_new_user = 0) b
on a.p_date = b.p_date and a.col_uid = b.col_uid
group by a.p_date
--New-订阅用户中点击：新专题关注、内容、消费、下一个、更多；老专题关注、内容、消费


select a.p_date,
sum(case when a.col_url like '/topic?id=%' and a.col_name = '关注' then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and a.col_name = 'topic_item' then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and (a.col_name = '安装' or a.col_name = '播放') then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and a.col_name = 'topic_next' then 1 else 0 end),
sum(case when a.col_url like '/topic?id=%' and a.col_name = 'topic_footer' then 1 else 0 end),
sum(case when a.col_url like '/subset_profil%' and a.col_name = '关注' then 1 else 0 end),
sum(case when a.col_url like '/subset_profil%' and a.col_name = 'subscribe_item' then 1 else 0 end),
sum(case when a.col_url like '/subset_profil%' and (a.col_name = '安装' or a.col_name = '播放') then 1 else 0 end)
from (
    select p_date, col_udid, col_url, col_name
    from android.tb_click
    where p_date = {date} and ((col_url like '/topic?id=%' and length(col_url) > 15) or col_url like '/subset_profil%')) a
left outer join (
    select p_date, col_udid
    from subscribe.tb_daily_users
    where p_date = {date}) b
on a.p_date = b.p_date and a.col_udid = b.col_udid
where b.col_udid is null
group by a.p_date
--New-非订阅用户中点击：新专题关注、内容、消费、下一个、更多；老专题关注、内容、消费

