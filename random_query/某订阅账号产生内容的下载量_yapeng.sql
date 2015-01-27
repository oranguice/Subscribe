 select sum(col_downloads)
 from (
    select col_udid, sum(col_downloads) as col_downloads
    from (
            select col_udid, count(*) as col_downloads
            from android.tb_click
            where p_date = 20150125 and col_name = '安装' and col_startpage_card_id like '%ACCOUNT:101227283%'
            group by col_udid
        union all
            select a.col_udid, count(*) as col_downloads
            from (
                select col_udid, regexp_extract(col_url, '^.*pn=([_0-9a-zA-Z\.]+).*$', 1) as col_pn
                from android.tb_click
                where p_date = 20150125 and col_url_normalize like '/detail/app?pn=%' and col_name = '安装' and col_from_url = '/explore/subscribe_page')
            a join (
                select distinct case when col_itme_id like 'SubscribeFeed_v1%' then substring(col_item_id, locate(':', col_item_id)+1, 99) else substring(col_itme_id, 15, 99) end as col_pn
                from android.tb_click
                where p_date =20150125 and col_startpage_card_id like '%ACCOUNT:101227283%') b
            on a.col_pn = b.col_pn
            group by a.col_udid) c
    group by col_udid
union all
    select col_udid, sum(col_downloads) as col_downloads
    from (
            select col_udid, count(*) as col_downloads
            from android.tb_click
            where p_date = 20150125 and col_name = '安装' and col_url = '/publisher_profile?id=101227283'
            group by col_udid
        union all
            select col_udid, count(*) as col_downloads
            from android.tb_click
            where p_date = 20150125 and col_name = '安装' and col_url like '/detail/app?pn=%' and col_from_url = '/publisher_profile?id=101227283'
            group by col_udid) d
    group by col_udid
union all
    select e.col_udid, count(*) as col_downloads
    from (
            select col_udid, case when col_url like '/topic%' then substring(col_url, 11, 99) else substring(col_url, 20, 99) end as col_card_id
            from android.tb_click
            where p_date = 20150125 and (col_url_normalize = '/topic?id=' or col_url_normalize = '/subset_profile?id=') and col_name = '安装'
        union all
            select col_udid, case when col_from_url like '/topic%' then substring(col_url, 11, 99) else substring(col_url, 20, 99) end as col_card_id
            from android.tb_click
            where p_date = 20150125 and col_name = '安装' and col_url like '/detail/app?pn=%' and (col_from_url_normalize = '/topic?id=' or col_from_url_normalize = '/subset_profile?id=')
        ) e join (
            select distinct col_card_id
            from (
                    select substring(col_startpage_card_id, 33, 18) as col_card_id
                    from android.tb_card_show
                    where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%ACCOUNT:101227283%' and p_date = 20150125
                union all
                    select substring(col_startpage_card_id, 52, 18) as col_card_id
                    from android.tb_card_show
                    where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%ACCOUNT:101227283%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 1 and p_date = 20150125
                union all
                    select substring(col_startpage_card_id, 71, 18) as col_card_id
                    from android.tb_card_show
                    where col_startpage_card_id like 'SubscribeFeed_v1-SUBSCRIBE_FEED%ACCOUNT:101227283%' and length(col_startpage_card_id) - length(regexp_replace(col_startpage_card_id, '#', '')) >= 2 and p_date = 20150125) f
                ) g
        on e.col_card_id = f.col_card_id
    group by e.col_udid
) h