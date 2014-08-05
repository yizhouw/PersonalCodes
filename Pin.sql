select a.*,
b.pinner,
c.pinterest_id as influencer_pinterest_id,
case 
	when pinner = influencer_pinterest_id then 'Original'
	else 'Repin'
end as Pin_Repin
from
(select
session_start_dt,
--session_referrer,
pin_id,
roken2,
user_name,
count(*) session_count
from p_social_influencer_t.influencer_session
where 1=1
and pin_id is not NULL
and user_name != 'NA'
and session_start_dt >= '2014-01-01'
group by 1,2,3,4) a
left outer join p_social_influencer_t.pinterest_pin b
on a.pin_id=b.pin_id
left outer join p_social_influencer_t.influencer_list c
on a.roken2 = c.roken2_tag
where 1=1