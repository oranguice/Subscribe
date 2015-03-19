select p_date, count(distinct col_uid), sum(col_launches)
from tb_daily_users
where p_date >= {date-6} and p_date <= {date} and col_launches > 0 and col_udid is not null
group by p_date