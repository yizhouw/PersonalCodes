/*
Social Pinterest Session Information
*/
drop table P_SOCIAL_INFLUENCER_T.Influencer_session;
Create Table P_SOCIAL_INFLUENCER_T.Influencer_session as (
select 
a.guid,
a.session_skey,
a.session_start_dt,
a.site_country,
a.ref_domain,
case
case
    when user_name_base64 like '%!%%' escape '!'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'%'))
    when user_name_base64 like '%?%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'?'))
    when user_name_base64 like '%&%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'&'))
else user_name_base64
end as roken2,
NVL(f.user_id,'NA') as user_name,
--a.board_name,
a.page_type,
a.session_referrer,
a.soj_lndg_page_url,
a.pin_id,
a.duration,
a.valid_page_count,
a.device_type_txt,
a.past_7_days,
dw_uc.uc_titl,
dw_uc.uc_id,
dw_users.user_slctd_id as guide_owner,
b.clicks,
c.shares
from
(
select
session_start_dt,
guid,
session_skey,
case 
    when site_id in (0,100) then 'US'
    when site_id = 77 then 'DE'
    when site_id = 15 then 'AU'
    when site_id = 3 then 'UK'
    else 'Others'
    end as site_country,
ref_domain,
case 
    when SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, 'roken2=')) like any ('%=ta.%','%=ti.%')
    then trim(trailing '	' from sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, 'roken2=')), 'p', '.'))
    else 'NA'
    end as user_name_base64,
/*case 
    when user_name_base64 like any ('%QXJ0ZW1pc2EgU2F1Y2Vkbw==%') then 'hammeraclassic'
    when user_name_base64 like any ('%TWFyaWFuIFBhcnNvbnM=%') then 'highsnobietymag'
    when user_name_base64 like any ('%R2FiaSBHcmVnZw==%') then 'justina-blakeney'
    when user_name_base64 like any ('%QW5kcmVhcyBBbmRyZWFz%') then 'miss_mustard_seed'
    when user_name_base64 like any ('%S2FyaUFubmUgV29vZA==%') then 'thistlewood2013'
    when user_name_base64 like any ('%Q2hyaXN0aW5lIE1pa2VzZWxs%') then '15minutebeauty'
    when user_name_base64 like any ('%TWVsaXNzYSBXaWxs%','%ZW1wcmVzc29mZGlydA==%') then 'empressofdirtblog'
    when user_name_base64 like any ('%VGluYSBDcmFpZw==%') then 'snobessentials'
    when user_name_base64 like any ('%S2VsbHkgRnJhbWVs%') then 'kellyframel'
    when user_name_base64 like any ('%SnVzdGluYSBCbGFrZW5leQ==%') then 'gabi_fresh'
    when user_name_base64 like any ('%SmFtZXMgTWNCcmlkZQ==%') then 'james-silodrome'
    when user_name_base64 like any ('%SnVzdGluIExpdmluZ3N0b24=%') then 'living_style'
    when user_name_base64 like any ('%TGVlIE1hbGNoZXI=%','%3hwzkq71%') then 'carhoots'
    when user_name_base64 like any ('%SGVhdGhlciBDbGF3c29u%', '%aGFiaXR1YWxseWNoaWM=%') then 'HabituallyChic-us'
    when user_name_base64 like any ('%Q2Fzc2l0eSBLTWV0enNjaA==%') then 'remodelaholic'
    when user_name_base64 like any ('%TWVnYW4gQ29sbGlucw==%') then 'stylegirlfriend'
    when user_name_base64 like any ('%VHJhY2kgRnJlbmNo%') then 'blissblog-us'
    when user_name_base64 like any ('%TmF0YWxpZSBMaWFv%') then 'nalieliblog'
    when user_name_base64 like any ('%VHlsZXIgV2lzZXI=%') then 'TylerWislerHome'
    
    when user_name_base64 like any ('%QWlsZWVuIEFsbGVu%') then 'alle_ailee'
    when user_name_base64 like any ('%S2ltIERlbW1vbg==%') then 'Kim Demmon'
    when user_name_base64 like any ('%YmVhdXR5YmV0cw==%') then 'beautybets'

    when user_name_base64 like any ('%U2FtbXkgRGF2aXM=%') then 'SammyDavisVintage'
    when user_name_base64 like any ('%SmVubmlmZXIgQ2hvbmc=%') then 'jchongstudio'
    when user_name_base64 like any ('%TWFyYWphIEJhcm5h%') then 'mbmaki'
    when user_name_base64 like any ('%R3JhY2UgQm9ubmV5%') then 'Design*Sponge'
    when user_name_base64 like any ('%Q2Fyb2xpbmUgTXlzcw==%') then 'cmedcaroline'

    when user_name_base64 like any ('%SGF5bGV5IENvcndpY2s=%') then 'madisonavespy'
    when user_name_base64 like any ('%TmluYSBSdXNzaW4=%') then 'hninars13'
    when user_name_base64 like any ('%Q2hlcnlsIFNpbW1vbnM=%') then 'cherylds78'
    when user_name_base64 like any ('%QWltZWUgU2FudG9z%') then 'swellmayde'
    when user_name_base64 like any ('%Sm9hbm5hIEhhd2xleQ==%') then 'joanhawl'

    when user_name_base64 like any ('%P3t1c2VybmFtZX0=%') then 'Unknown'
    --when user_name_base64 like '%MjAxNHRvcHBpbnM=%' then '2014toppins'
    --when user_name_base64 like '%amluZzFjaGVuZWJheQ==%' then 'jing1chenebay'
    --when user_name_base64 like '%am9yZGFuZmVybmV5%' then 'jordanferney'
    --when user_name_base64 like '%bmxtbWFrZXVwbmlraQ==%' then 'nlmmakeupniki'
    when user_name_base64 like '%c2hvZWx1c3Q=%' then 'shoelust'
    else 'NA'
    end as user_name,*/
    
    
    
--sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '.b')), 'b', '') as board_name,
/*
case
    when sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '.b')), 'b', '?') like '%&%'
    then trim(sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '.b')), 'b', '&'))
    when sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '.b')), 'b', '&') like '%?%'
    then trim(sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '.b')), 'b', '?'))
    else trim(trailing '    ' from sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '.b')), 'b', '\t'))
    end as board_name,
    */
case
    when soj_lndg_page_url like all('%/gds/%','%roken2=%')
    then cast(sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '-/')), '/', '/') as numeric(38,0))
    else 0
    end as guide_id,
page_type,
((end_time - start_time) minute(4) to second) as session_length,
extract(minute from session_length)* 60 + extract(second from session_length) as duration,
--cast(end_time as timestamp) - cast(start_time as timestamp) as session_time,
valid_page_count,
device_type_txt,
soj_lndg_page_url,
session_referrer,

case 
    when session_referrer like '%pinterest.com/pin/%' then sojlib.soj_str_between(SUBSTR(session_referrer, INDEX(session_referrer, 'pin/')), '/', '/')
    else NULL
end as pin_id,

case 
    when session_start_dt between current_date - 8 and current_date-1
    then 'Y'
    else 'N'
end as past_7_days

from P_SEO_MEAS_V.FREE_TRAFFIC_SESSION
where 1=1
--and ref_domain = 'pinterest'
--AND site_id IN ( 0 ,100 ) 
AND session_start_dt BETWEEN '2014-03-01' AND CURRENT_DATE-1
 AND soj_lndg_page_url LIKE '%roken2=%' 
 AND traffic_source_id IN (22,23 ) 
 AND cobrand IN (0,6,7)
 ) a
 left outer join 
 dw_uc on a.guide_id = dw_uc.uc_id
left outer  join
 (select
guid,
session_skey,
count(*) as clicks
from p_free_social_v.all_soc_clicks
where 1=1
and URL_QUERY_STRING like '%roken2=%'
and session_start_dt between '2014-03-01' and  CURRENT_DATE-1
group by 1,2
) b
on a.guid = b.guid
and a.session_skey = b.session_skey
left outer join 
(
select 
guid,
session_skey,
count(*) as shares
from p_seo_meas_t.social_share_clicks
where 1 =1 
and url_txt like '%roken2=%'
group by 1,2
) c
on a.guid = c.guid
and a.session_skey = c.session_skey
left outer join dw_users
on dw_uc.user_id = dw_users.user_id
left outer join p_social_influencer_t.influencer_list f
on roken2 = f.roken2_tag
)WITH DATA
PRIMARY INDEX(guid,session_skey)
--ON COMMIT PRESERVE ROWS;