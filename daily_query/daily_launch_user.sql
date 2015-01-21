select p_date, count(distinct col_uid)
from android.tb_card_show
where p_date = {date} and col_startpage_card_feed_name = 'SubscribeFeed' and col_startpage_card_id not like '%RECOMMENDATION%' and col_uid > 0
group by p_date
--使用 UID 代表独立用户，但排除掉看过'%RECOMMENDATION%'卡片 - 即 21 个订阅源头像的记录