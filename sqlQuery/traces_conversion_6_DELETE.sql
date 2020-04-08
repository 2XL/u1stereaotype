



 select req_t, count(*) from traces_sintetic
group by req_t;




insert into traces_sintetic
select t, ext, logfile_id, node_id, "DELETE" as req_t, sid, tstamp, type, user_id, size
from traces_2w_3k
where t = "storage_done"
and req_t = "Unlink";


---------------------
-- RE size fix
---------------------
insert into traces_sintetic_re
select t, ext, logfile_id, node_id, "DELETE" as req_t, sid, tstamp, type, user_id, size
from traces_2w_3k
where t = "storage_done"
and req_t = "Unlink";
