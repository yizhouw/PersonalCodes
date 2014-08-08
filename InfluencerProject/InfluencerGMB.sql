/*
Social Pinterest Session Information
*/
drop table P_SOCIAL_INFLUENCER_T.Influencer_gmb;
Create Table P_SOCIAL_INFLUENCER_T.Influencer_gmb as (
/* pinterest conversion */
select a.bbowa_session_skey,
a.bbowa_guid,
a.bbowa_session_start_dt,
a.rfr_src,
a.site_country,
a.iGMB,
a.new_return_buyer,
case
    when user_name_base64 like '%!%%' escape '!'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'%'))
    when user_name_base64 like '%?%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'?'))
    when user_name_base64 like '%&%'
    then SUBSTR(user_name_base64,0,index(user_name_base64,'&'))
else user_name_base64
end as roken2,
NVL(b.user_id,'NA') as user_name
 from 
(select
bbowa_session_skey,
bbowa_guid,
bbowa_session_start_dt,
rfr_src,
case 
	when bbowa_site_id in (0,100) then 'US'
	when bbowa_site_id = 77 then 'DE'
	when bbowa_site_id = 15 then 'AU'
	when bbowa_site_id = 3 then 'UK'
	else 'Others'
	end as site_country,
(gmb_usd+cav) as iGMB,
case 
	when SUBSTR(olp_lndng_url, INDEX(olp_lndng_url, 'roken2=')) like any ( '%=ta.%','%=ti.%') 
	then trim(trailing '	' from sojlib.soj_str_between(SUBSTR(olp_lndng_url, INDEX(olp_lndng_url, 'roken2=')), 'p', '.'))
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
	when sojlib.soj_str_between(SUBSTR(olp_lndng_url, INDEX(olp_lndng_url, '.b')), 'b', '?') like '%&%'
	then trim(sojlib.soj_str_between(SUBSTR(olp_lndng_url, INDEX(olp_lndng_url, '.b')), 'b', '&'))
	when sojlib.soj_str_between(SUBSTR(olp_lndng_url, INDEX(olp_lndng_url, '.b')), 'b', '&') like '%?%'
	then trim(sojlib.soj_str_between(SUBSTR(olp_lndng_url, INDEX(olp_lndng_url, '.b')), 'b', '?'))
	else trim(sojlib.soj_str_between(SUBSTR(olp_lndng_url, INDEX(olp_lndng_url, '.b')), 'b', '\t'))
	end as board_name,
	*/
olp_page_type,
--valid_page_count,
device_type_txt,
case 
    when buyer_type_cd in (0,1) then 1
    else 0
end as new_return_buyer
--soj_lndg_page_url
from P_SEO_MEAS_V.FREE_TRAFFIC_CNVRSN
where 1=1
--and ref_domain like '%pinterest%'
--AND site_id IN ( 0 ,100 ) 
AND bbowa_session_start_dt BETWEEN '2014-03-01' AND CURRENT_DATE -1 
 AND olp_lndng_url LIKE ANY ('%roken2=ta.%' ,'%roken2=ti.%')
 AND bbowa_traffic_source_id IN (22,23 ) 
 AND olp_cobrand IN (0,6,7)
 )a
left outer join p_social_influencer_t.influencer_list b 
on roken2 = b.roken2_tag
)WITH DATA
PRIMARY INDEX(bbowa_session_skey,bbowa_guid)
--ON COMMIT PRESERVE ROWS;