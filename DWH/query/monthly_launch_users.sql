select count(distinct col_uid)
from tb_daily_users
where p_date >= {date-29} and p_date <= {date} and col_udid is not null