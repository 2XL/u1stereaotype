



--


crear tabla de trazas de las dos primeras semanas de cada stereotipo



/*
select * from default.ubuntu_one 
where tstamp < adddate("2014-01-11 06:25:30.752000000", 14)
and user_id in (select distinct user_id from select fit_1k_);
*/

--> fit_1k_2w_XXXX_XX_XXX

drop table if exists user_op_filetype;

create table user_op_filetype(
 streo string, 
 req_t string, 
 hit bigint, 
 is_folder boolean
) stored as parquet;



insert into user_op_filetype
select 'backup_heavy', req_t, count(*) as hit , True from fit_1k_2w_backup_20_heavy 
where node_id in (select distinct node_id from user_folders_2w)
group by req_t;

-- ops
insert into user_op_filetype
select 'backup_heavy', req_t, count(*) as hit, False from fit_1k_2w_backup_20_heavy 
where node_id not in (select distinct node_id from user_folders_2w)
group by req_t;

-------------------------------------------

insert into user_op_filetype
select 'sync_heavy', req_t, count(*) as hit , True from fit_1k_2w_sync_20_heavy 
where node_id in (select distinct node_id from user_folders_2w)
group by req_t;

-- ops
insert into user_op_filetype
select 'sync_heavy', req_t, count(*) as hit, False from fit_1k_2w_sync_20_heavy 
where node_id not in (select distinct node_id from user_folders_2w)
group by req_t;
----------------------------------------------


insert into user_op_filetype
select 'download_heavy', req_t, count(*) as hit , True from fit_1k_2w_download_20_heavy 
where node_id in (select distinct node_id from user_folders_2w)
group by req_t;

-- ops
insert into user_op_filetype
select 'download_heavy', req_t, count(*) as hit, False from fit_1k_2w_download_20_heavy 
where node_id not in (select distinct node_id from user_folders_2w)
group by req_t;


----------------------------------------------------------------
----------------------------------------------------------------
 


insert into user_op_filetype
select 'backup_ocasional', req_t, count(*) as hit , True from fit_1k_2w_backup_80_ocasional
where node_id in (select distinct node_id from user_folders_2w)
group by req_t;

-- ops
insert into user_op_filetype
select 'backup_ocasional', req_t, count(*) as hit, False from fit_1k_2w_backup_80_ocasional
where node_id not in (select distinct node_id from user_folders_2w)
group by req_t;

-------------------------------------------

insert into user_op_filetype
select 'sync_ocasional', req_t, count(*) as hit , True from fit_1k_2w_sync_80_ocasional
where node_id in (select distinct node_id from user_folders_2w)
group by req_t;

-- ops
insert into user_op_filetype
select 'sync_ocasional', req_t, count(*) as hit, False from fit_1k_2w_sync_80_ocasional
where node_id not in (select distinct node_id from user_folders_2w)
group by req_t;
----------------------------------------------


insert into user_op_filetype
select 'download_ocasional', req_t, count(*) as hit , True from fit_1k_2w_download_80_ocasional
where node_id in (select distinct node_id from user_folders_2w)
group by req_t;

-- ops
insert into user_op_filetype
select 'download_ocasional', req_t, count(*) as hit, False from fit_1k_2w_download_80_ocasional
where node_id not in (select distinct node_id from user_folders_2w)
group by req_t;


----------------------------------------------------------------
----------------------------------------------------------------
 