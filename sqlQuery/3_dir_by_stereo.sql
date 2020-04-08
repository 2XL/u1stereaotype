3) númreo de directorios por estereotypo
	
	-- user_id, count( node_id)
		where type = "Directory"



/*
drop table if exists user_folders_activities_2w;

create table user_folders_activities_2w(
node_id bigint,
user_id bigint,
tstamp timestamp,
req_t string,
t string
) stored as parquet;


insert into user_folders_activities_2w
select node_id, user_id, tstamp, req_t, t from default.ubuntu_one 
where node_id in (select * from user_folders_node_id);
and tstamp < adddate("2014-01-11 06:25:30.752000000", 14);
*/

--- 

drop table if exists user_folders_activities_2w_category;

create table user_folders_activities_2w_category
	(
		user_id bigint, 
		node_id bigint, 
		req_t string,  
		stereo string
	) stored as parquet;


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "backup_heavy" as stereo from u1fitting.user_folders_activities_2w
where user_id in (select  user_id from traces_2w_1k_backup_heavy);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "sync_heavy" as stereo from u1fitting.user_folders_activities_2w
where user_id in (select  user_id from traces_2w_1k_sync_heavy);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "download_heavy" as stereo from u1fitting.user_folders_activities_2w
where user_id in (select  user_id from traces_2w_1k_download_heavy);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "backup_ocasional" as stereo from u1fitting.user_folders_activities_2w
where user_id in (select  user_id from traces_2w_1k_backup_occasional);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "sync_ocasional" as stereo from u1fitting.user_folders_activities_2w
where user_id in (select  user_id from traces_2w_1k_sync_occasional);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "download_ocasional" as stereo from u1fitting.user_folders_activities_2w
where user_id in (select  user_id from traces_2w_1k_download_occasional);
 
 show table stats user_folders_activities_2w_category;



---





select count(distinct node_id) 
from user_folders_activities_2w_category 
where stereo = "download_heavy";


select count(distinct node_id) 
from user_folders_activities_2w_category 
where stereo = "download_occasional";

select count(distinct node_id) 
from user_folders_activities_2w_category 
where stereo = "sync_heavy";

select count(distinct node_id) 
from user_folders_activities_2w_category 
where stereo = "sync_heavy";

select count(distinct node_id) 
from user_folders_activities_2w_category 
where stereo = "backup_heavy";

select count(distinct node_id) 
from user_folders_activities_2w_category 
where stereo = "backup_heavy";



