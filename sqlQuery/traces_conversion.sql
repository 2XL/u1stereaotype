




# 1 filtrar todas las trazas con user id que hay en cada una de as tres categorias de usuarios
# 



# 

drop table if exists traces_2w_3k;

create table traces_2w_3k(
t string,
ext string,
logfile_id string,
node_id bigint,
req_t string,
sid string,
tstamp timestamp,
type string,
user_id bigint,
size bigint
) stored as parquet;


insert into traces_2w_3k
select t, ext, logfile_id, node_id, req_t, sid, tstamp, type, user_id, size from default.ubuntu_one
where user_id in 
(select distinct user_id from u1fitting.user_2w_stereo)
and tstamp < adddate("2014-01-11 06:25:30.752000000", 14);

show table stats traces_2w_3k;
-- 148.476.212
-- 2GB como parquet !



-- trazas de las dos primeras semanas solamente de los usuarios que necesitamos
-- 


drop table if exists traces_sintetic;
create table traces_sintetic like traces_2w_3k;


drop table if exists traces_2w_3k_tmp_upload;
create table traces_2w_3k_tmp_upload like traces_2w_3k;

	insert into traces_2w_3k_tmp_upload
	select * from traces_2w_3k
	where req_t in ("PutContentResponse")
    and node_id is not null;

    show table stats traces_2w_3k_tmp_upload;




-- vamos a rankear los

drop table if exists traces_2w_3k_tmp_upload_rank;

create table traces_2w_3k_tmp_upload_rank(
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
rank bigint
) stored as parquet;
 
 insert into traces_2w_3k_tmp_upload_rank
select *, dense_rank() over (partition by node_id order by tstamp, logfile_id) as rank from traces_2w_3k_tmp_upload;


show table stats traces_2w_3k_tmp_upload_rank;




/*
select * from traces_2w_3k_tmp_upload_rank
where req_t = "MakeResponse"
and rank > 1	
*/




select node_id, count(*) hit from  traces_2w_3k_tmp_upload_rank
where rank = 1
group by node_id
having hit > 1



-- como filtrar por trazas unicas?

drop table if exists traces_2w_3k_tmp_upload_rank_unique;
create table  traces_2w_3k_tmp_upload_rank_unique like traces_2w_3k_tmp_upload_rank;

insert into traces_2w_3k_tmp_upload_rank_unique
select t,ext,logfile_id,node_id, req_t,sid,tstamp,type,user_id,size,rank
from traces_2w_3k_tmp_upload_rank
group by t,ext,logfile_id,node_id, req_t,sid,tstamp,type,user_id,size,rank;




show table stats traces_2w_3k_tmp_upload_rank_unique;

950MB

select count(*) from traces_2w_3k_tmp_upload_rank_unique;
-- 34674420

select count(*) from traces_2w_3k_tmp_upload_rank;
-- 34684624


-- con esta tabla [UPLOAD]



-----------------------
-----------------------
-----------------------





-- teniendo los unique puts
-- ahora se tiene que emparejar los ranking y obtener el diff entre puts para considerar los syncs...



drop table if exists traces_2w_3k_tmp_sync_birank; 
 
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




insert into traces_2w_3k_tmp_sync_birank
select 
-- a.t, 
-- a.ext, 
-- b.logfile_id, 
a.node_id, 
-- "SYNC" as req_t, 
b.sid, 
a.tstamp, 
b.tstamp, 
b.type, 
b.user_id, 
a.size, 
b.size
from traces_2w_3k_tmp_upload_rank_unique a inner join traces_2w_3k_tmp_upload_rank_unique b on (a.node_id = b.node_id and a.rank = b.rank - 1);




show table stats traces_2w_3k_tmp_sync_birank;


--- [SYNC]



------------
------------
------------
------------
------------
------------
------------






-- cojer todas las trazas de 



select sid, min(tstamp), max(tstamp), count(*) from traces_2w_3k
group by sid

-- como averiguar si una sesion es activa o passiva?


