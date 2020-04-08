ubuntu_one_2w.sql


-- 
-- [TABLA TEMPORAL DE UBUNTU_ONE 2 SEMANAS]
--


drop table if exists traces_2w;

create table traces_2w(
t string, -- storage_done
ext string, -- svg, php, pdf
-- logfile_id string, -- 
node_id bigint, -- unique file id
req_t string, -- PutContentResponse
sid string, -- sessionidstring
tstamp timestamp, -- 
type string, -- file or folder
user_id bigint, -- unique user id
size bigint -- file size
) stored as parquet;



insert into traces_2w
select t, ext, node_id, req_t, sid, tstamp, type, user_id, size from default.ubuntu_one
where tstamp < adddate("2014-01-11 06:25:30.752000000", 14);


show table stats traces_2w;



--
-- [ TABLA TEMPORAL CONTADOR DE OPERACIÓNES POR USUARIO ]
--



-- crear una tabla para insertar los request de storage_done
/*

MakeContentReponse -- descartado

-- active seria algo de esto.

PutContentResponse --> 
GetContentResponse --> 
MoveResponse --> 
Unlink --> insert todos estos ordenados por ranking tstamp y 


*/


-- handle unlink operations


drop table if exists traces_2w_active;

create table traces_2w_active(
t string, -- storage_done
ext string, -- svg, php, pdf
-- logfile_id string, -- 
node_id bigint, -- unique file id
req_t string, -- PutContentResponse
sid string, -- sessionidstring
tstamp timestamp, -- 
type string, -- file or folder
user_id bigint, -- unique user id
size bigint -- file size
) stored as parquet;



-- [UNLINK]

/*

-- this handles timestamp colision

select  node_id, count(*) hit from 
(
select *, dense_rank() over (partition by node_id order by tstamp) as rank from traces_2w
where user_id = 2925188370
and t = "storage_done"
and req_t = "Unlink"
) as t
where rank = 1
group by node_id
order by hit desc
*/

-- this handles timestamp and session colision

create table traces_2w_active_unlink like traces_2w_active;
insert into traces_2w_active_unlink  
select t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from (select *, dense_rank() over(partition by node_id order by tstamp asc, sid) as rank from traces_2w
where req_t = "Unlink" and t = "storage_done" ) as t
where rank = 1




/*
SELECT node_id, count(*) hit FROM traces_2w_active
group by node_id 
order by hit desc
*/ 
-- comprovado que todos los node_id tienen un unico delete (tstamp asc : el primer delete)
-- cuando se duplica la operación implica que se ha vuelto a elimiar pero puede que sea otro volumen por lo tanto 
-- sea una operación valida



-- [PUT]
-- handle put operations


drop table if exists traces_2w_put;
create table traces_2w_put like traces_2w_active; 

insert into traces_2w_put
select * from traces_2w
where req_t = "PutContentResponse"
and t = "storage_done"

-- filter unique traces

drop table if exists traces_2w_put_unique;
create table traces_2w_put_unique like traces_2w_put;

insert into traces_2w_put_unique
select t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_put
group by t, ext, node_id, req_t, sid, tstamp, type, user_id, size;

show table stats traces_2w_put_unique;


/*
crear una tabla temporal con todos los puts
> traces_2w_put

de esta tabla vamos a extrear dos tipos de operaciones
SYNC && UPLOAD
*/


-- [RANK THE PUT REQUESTS]


drop table if exists traces_2w_put_rank;

create table traces_2w_put_rank(
t string, -- storage_done
ext string, -- svg, php, pdf
-- logfile_id string, -- 
node_id bigint, -- unique file id
req_t string, -- PutContentResponse
sid string, -- sessionidstring
tstamp timestamp, -- 
type string, -- file or folder
user_id bigint, -- unique user id
size bigint, -- file size
rank bigint
) stored as parquet;

 

insert into traces_2w_put_rank
select *, 
dense_rank() over (partition by node_id order by tstamp, sid) as rank 
from traces_2w_put_unique;
--  when there is a rank colision solve it with sid.


-- todo extract SYNC and UPLOAD





/*
select node_id, count(*) as hit
from
(
select t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_put_rank
where rank = 1
  ) as t
group by node_id
order by hit desc;

-- OKEY/FAIL

 hacer un filtro de request con mismo timestamp...

// despues de un partition by node_id, order by tstamp, sid
se ha logrado quitar todas las colisiones

*/

