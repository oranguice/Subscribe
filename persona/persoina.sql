launch_times
CREATE TABLE launch_times AS
SELECT col_udid,
       count(*) AS launch_times
FROM android.tb_application_start
WHERE p_date>='20140701'
  AND p_date<='20140731'
GROUP BY col_udid;

launched_days & search_count & apps_down & games_down & comments & model & uninstall & clicks & uid
CREATE TABLE clicks AS
SELECT col_udid,
       count(DISTINCT p_date) AS launched_days,
       count(DISTINCT p_date, col_keyword) AS search_count,
       count(IF(col_name = '下载'
                AND col_element = 'BUTTON'
                AND col_content_package_name != '', 1, NULL)) AS apps_down,
       collect_set(col_model)[0] AS model,
       collect_set(col_uid) AS uids,
       count(*) AS clicks,
       count(IF(col_element='BUTTON'
                AND col_name='评论'
                AND col_url_normalize NOT LIKE '/detail/topic/%'
                AND col_refer_url_normalize LIKE '/detail/app%', 1, NULL)) AS comments,
       count(if(col_element='BUTTON'
                AND col_name='卸载',1,NULL)) AS uninstalls
FROM android.tb_click
WHERE p_date>='20140701'
  AND p_date<='20140731'
  AND col_vn RLIKE '^4.4|4.5|4.6|4.7|4.8|4.9|4.10|4.12|4.13'
GROUP BY col_udid;

video_consum & wallpaper_consum
CREATE TABLE consums AS
SELECT col_udid,
       count(DISTINCT IF(col_content_type='VIDEO', col_resource_id, NULL)) AS video_consum,
       count(DISTINCT IF(col_content_type='WALLPAPER', col_resource_id, NULL)) AS wallpaper_consum,
       count(IF(col_content_type='VIDEO', 1, NULL)) AS video_consum_all,
       count(DISTINCT IF(col_content_type='EBOOK', col_resource_id, NULL)) AS ebook_consum,
       count(IF(col_content_type='EBOOK', 1, NULL)) AS ebook_consum_all
FROM android.tb_consumption
WHERE p_date>='20140701'
  AND p_date<='20140731'
GROUP BY col_udid

-- todo: add jar with abs path
udid_ip
add jar ipfinder.jar;create temporary function ipfinder as 'IPFinderUDF';
CREATE TABLE udid_ip AS
SELECT col_udid,
       collect_set(loc)[0]
FROM
  (SELECT col_udid,
          ipfinder(col_ip) AS loc
   FROM startpage.tb_startpage_star_fetch
   WHERE p_date >='20140701'
     AND p_date<='20140731')a
GROUP BY col_udid;

applist_info
~/hadoop-v2/hadoop/bin/hadoop jar ~/hadoop-v2/hadoop/contrib/streaming/hadoop-streaming-1.0.2-w1.2.0.jar -D stream.non.zero.exit.is.failure=false -input /tmp/songge/userprofile_online/\* -output /app/startpage/s2/applist -mapper 'python applist.py' -file app.list -file sns.list -file applist.py  -numReduceTasks 0

CREATE EXTERNAL TABLE IF NOT EXISTS applist_info (col_udid string,apps_install int, games_instal int, all_s2_apps int, sns_apps int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION '/app/startpage/s2/applist/';

s2
CREATE TABLE s2 AS
SELECT c.col_udid,
       uids,
       model,
       launched_days,
       launch_times,
       search_count,
       apps_down AS apps_download,
       c.clicks,
       comments,
       uninstalls,
       video_consum,
       wallpaper_consum,
       video_consum_all,
       ebook_consum,
       ebook_consum_all,
       `_c1` AS loc,
       apps_install,
       games_instal AS games_install,
       all_s2_apps,
       sns_apps
FROM clicks c
LEFT OUTER JOIN consums ON consums.col_udid = c.col_udid
LEFT OUTER JOIN udid_ip ON udid_ip.col_udid = c.col_udid
LEFT OUTER JOIN launch_times l ON l.col_udid = c.col_udid
LEFT OUTER JOIN applist_info ON applist_info.col_udid = c.col_udid