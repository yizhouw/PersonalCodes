select distinct a.pin_id
from p_social_influencer_t.influencer_session a
left outer join p_social_influencer_t.pinterest_pin b
on a.pin_id = b.pin_id
where 1=1
and b.pin_id is null
and a.pin_id not like '%?%'
and CHAR_LENGTH(a.pin_id) > 2
order by 1