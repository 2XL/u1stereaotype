

 select req_t, count(*) from traces_sintetic
group by req_t;



insert into traces_sintetic
select t, ext, logfile_id, node_id, "MOVE" as req_t, sid, tstamp, type, user_id, size
from traces_2w_3k
where t = "storage_done"
and req_t = "MoveResponse";



 select req_t, count(*) from traces_sintetic
group by req_t;


 	req_t	count(*)
3	START	85356
5	IDLE	98625
2	OFFLINE	183981
1	MOVE	1329942
4	SYNC	1608768
0	UPLOAD	16335931


---------------------
-- RE size fix
---------------------
insert into traces_sintetic_re
select t, ext, logfile_id, node_id, "MOVE" as req_t, sid, tstamp, type, user_id, size
from traces_2w_3k
where t = "storage_done"
and req_t = "MoveResponse";
