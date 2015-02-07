select p_date, sum(col_content_card_num), count(DISTINCT col_udid)
from tb_daily_users
where p_date >= {date-6} and p_date <= {date} and col_content_card_num > 0
group by p_date