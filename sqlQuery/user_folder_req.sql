
crear tabla temporal user folder con req type



drop table if exists user_folders_req;


create table user_folders_req (
node_id bigint,
user_id bigint,
tstamp timestamp,
req_t string
) stored as parquet;


insert into user_folders_req
select node_id, user_id, tstamp, req_t from default.ubuntu_one 
where 
t = "storage_done" and
type = "Directory";


show table stats user_folders_req;




---


-- create user_folder_req_2w


drop table if exists user_folders_req_2w;
create table user_folders_req_2w like user_folders_req;

	insert into user_folders_req_2w
		select * from user_folders_req
			where tstamp < adddate("2014-01-11 06:25:30.752000000", 14);
 
show table stats user_folders_req_2w;




--





-- analizar folder traces:


-- create table unique node_id
-- related to folders



create table user_folders_node_id(
node_id bigint
) stored as parquet;

insert into user_folders_node_id
select distinct node_id from user_folders_2w;

show table stats user_folders_node_id;

-- tabla que contiene todos los node_id de carpetas

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






