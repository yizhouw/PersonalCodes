/*create table for influencer guide*/
drop table p_social_influencer_t.influencer_guides;
create table p_social_influencer_t.influencer_guides as 
(
select uc_id as guide_id,
uc_titl as guide_title,
user_name
from p_social_influencer_t.influencer_session
where 1=1
and guide_id is not NULL
group by 1,2,3
)WITH DATA
PRIMARY INDEX(guide_id)