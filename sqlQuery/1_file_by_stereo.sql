1) los ficheros que maneja cada estereotipo
	
	-- when operation is make
	-- node_id, user_id, ext



-- 


drop table if exists file_category_backup;
create table file_category_backup(
  category string,
  hit bigint) stored as parquet;

insert into file_category_backup
select category, count(*) hit from u1fitting.file_ext_category
where node_id in (select distinct node_id from traces_2w_1k_backup_log)
group by category;

show table stats file_category_backup

-- HEAVY :: replace by each stereo type


drop table if exists file_category_backup_heavy;
create table file_category_backup_heavy like file_category_backup;

insert into file_category_backup_heavy 
select category, count(*) hit from u1fitting.file_ext_category
where node_id in (
	select distinct node_id from traces_2w_1k_backup_log
    where user_id in (select user_id from traces_2w_1k_backup_heavy))
group by category;

show table stats file_category_backup_heavy;

-- OCASIONAL


drop table if exists file_category_backup_occasional;
create table file_category_backup_occasional like file_category_backup;

insert into file_category_backup_occasional 
select category, count(*) hit from u1fitting.file_ext_category
where node_id in (
	select distinct node_id from traces_2w_1k_backup_log
    where user_id in (select user_id from traces_2w_1k_backup_occasional))
group by category;

show table stats file_category_backup_occasional;

-- 

/*

drop table if exists file_category_sync;
create table file_category_sync(
  category string,
  hit bigint) stored as parquet;

insert into file_category_sync
select category, count(*) hit from u1fitting.file_ext_category
where node_id in (select distinct node_id from traces_2w_1k_sync_log)
group by category;

show table stats file_category_sync


-- 

drop table if exists file_category_download;
create table file_category_download(
  category string,
  hit bigint) stored as parquet;

insert into file_category_download
select category, count(*) hit from u1fitting.file_ext_category
where node_id in (select distinct node_id from traces_2w_1k_download_log)
group by category;

show table stats file_category_download

*/



select * from file_category_backup
order by category;


select * from file_category_backup_heavy
order by category;


select * from file_category_backup_occasional
order by category;
