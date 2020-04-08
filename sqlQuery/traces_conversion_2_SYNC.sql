



/*
create table traces_2w_3k_tmp_sync_birank(
  --t string,
  -- ext string,
  -- logfile_id string,
  node_id bigint,
  -- req_t string,
  sid string,
  tstamp_ini timestamp,
  tstamp_fin timestamp,
  type string,
  user_id bigint,
  size_ini bigint,
  size_fin bigint
  ) stored as parquet;

create table traces_sintetic(
t string,
ext string,
logfile_id string,
node_id bigint,
req_t string,
sid string,
tstamp timestamp,
type string,
user_id bigint,
size bigint,
diff double
) stored as parquet;
*/


-- select * from traces_sintetic

insert into traces_sintetic
select 'storage_done' as t, "" as ext, "" as logfile_id, node_id, "SYNC" as req_t, sid, tstamp_fin, type, user_id, size_fin as size -- , size_fin/size_ini as size_diff
from traces_2w_3k_tmp_sync_birank
where (size_fin/size_ini) > 0 




 select req_t, count(*) from traces_sintetic
group by req_t

-- UPLOAD   16.335.931
-- SYNC 	 1.608.768



---------------------
-- RE size fix
---------------------

insert into traces_sintetic_re
select 'storage_done' as t, "" as ext, "" as logfile_id, node_id, "SYNC" as req_t, sid, tstamp_fin, type, user_id, size_fin as size -- , size_fin/size_ini as size_diff
from traces_2w_3k_tmp_sync_birank
where (size_fin-size_ini) != 0;
