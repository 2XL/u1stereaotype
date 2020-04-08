traces_sinteitc_profile.sql

drop table if exists traces_sintetic_profile;
create table traces_sintetic_profile(
profile string,
-- t string,
ext string,
-- logfile_id string,
node_id bigint,
req_t string,
sid string,
tstamp timestamp,
type string,
user_id bigint,
size bigint -- ,
-- size_diff double
) stored as parquet;



insert into traces_sintetic_profile
select 'backup_20_heavy', ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_sintetic.traces_sintetic 
where user_id in (select distinct user_id from u1fitting.fit_1k_2w_backup_20_heavy);


insert into traces_sintetic_profile
select 'sync_20_heavy', ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_sintetic.traces_sintetic 
where user_id in (select distinct user_id from u1fitting.fit_1k_2w_sync_20_heavy);


insert into traces_sintetic_profile
select 'download_20_heavy', ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_sintetic.traces_sintetic 
where user_id in (select distinct user_id from u1fitting.fit_1k_2w_download_20_heavy);


insert into traces_sintetic_profile
select 'backup_80_ocasional', ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_sintetic.traces_sintetic 
where user_id in (select distinct user_id from u1fitting.fit_1k_2w_backup_80_ocasional);


insert into traces_sintetic_profile
select 'sync_80_ocasional', ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_sintetic.traces_sintetic 
where user_id in (select distinct user_id from u1fitting.fit_1k_2w_sync_80_ocasional);

 

insert into traces_sintetic_profile
select 'download_80_ocasional', ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_sintetic.traces_sintetic 
where user_id in (select distinct user_id from u1fitting.fit_1k_2w_download_80_ocasional);


show table stats traces_sintetic_profile;


-- stereo_profile_re



