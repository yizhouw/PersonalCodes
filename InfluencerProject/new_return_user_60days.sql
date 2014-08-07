select x.*,
y.user_id
from
(
select f.session_start_dt,
f.user_id,
f.roken2,
'return' as new_return
from
(
select a.session_start_dt,
a.user_id,
case
    when user_name_base64 like '%!%%' escape '!'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'%'))
    when user_name_base64 like '%?%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'?'))
    when user_name_base64 like '%&%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'&'))
else user_name_base64
end as roken2,
max(c.last_date) as last_time
from
(
select session_start_dt,
coalesce(mapped_user_id,signedin_user_id) as user_id,
case 
    when SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, 'roken2=')) like any ('%=ta.%','%=ti.%')
    then trim(trailing '	' from sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, 'roken2=')), 'p', '.'))
    else 'NA'
    end as user_name_base64
from p_seo_meas_v.free_traffic_session
where 1=1
and soj_lndg_page_url like '%roken2%'
and (signedin_user_id is not NULL or mapped_user_id is not NULL)
and session_start_dt between '2014-03-01' and current_date
) a
join (
select 
max(session_start_dt) as last_date,
coalesce(signedin_user_id,mapped_user_id) as user_id
from
P_SOJ_CL_V.CLAV_SESSION
where 1=1
and session_start_dt >= '2014-01-01'
and user_id is not null
and site_id in (0,100,3,15,77)
and valid_page_count >0
and bot_session = 0
group by Month(session_start_dt),2
) c
on a.user_id = c.user_id and a.session_start_dt > c.last_date
group by 1,2,3
) f
where 1=1
and f.session_start_dt >= f.last_time+60

UNION ALL

select a.session_start_dt,
a.user_id,
--b.user_cre_date,
case
    when user_name_base64 like '%!%%' escape '!'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'%'))
    when user_name_base64 like '%?%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'?'))
    when user_name_base64 like '%&%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'&'))
else user_name_base64
end as roken2,
'new' as new_return
from
(
select session_start_dt,
start_time,
coalesce(mapped_user_id,signedin_user_id) as user_id,
case 
    when SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, 'roken2=')) like any ('%=ta.%','%=ti.%')
    then trim(trailing '	' from sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, 'roken2=')), 'p', '.'))
    else 'NA'
    end as user_name_base64
from p_seo_meas_v.free_traffic_session
where 1=1
and soj_lndg_page_url like '%roken2%'
and (signedin_user_id is not NULL or mapped_user_id is not NULL)
and session_start_dt between '2014-01-01' and current_date
) a
join dw_users b
on a.user_id = b.user_id
where a.session_start_dt = b.USER_CRE_DATE
and a.start_time  < b.USER_CRE_DATE
) x
join p_social_influencer_t.influencer_list y
on x.roken2 = y.roken2_tag
