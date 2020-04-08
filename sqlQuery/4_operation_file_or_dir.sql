4)_operation_file_or_dir


ratio de operaciones a ficheros y directorios









-- sintetic traces
select * from traces_2w.traces_2w_3k_master where node_id is not null

-- feed type and ext 
select * from u1fitting.file_size_maxmin_ext_category 




drop table if exists traces_2w_3k_master_full;
create table traces_2w_3k_master_full like traces_2w_3k_master; 

insert into traces_2w_3k_master_full
select tm.profile, tm.priority, tm.t, fc.ext, tm.node_id, tm.sid, tm.tstamp, fc.category, tm.user_id, tm.size from 
traces_2w.traces_2w_3k_master tm 
inner join 
u1fitting.file_size_maxmin_ext_category fc 
on 
tm.node_id = fc.node_id
 
  






select * 
from traces_2w.traces_2w_3k_master 
where node_id in ( select node_id from user_folders_node_id   )
  group by req_t
  



select file_ops.profile, file_ops.ops file_ops, dir_ops.ops dir_ops, dir_ops.ops / file_ops.ops rate from

(select profile, count(*) ops
from traces_2w_3k_master
where 
req_t in ("DELETE", "UPLOAD", "SYNC", "DOWNLOAD", "MOVE") and 
node_id not in (select node_id from u1fitting.user_folders_node_id)

group by profile) as file_ops

inner join

(select profile, count(*) ops
from traces_2w_3k_master
where 
req_t in ("DELETE", "UPLOAD", "SYNC", "DOWNLOAD", "MOVE") and 
node_id in (select node_id from u1fitting.user_folders_node_id)
group by profile) as dir_ops

on file_ops.profile = dir_ops.profile

order by profile







select file_ops.req_t, file_ops.ops file_ops, dir_ops.ops dir_ops, dir_ops.ops / file_ops.ops rate from

(select req_t, count(*) ops
from traces_2w_3k_master
where 
req_t in ("DELETE", "UPLOAD", "SYNC", "DOWNLOAD", "MOVE") and 
node_id not in (select node_id from u1fitting.user_folders_node_id)

group by req_t) as file_ops

inner join

(select req_t, count(*) ops
from traces_2w_3k_master
where 
req_t in ("DELETE", "UPLOAD", "SYNC", "DOWNLOAD", "MOVE") and 
node_id in (select node_id from u1fitting.user_folders_node_id)
group by req_t) as dir_ops

on file_ops.req_t = dir_ops.req_t

order by req_t