-- comprovar que haya make con mismo tstamp


-- extract UPLOAD



--

drop table if exists traces_2w_active_make;
create table traces_2w_active_make like traces_2w_active;

insert into traces_2w_active_make
select t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_put_rank
where rank = 1;

show table stats traces_2w_active_make;

/*
select node_id, count(*) hit from traces_2w_active_make
group by node_id order by hit desc

OK

*/
-- extract SYNC

-- implementar la tabla BIRANK


drop table if exists traces_2w_put_rank_pair; 
 
create table traces_2w_put_rank_pair(
  -- t string,
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


insert into traces_2w_put_rank_pair
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
from 
traces_2w_put_rank a inner join 
traces_2w_put_rank b on 
(a.node_id = b.node_id and a.rank = b.rank - 1);

show table stats traces_2w_put_rank_pair;




-- crear tabla temporal




drop table if exists traces_2w_active_sync;
create table traces_2w_active_sync like traces_2w_active;


insert into traces_2w_active_sync
select 'storage_done' as t, "" as ext,  node_id, "SYNC" as req_t, sid, tstamp_fin, type, user_id, size_fin as size -- , size_fin/size_ini as size_diff
from traces_2w_put_rank_pair
where (size_fin-size_ini) != 0;


show table stats traces_2w_active_sync; -- 159




-- handle get operations

drop table if exists traces_2w_active_get;
create table traces_2w_active_get like traces_2w_active;

insert into traces_2w_active_get
select * from traces_2w
where req_t = "GetContentResponse"
and t = "storage_done";


show table stats traces_2w_active_get;


-- handle move operations



drop table if exists traces_2w_active_move;
create table traces_2w_active_get like traces_2w_active;

insert into traces_2w_active_move
select * from traces_2w
where req_t = "MoveResponse"
and t = "storage_done";


show table stats traces_2w_active_move;



-- 
-- Juntar todas la tablas en una cambiando el nombre
--


drop table if exists traces_2w_active;
create table traces_2w_active like traces_2w;

insert into traces_2w_active
select 'storage_done' as t, ext, node_id, "UPLOAD" as req_t, sid, tstamp, type, user_id, size 
from traces_2w_active_make;


insert into traces_2w_active
select t, ext, node_id, "MOVE" as req_t, sid, tstamp, type, user_id, size 
from traces_2w_active_move;

insert into traces_2w_active
select t, ext, node_id, "DOWNLOAD" as req_t, sid, tstamp, type, user_id, size 
from traces_2w_active_get;

insert into traces_2w_active
select t, ext, node_id, "DELETE" as req_t, sid, tstamp, type, user_id, size 
from traces_2w_active_unlink;

insert into traces_2w_active
select t, ext, node_id, "SYNC" as req_t, sid, tstamp, type, user_id, size 
-- select * 
from traces_2w_active_sync;





select req_t, count(*) hit from traces_2w_active
group by req_t
order by hit desc

/*
0	UPLOAD	 45479364
1	DOWNLOAD 39147082
2	UNLINK	 27467192
3	SYNC	 5563463
4	MOVE	 4066455
*/
/*
UPLOAD  -> active make
MOVE    -> active move
DELETE  -> active unlink
DOWLOAD -> active get
SYNC    -> active sync
*/

-- estos se obtinen despues de analizar el grupo anterior

OFFLINE ->
START   ->
IDLE    ->

-- luego


crear tabla temporal para saber que tablas son activas y no activas






drop table if exists traces_2w_session_active;
create table traces_2w_session_active(
sid string,
user_id bigint
) stored as parquet;
insert into traces_2w_session_active
select sid, user_id from traces_2w_active
group by user_id, sid;

show table stats traces_2w_session_active;


-- having ops = 0 -- directamente no saldria porque no habrian resultados... lo que implica esto es que todo lo que hay aqui son sessiones activas
-- order by ops desc






drop table if exists traces_2w_session_idle;
create table traces_2w_session_idle(
sid string,
user_id bigint
) stored as parquet;
insert into traces_2w_session_idle
select sid, user_id from traces_2w
where sid not in (select sid from traces_2w_session_active)
group by user_id, sid;


show table stats traces_2w_session_idle;




--

-- monton de sessiones idle :D



select a.sid, a.user_id from 
traces_2w_session_idle i
inner join traces_2w_session_active a
on (i.sid= a.sid and i.user_id = a.user_id)


-- demuestra que no hay colision de sessiones



-- extraer el periodo de las sessiones

drop table if exists traces_2w_session_interval;
create table traces_2w_session_interval(
sid string,
user_id bigint,
tstamp_ini timestamp,
tstamp_fin timestamp
) stored as parquet;


insert into traces_2w_session_interval
select sid, user_id, min(tstamp), max(tstamp) from traces_2w
where sid != ""
group by sid, user_id;



show table stats traces_2w_session_interval;

-- com es transposava else resultats?

--------------------------------------------------------------------------------------------------------------------



drop table if exists traces_2w_user_id_all;
create table traces_2w_user_id_all(
user_id bigint
) stored as parquet;



insert into traces_2w_user_id_all
select distinct user_id from traces_2w;

select count(*) from traces_2w_user_id_all;
982710


select count(*) from (select distinct user_id from traces_2w_active) as t;
127634






drop table if exists traces_2w_ops;
create table traces_2w_ops(
  user_id bigint,
  ops bigint
  ) stored as parquet;

-- delete
drop table if exists traces_2w_ops_delete;
create table traces_2w_ops_delete like traces_2w_ops;
insert into traces_2w_ops_delete
select user_id, count(*) as ops from traces_2w_active
where req_t = "DELETE"
group by user_id, req_t;

-- get
drop table if exists traces_2w_ops_get;
create table traces_2w_ops_get like traces_2w_ops;
insert into traces_2w_ops_get
select user_id, count(*) as ops from traces_2w_active
where req_t = "DOWNLOAD"
group by user_id, req_t;

-- make
drop table if exists traces_2w_ops_make;
create table traces_2w_ops_make like traces_2w_ops;
insert into traces_2w_ops_make
select user_id, count(*) as ops from traces_2w_active
where req_t = "UPLOAD"
group by user_id, req_t;

-- move
drop table if exists traces_2w_ops_move;
create table traces_2w_ops_move like traces_2w_ops;
insert into traces_2w_ops_move
select user_id, count(*) as ops from traces_2w_active
where req_t = "MOVE"
group by user_id, req_t;

-- sync
drop table if exists traces_2w_ops_sync;
create table traces_2w_ops_sync like traces_2w_ops;
insert into traces_2w_ops_sync
select user_id, count(*) as ops from traces_2w_active
where req_t = "SYNC"
group by user_id, req_t


--




drop table if exists traces_2w_ops_all;
create table traces_2w_ops_all(
	user_id bigint,
	del bigint,
	get bigint,
	make bigint,
	move bigint,
	sync bigint
  ) stored as parquet;



select count(*) from (



insert into traces_2w_ops_all
select zeroifnull(a.user_id), zeroifnull(del.ops) del, zeroifnull(get.ops) get, zeroifnull(make.ops) make, zeroifnull(move.ops) move, zeroifnull(sync.ops) sync
from traces_2w_user_id_all a 
full outer join traces_2w_ops_delete del on a.user_id = del.user_id 
full outer join traces_2w_ops_get get on a.user_id = get.user_id 
full outer join traces_2w_ops_make make on a.user_id = make.user_id
full outer join traces_2w_ops_move move on a.user_id = move.user_id 
full outer join traces_2w_ops_sync sync on a.user_id = sync.user_id 

) as t
-- where a.user_id = del.user_id and a.user_id = get.ops




-- 

-- all  7385
-- ndb  7285
-- nb   7364 - 21
-- nd   7306 - 79


-- backup users:
-- 1285
drop table if exists traces_2w_1k_backup;
create table traces_2w_1k_backup like traces_2w_ops_all;
insert into traces_2w_1k_backup
select user_id, del, get, make, move, sync from (
select *, (make / 100*get) as rate from traces_2w_ops_all
where make > (100*get)) t
where rate > 0
order by user_id
limit 1000;
show table stats traces_2w_1k_backup;

-- 64965

-- download
-- 21xx

drop table if exists traces_2w_1k_download;
create table traces_2w_1k_download like traces_2w_ops_all;
insert into traces_2w_1k_download
select user_id, del, get, make, move, sync 
from (
select *, (get / 100*make) as rate from traces_2w_ops_all
where get > (100*make)) t
where rate > 0
order by user_id limit 1000; 
show table stats traces_2w_1k_download;

-- 16954


-- sync users:

-- 

drop table if exists traces_2w_1k_sync;
create table traces_2w_1k_sync like traces_2w_ops_all;
insert into traces_2w_1k_sync
select *
from (
 select * 
 from traces_2w_ops_all
 where sync > (2*make)  
  and make != 0 
  and user_id not in (select user_id from traces_2w_1k_download)
  and user_id not in (select user_id from traces_2w_1k_backup)
) t 
order by sync desc limit 1000;
show table stats traces_2w_1k_sync;


-- COMPROVADO QUE NO HAY COLISION
-- user_id not in ..



-- AHORA TOCA:
-- INSERTAR LOS START Y IDLE Y OFFLINE


-- [IDLE]
-- 
 

drop table if exists traces_2w_active_idle;
create table traces_2w_active_idle like traces_2w_active;
insert into traces_2w_active_idle
select 'session' as t, '' as ext, null as node_id, "IDLE" as req_t, i.sid, i.tstamp_ini, "" as type, i.user_id, null as size 
from 
traces_2w_session_interval i inner join 
traces_2w_session_idle s on (i.user_id = s.user_id and i.sid = s.sid);
show table stats traces_2w_active_idle;



drop table if exists traces_2w_active_idle_offline;
create table traces_2w_active_idle_offline like traces_2w_active;
insert into traces_2w_active_idle_offline
select 'session' as t, '' as ext, null as node_id, "OFFLINE" as req_t, i.sid, i.tstamp_fin, "" as type, i.user_id, null as size 
from 
traces_2w_session_interval i inner join 
traces_2w_session_idle s on (i.user_id = s.user_id and i.sid = s.sid);
show table stats traces_2w_active_idle_offline;



-- [ACTIVE]

drop table if exists traces_2w_active_start;
create table traces_2w_active_start like traces_2w_active;
insert into traces_2w_active_start
select 'session' as t, '' as ext, null as node_id, "START" as req_t, i.sid, i.tstamp_ini, "" as type, i.user_id, null as size 
from 
traces_2w_session_interval i inner join 
traces_2w_session_active s on (i.user_id = s.user_id and i.sid = s.sid);
show table stats traces_2w_active_start;



drop table if exists traces_2w_active_start_offline;
create table traces_2w_active_start_offline like traces_2w_active;
insert into traces_2w_active_start_offline
select 'session' as t, '' as ext, null as node_id, "OFFLINE" as req_t, i.sid, i.tstamp_fin, "" as type, i.user_id, null as size 
from 
traces_2w_session_interval i inner join 
traces_2w_session_active s on (i.user_id = s.user_id and i.sid = s.sid);
show table stats traces_2w_active_start_offline;

-- LUEGO HACER UN FILTRO DE TRAZA EN SUBTRAZA 3K


# insertar las 4 subtablas recientes en la tabla active


insert into traces_2w_active
select * from traces_2w_active_idle;


insert into traces_2w_active
select * from traces_2w_active_idle_offline;


insert into traces_2w_active
select * from traces_2w_active_start;


insert into traces_2w_active
select * from traces_2w_active_start_offline;



-------------------------------------------------------------------------------
-------------------------------------------------------------------------------SUBTRAZA de 3K OKEY

-- FINALMENTE HACER TAGGING DE LA SUBTRAZA 3K CON ORDEN DEFINIDO

-- crear subtabla por stereotipo

-- BACKUP

drop table if exists traces_2w_1k_backup_log;
create table traces_2w_1k_backup_log like traces_2w_active;

insert into traces_2w_1k_backup_log
select * from traces_2w_active
where user_id in (select user_id from traces_2w_1k_backup);

show table stats traces_2w_1k_backup_log;



-- SYNC

drop table if exists traces_2w_1k_sync_log;
create table traces_2w_1k_sync_log like traces_2w_active;

insert into traces_2w_1k_sync_log
select * from traces_2w_active
where user_id in (select user_id from traces_2w_1k_sync);

show table stats traces_2w_1k_sync_log;




-- DOWNLOAD


drop table if exists traces_2w_1k_download_log;
create table traces_2w_1k_download_log like traces_2w_active;

insert into traces_2w_1k_download_log
select * from traces_2w_active
where user_id in (select user_id from traces_2w_1k_download);

show table stats traces_2w_1k_download_log;





-------------------------------------------------------------------------------
------------------------------------------------------------------------------- volver a distinguir los usuarios

-- ahora hace falta seprarlos por heavy y no heavy

-- BACKUP HEAVY
drop table if exists traces_2w_1k_backup_heavy_ratio;

 create table traces_2w_1k_backup_heavy_ratio(
   user_id bigint
   ) stored as parquet;
   
   insert into traces_2w_1k_backup_heavy_ratio
 select user_id from(
 select *, make/(100*get) rate  from traces_2w_1k_backup
 -- order by rate desc
 order by upload desc
 limit 200) as t


 -- [not ratio]
drop table if exists traces_2w_1k_backup_heavy;

 create table traces_2w_1k_backup_heavy(
   user_id bigint
   ) stored as parquet;
   
   insert into traces_2w_1k_backup_heavy
 select user_id from(
 select *  from traces_2w_1k_backup
 order by make desc 
 limit 200) as t
-- BACKUP OCASIONAL

 drop table if exists traces_2w_1k_backup_occasional_ratio;

 create table traces_2w_1k_backup_occasional_ratio(
   user_id bigint
   ) stored as parquet;
   
   insert into traces_2w_1k_backup_occasional_ratio
 select user_id from(
 select *, make/(100*get) rate  from traces_2w_1k_backup
 order by rate asc
 limit 800) as t


-- [not ratio]

 drop table if exists traces_2w_1k_backup_occasional;

 create table traces_2w_1k_backup_occasional(
   user_id bigint
   ) stored as parquet;
   
   insert into traces_2w_1k_backup_occasional
 select user_id from(
 select *  from traces_2w_1k_backup
 order by make asc
 limit 800) as t
 


-- DOWNLOAD HEAVY
drop table if exists traces_2w_1k_download_heavy_ratio;

 create table traces_2w_1k_download_heavy_ratio(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_download_heavy_ratio
 select user_id from(
 select *, get/(100*make) rate  from traces_2w_1k_download
 order by rate desc
 limit 200) as t

-- [not ratio]

drop table if exists traces_2w_1k_download_heavy;

 create table traces_2w_1k_download_heavy(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_download_heavy
 select user_id from(
 select * from traces_2w_1k_download
 order by get desc
 limit 200) as t



 -- DOWNLOAD OCASIONAL 
drop table if exists traces_2w_1k_download_occasional_ratio;

 create table traces_2w_1k_download_occasional_ratio(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_download_occasional_ratio
 select user_id from(
 select *, get/(100*make) rate  from traces_2w_1k_download
 order by rate asc
 limit 800) as t


-- [not ratio]


drop table if exists traces_2w_1k_download_occasional;

 create table traces_2w_1k_download_occasional(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_download_occasional
 select user_id from(
 select *  from traces_2w_1k_download
 order by get asc
 limit 800) as t



 -- SYNC HEAVY

drop table if exists traces_2w_1k_sync_heavy_ratio;
  create table traces_2w_1k_sync_heavy_ratio(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_sync_heavy_ratio
 select user_id from(
 select *, sync/(2*make) rate  from traces_2w_1k_sync
 order by rate desc
 limit 200) as t

-- [not ratio]

drop table if exists traces_2w_1k_sync_heavy;
  create table traces_2w_1k_sync_heavy(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_sync_heavy
 select user_id from(
 select * from traces_2w_1k_sync
 order by sync desc
 limit 200) as t


 -- SYNC HEAVY

drop table if exists traces_2w_1k_sync_occasional_ratio;
 create table traces_2w_1k_sync_occasional_ratio(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_sync_occasional_ratio
 select user_id from(
 select *, sync/(2*make) rate from traces_2w_1k_sync
 order by rate asc
 limit 800) as t
-- [not ratio]

drop table if exists traces_2w_1k_sync_occasional;
 create table traces_2w_1k_sync_occasional(
   user_id bigint
   ) stored as parquet;
   
 insert into traces_2w_1k_sync_occasional
 select user_id from(
 select * from traces_2w_1k_sync
 order by sync asc
 limit 800) as t
 -- ahora tanemos 
 -- 



-- 
-- tenemos la trazas hora falta etiquetarlos y ordenar log




drop table if exists traces_2w_3k_master;

 
create table traces_2w_3k_master(
profile string,
priority bigint,
t string, -- storage_done
ext string, -- svg, php, pdf
-- logfile_id string, -- 
node_id bigint, -- unique file id
req_t string, -- PutContentResponse
sid string, -- sessionidstring
tstamp timestamp, -- 
type string, -- file or folder
user_id bigint, -- unique user id
size bigint -- file size
) stored as parquet;

-- BH 

insert into traces_2w_3k_master
select 'BACKUP_HEAVY' as profile,
case req_t 
when "START" then 0
when "OFFLINE" then 2
when "IDLE" then 3
else 1 end as priority,
t, ext, node_id, req_t, sid, tstamp, type, user_id, size
-- select count(*)
from traces_2w_1k_backup_log
where user_id in (select user_id from traces_2w_1k_backup_heavy)
-- and user_id = 1689074110
order by tstamp asc, priority asc

-- BO

insert into traces_2w_3k_master
select 'BACKUP_OCCASIONAL' as profile,
case req_t 
when "START" then 0
when "OFFLINE" then 2
when "IDLE" then 3
else 1 end as priority,
t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_1k_backup_log
where user_id in (select user_id from traces_2w_1k_backup_occasional)
-- and user_id = 1689074110
order by tstamp asc, priority asc



0	BACKUP_OCCASIONAL	3512113
1	BACKUP_HEAVY		3463191



-- SH
insert into traces_2w_3k_master
select 'SYNC_HEAVY' as profile,
case req_t 
when "START" then 0
when "OFFLINE" then 2
when "IDLE" then 3
else 1 end as priority,
t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_1k_sync_log
where user_id in (select user_id from traces_2w_1k_sync_heavy)
-- and user_id = 1689074110
order by tstamp asc, priority asc


-- SO

insert into traces_2w_3k_master
select 'SYNC_OCCASIONAL' as profile,
case req_t 
when "START" then 0
when "OFFLINE" then 2
when "IDLE" then 3
else 1 end as priority,
t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_1k_sync_log
where user_id in (select user_id from traces_2w_1k_sync_occasional)
-- and user_id = 1689074110
order by tstamp asc, priority asc


-- DH


insert into traces_2w_3k_master
select 'DOWNLOAD_HEAVY' as profile,
case req_t 
when "START" then 0
when "OFFLINE" then 2
when "IDLE" then 3
else 1 end as priority,
t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_1k_download_log
where user_id in (select user_id from traces_2w_1k_download_heavy)
-- and user_id = 1689074110
order by tstamp asc, priority asc

-- DO

insert into traces_2w_3k_master
select 'DOWNLOAD_OCCASIONAL' as profile,
case req_t 
when "START" then 0
when "OFFLINE" then 2
when "IDLE" then 3
else 1 end as priority,
t, ext, node_id, req_t, sid, tstamp, type, user_id, size
from traces_2w_1k_download_log
where user_id in (select user_id from traces_2w_1k_download_occasional)
-- and user_id = 1689074110
order by tstamp asc, priority asc



1 BACKUP_OCCASIONAL     3512113
5 SYNC_OCCASIONAL       2323714
3	SYNC_HEAVY			      1473726
2	DOWNLOAD_HEAVY		    1981034
0	DOWNLOAD_OCCASIONAL	  2808815
4	BACKUP_HEAVY		      3463191

4 BACKUP_HEAVY          4764619
2 DOWNLOAD_HEAVY        3555915
3 SYNC_HEAVY            2348068

1 BACKUP_OCCASIONAL     2210685
5 SYNC_OCCASIONAL       1449372
0 DOWNLOAD_OCCASIONAL   1233934


select profile,count(*) from traces_2w_3k_master --
group by profile




--- HACER


1) los ficheros que maneja cada estereotipo
2) los updates por file category
para ver si son muy diferentes


/*
select * from traces_2w_1k_backup_occasional
where user_id in ( select user_id from traces_2w_1k_backup_heavy)
*/