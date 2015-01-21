select count(distinct col_uid)
from android.tb_card_show
where p_date >= {date-30} and p_date <= {date} and col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id not like '%RECOMMENDATION%' and col_uid > 0
--每月启动用户量，按 30 日计算。按排除掉 '%RECOMMENDATION%' 卡片记录的 UID 计算