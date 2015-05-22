select p_date, sum(case when substring(col_uid, length(col_uid), 1) < 5 then col_feed_clicks else 0 end)/sum(case when substring(col_uid, length(col_uid), 1) < 5 then col_feed_impressions else 0 end), sum(case when substring(col_uid, length(col_uid), 1) >= 5 then col_feed_clicks else 0 end)/sum(case when substring(col_uid, length(col_uid), 1) >= 5 then col_feed_impressions else 0 end)
from tb_daily_users
where p_date >= 20150425 and p_date <= 20150508
group by p_date