insert into traces_sintetic
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "START" as req_t, sid, tstamp_ini, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_active)
and sid != ""
) as t




/*
tstamp_fin => offline



*/


insert into traces_sintetic
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "OFFLINE" as req_t, sid, tstamp_fin, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_active)
and sid != ""
) as t





---------------------
-- RE size fix
---------------------



insert into traces_sintetic_re
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "START" as req_t, sid, tstamp_ini, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_active)
and sid != ""
) as t




/*
tstamp_fin => offline



*/


insert into traces_sintetic_re
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "OFFLINE" as req_t, sid, tstamp_fin, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_active)
and sid != ""
) as t