-- activa si existe operación

-- MakeResponse
-- PutContentResponse
-- GetContentResponse
-- MoveResponse
-- Unlink






-- 1r filtrar trazas activas es decir obtener una lista de sid + logfile_id que tengan alguna operacion de los anteriores durante toda la session
-- en caso contrario se les considera sessiones IDLE
-- por ultimo estan los 



drop table if exists traces_2w_3k_tmp_session;

create table traces_2w_3k_tmp_session like traces_2w_3k;


insert into traces_2w_3k_tmp_session
	select * from traces_2w_3k
	where t = "storage_done" and req_t in ("MakeResponse", "PutContentResponse", "GetContentResponse", "Unlink", "MoveResponse")





-- active sid


-- todos los sid que aparecen en la tabla anterior

drop table if exists traces_2w_3k_tmp_session_active;
create table traces_2w_3k_tmp_session_active(
sid string,
user_id bigint
) stored as parquet;

insert into traces_2w_3k_tmp_session_active
select sid, user_id 
from traces_2w_3k_tmp_session
group by sid,  user_id


/*

-- comprovación de que no se repite sid + logfile_id entre ususarios
select sid, logfile_id, count(*) hit
from (


select sid, logfile_id, user_id, count(*) operations 
from traces_2w_3k_tmp_session_active
group by sid, logfile_id, user_id

-- recuento de numero de operaciones por session

  ) as t
  group by sid, logfile_id
  order by hit desc


*/


-- traces_2w_3k_tmp_session_active => contiene los session ids activos

-- para saber los session ids no activos simplemente hay que seleccionar todos excepto los que este en esta tabla


 



drop table if exists traces_2w_3k_tmp_session_idle;
create table traces_2w_3k_tmp_session_idle(
sid string,
-- logfile_id string,
user_id bigint
) stored as parquet;




insert into traces_2w_3k_tmp_session_idle
select sid, user_id 
from traces_2w_3k
where sid != "" and sid not in (select sid from traces_2w_3k_tmp_session_active)
group by sid, user_id





select count(distinct sid) from traces_2w_3k;
-- 183982
-- 148476212

select count(sid) from traces_2w_3k_tmp_session_active;
--  89412 # ACTIVE
-- 85356
select count(sid) from traces_2w_3k_tmp_session_idle;
-- 104563 # NOOP (idle) - da menos porque hay trazas de sessinones que no tienen SID...
-- 98625





/*
select sid, logfile_id, count(distinct user_id) hit from traces_2w_3k
where sid != ""
group by sid, logfile_id
order by hit desc


-- session id is unique among server and users!!!
*/


drop table if exists traces_2w_3k_tmp_session_interval;
create table traces_2w_3k_tmp_session_interval(
sid string,
user_id bigint,
 tstamp_ini timestamp,
tstamp_fin timestamp
) stored as parquet;


insert into traces_2w_3k_tmp_session_interval
select sid, user_id, min(tstamp), max(tstamp) from traces_2w_3k
where sid != ""
group by sid, user_id;

show table stats traces_2w_3k_tmp_session_interval;


-- todas sessiones y sus intervals

select * from traces_2w_3k_tmp_session_interval;





select sid, tstamp_ini, tstamp_fin, unix_timestamp(tstamp_fin) - unix_timestamp(tstamp_ini) as elapsed from traces_2w_3k_tmp_session_interval order by elapsed desc;




# how to retrieve active sid?


select count(*)
from traces_2w_3k
where t = "storage_done"
and req_t = "GetContentResponse";
8188358 Unlink
6201930 GetContentResponse
1329942 MoveResponse

85356 start
98625 idle
start+idle = OFFLINE =  98625 
                        85356
                       183981 

  req_t count(*)
0 DELETE    8188358
3 DOWNLOAD  6201930
1 UPLOAD    16335931 => 1st put
2 MOVE      1329942
4 START     85356
5 OFFLINE   183981
6 IDLE      98625
7 SYNC      1608768 => successive puts with delta greater than zero.