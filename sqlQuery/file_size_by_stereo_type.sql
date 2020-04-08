



-- 
-- node_id, user_id, ext, category, size
-- 



-- 
--  
-- 


drop table if exists user_node_2w_stereo;

create table node_2w_stereo(
node_id bigint
) stored as parquet;

insert into node_2w_stereo
select node_id from file_ext_category
where node_id in (select distinct node_id from fit_1k_2w_backup);



insert into node_2w_stereo
select node_id from file_ext_category
where node_id in (select distinct node_id from fit_1k_2w_sync);

insert into node_2w_stereo
select node_id from file_ext_category
where node_id in (select distinct node_id from fit_1k_2w_download);


select count(*) hit
from node_2w_stereo
-- ficheros unicos
-- 12787635



----------------------------------------------------------------------

create table node_2w_stereo_unique(
node_id bigint
) stored as parquet;


insert into node_2w_stereo_unique
select distinct node_id from node_2w_stereo;


--  12775448, node_id unicos que pertenezcan a estos esteotipos
-- 137635452, file size found en u1profile.u1file_size
----------------------------------------------------------------------

-- sacar el file size de la tabla de file 


drop table if exists node_2w_stereo_unique_size;
create table node_2w_stereo_unique_size like u1profile.u1file_size;


insert into node_2w_stereo_unique_size
	select * from u1profile.u1file_size
	where node_id in (select * from node_2w_stereo_unique);


	show table stats node_2w_stereo_unique_size;
	-- 10 385 695
	-- 12 775 448
----------------------------------------------------------------------



drop table if exists file_size_maxmin;

create table file_size_maxmin(
  node_id bigint, 
  user_id bigint, 
  size_max bigint,
  size_min bigint
  ) stored as parquet;



insert into file_size_maxmin
select node_id, max(user_id), max(size), min(size)
from fit_1k_2w_sync
group by node_id;


insert into file_size_maxmin
select node_id, max(user_id), max(size), min(size)
from fit_1k_2w_download
group by node_id;


insert into file_size_maxmin
select node_id, max(user_id), max(size), min(size)
from fit_1k_2w_backup
group by node_id;


select user_id, node_id, count(*) hit from file_size_maxmin
group by user_id, node_id
order by hit desc;

/*
 	user_id	node_id	hit
0	2126028913	2892341807	1
1	2677901482	2396089186	1
*/



-- asignar categoria al maxmin





drop table if exists file_size_maxmin_ext_category;

create table file_size_maxmin_ext_category(
  node_id bigint,
  user_id bigint,
  size_max bigint,
  size_min bigint,
  ext string,
  category string
  ) stored as parquet;


insert into file_size_maxmin_ext_category
select a.*, b.ext, b.category
from file_size_maxmin a inner join file_ext_category b
on (a.node_id = b.node_id)


--------------------------------------------------------------------

select count(*)
from file_size_maxmin_ext_category;
-- 12787635
select count(*)
from file_size_maxmin;
-- 26105220

-- esto es porque hay fichero con tamaño pero no pertenece en 
-- ninguno de las extensiones que hemos filtrado

-----------------------------------------------




















