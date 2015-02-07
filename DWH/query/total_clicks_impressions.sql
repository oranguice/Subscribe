select p_date, sum(col_feed_clicks), sum(col_feed_impressions)
from tb_daily_users
where p_date >= 20150131 and p_date <= 20150206
group by p_date