select p_date, sum(col_feed_clicks), sum(col_feed_impressions)
from tb_daily_users
where p_date >= {date-6} and p_date <= {date}
group by p_date