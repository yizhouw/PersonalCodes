select a. session_start_dt,
a.influencer_flag,
b.guide_id,
b.guide_title,
b.user_name
from
(select  session_start_dt,
soj_lndg_page_url,
case 
	when sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '-/')), '/', '/') like '%gds%' then 0
	else cast(sojlib.soj_str_between(SUBSTR(soj_lndg_page_url, INDEX(soj_lndg_page_url, '-/')), '/', '/') as numeric(38,0)) 
	end as guide_id,
case
	when soj_lndg_page_url like '%roken2=%' then 'Y'
	else 'N'
end as influencer_flag
from p_seo_meas_v.free_traffic_session
where 1=1
and page_type = 'New Guides'
and soj_lndg_page_url like '%/gds/%'
and session_start_dt >= '2014-03-01'
) a
join 
p_social_influencer_t.influencer_guides b
on a.guide_id = b.guide_id
order by 1