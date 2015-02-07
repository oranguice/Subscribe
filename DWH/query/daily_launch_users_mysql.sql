select p_date, count(distinct col_uid)
from tb_daily_users
where p_date >= {date-6} and p_date <= {date} and col_udid is not null
group by p_date