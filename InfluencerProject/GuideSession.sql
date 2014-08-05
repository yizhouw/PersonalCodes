/*Guides Session*/
drop table p_social_influencer_t.guide_session;
create table p_social_influencer_t.guide_session as (
select  p_seo_meas_v.free_traffic_session.*,
case 
	when sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '-/')), '/', '/') like '%gds%' then 0
	else cast(sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '-/')), '/', '/') as numeric(38,0)) 
	end as guide_id
from p_seo_meas_v.free_traffic_session
where 1=1
and page_type = 'New Guides'
and soj_lndg_page_url like '%/gds/%'
and session_start_dt >= '2014-03-01'
)WITH DATA
PRIMARY INDEX(guid,session_skey)