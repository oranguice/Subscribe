select p_date, sum(col_subscribe_page_distribution), sum(col_subscribe_page_detail_distribtution), sum(col_publisher_distribution), sum(col_publisher_detail_distribution), sum(col_subset_distribution), sum(col_subset_detail_distribution)
from tb_daily_users
where p_date >= {date-6} and p_date <= {date}
group by p_date