select p_date, count(distinct col_subscriberid)
from subscribe.tb_hubble_subscriber_new
where p_date = {date}
group by p_date