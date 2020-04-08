

tengo 
=> todas las tracas de estos usuarios ==> traces_2w_3k
=> identificado cuales son las sessiones activas ==> traces_2w_3k_tmp_session_active
=> identificado cuales son las sessiones sin operaiones ==> traces_2w_3k_tmp_session_idle


# inyectar todas las sessiones idle
# al empezar sid de la session idle

=> tabla termporal con sid y su tiempo de inicio + fin ==> traces_2w_3k_session_interval




quiero todas las sessiones idle => es decir los que sean session idle
y inyectar su tstamp de inicio en "traces_sintetic" con req_t = "IDLE"




select * from traces_2w_3k_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_idle)
and sid != ""



 
/*
tstamp_ini => idle

-- trazas idle
t = "storage_done", ext = "", logfile_id = "", node_id = "", req_t = "IDLE", sid , tstamp = "tstamp_ini", type="", user_id ="", size = ""





*/

insert into traces_sintetic
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "IDLE" as req_t, sid, tstamp_ini, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_idle)
and sid != ""
) as t

 


/*
tstamp_fin => offline



*/


insert into traces_sintetic
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "OFFLINE" as req_t, sid, tstamp_fin, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_idle)
and sid != ""
) as t



---------------------
-- RE size fix
---------------------

/*
tstamp_ini => idle

-- trazas idle
t = "storage_done", ext = "", logfile_id = "", node_id = "", req_t = "IDLE", sid , tstamp = "tstamp_ini", type="", user_id ="", size = ""





*/

insert into traces_sintetic_re
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "IDLE" as req_t, sid, tstamp_ini, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_idle)
and sid != ""
) as t

 


/*
tstamp_fin => offline



*/


insert into traces_sintetic_re
select "storage_done" as t, "" as ext, "" as logfile_id, null as node_id, "OFFLINE" as req_t, sid, tstamp_fin, "" as type, user_id, null as size
from (
select * from traces_2w_3k_tmp_session_interval
where sid in (select sid from traces_2w_3k_tmp_session_idle)
and sid != ""
) as t
