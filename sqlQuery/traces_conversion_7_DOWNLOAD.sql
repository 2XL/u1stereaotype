



---------------------
-- RE size fix
---------------------

insert into traces_sintetic_re
select t, ext, logfile_id, node_id, "DOWNLOAD" as req_t, sid, tstamp, type, user_id, size
from traces_2w_3k
where t = "storage_done"
and req_t = "GetContentResponse"
-- and type != ""