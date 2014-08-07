/*BBOWA Information for SEO and Social*/
select bbowa_session_start_dt,
  case 
  	when bbowa_site_id in (0,100) then 'US'
	when bbowa_site_id = 2 then 'CA'
	when bbowa_site_id = 3 then 'UK'
	when bbowa_site_id = 15 then 'AU'
	when bbowa_site_id = 71 then 'FR'
	when bbowa_site_id = 77 then 'DE'
	when bbowa_site_id = 101 then 'IT'
	when bbowa_site_id = 186 then 'ES'
	when bbowa_site_id = 201 then 'HK'
	else 'Others'
	end as site_country,
case 
	when bbowa_traffic_source_id in (20,21) then 'SEO'
	when bbowa_traffic_source_id in (22,23) then 'Social'
	else 'Others'
	end as traffic_source,
count(*) as transaction_count,
(SUM(CAST(CASE WHEN bbowa_site_id in (0,100,2,3,15,71,77,101,186,201) THEN CAST(item_price * quantity * lstg_curncy_exchng_rate AS DECIMAL(18,2)) ELSE 0.0 END AS DECIMAL(18,2)))/1000000) AS us_gmb_usd_million
from P_SOJ_CL_V.CHECKOUT_METRIC_ITEM
where 1=1
and bbowa_session_start_dt between '2011-01-01' and ADD_MONTHS(current_date - EXTRACT(DAY FROM current_date)+1, 0)-1
and bbowa_site_id in (0,100,2,3,15,71,77,101,186,201)
--and bbowa_traffic_source_id in (20,21,22,23)
group by 1,2,3