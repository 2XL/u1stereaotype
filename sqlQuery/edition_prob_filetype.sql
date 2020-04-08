

# extreure edition probability per file type.




-- filtrar trazas para dos semanas de:
- MakeResponse 
- PutContentResponse




-- filtrar -- necesito vincular los archivos a grupos de extensiones possibles

-- realizar filtro por ficha

drop table if exists traces_file_editions;
create table traces_file_editions(
	user_id bigint, 
	node_id bigint,
	size bigint,
	tstamp timestamp,
	ext string
) stored as parquet;


insert into traces_file_editions
select user_id, node_id, size, tstamp, ext from default.ubuntu_one
where tstamp < adddate("2014-01-11 06:25:30.752000000", 14)
and t = "storage_done"
and req_t in ("PutContentResponse");
-- esto representa todo


# and req_t in ("MakeResponse", "PutContentResponse");


drop table if exists user_2w_stereo;

create table user_2w_stereo(
  user_id bigint) 
  stored as parquet;

insert into user_2w_stereo
select distinct user_id from fit_1k_2w_sync;

insert into user_2w_stereo
select distinct user_id from fit_1k_2w_download;

insert into user_2w_stereo
select distinct user_id from fit_1k_2w_backup
;

show table stats user_2w_stereo;


-- vale pero no puedo conservar los atributos de las otra columnas
-- hacer las queries de las dos semanas y los 3000 usuarios

-- 

drop table if exists traces_file_editions_2w;
create table traces_file_editions_2w like traces_file_editions;

	insert into traces_file_editions_2w



		select * from traces_file_editions
		where user_id in (select user_id from user_2w_stereo);



show table stats traces_file_editions_2w;


-- crear una tabla temporal node_id, ext
-- join para asignar ext a las  trazas que 


-- realizar clasificación por categoria


/*


select count(*)
from traces_file_editions_2w a
inner join file_ext_category b
where a.node_id = b.node_id;

-- 13572151 -- lineas que tengan categoria son menos!!! correcto!!!

-- 34684624 lineas,

select count(*)
from traces_file_editions_2w;





*/




drop table if exists traces_file_editions_cat;
create table traces_file_editions_cat(
	user_id bigint, 
	node_id bigint,
	size bigint,
	tstamp timestamp,
	ext string,
	categoria string
) stored as parquet;


insert into traces_file_editions_cat
select a.user_id, a.node_id, a.size, a.tstamp, b.ext, b.category 
from traces_file_editions_2w a
inner join file_ext_category b
where a.node_id = b.node_id;


select count(*)
from traces_file_editions_cat;

--- asignar las extensiones 
-- habra tantos inserts como categorias



 


-- realizar ranking por id_node + tstamp


drop table if exists traces_file_editions_cat_ranked;
create table traces_file_editions_cat_ranked(
	user_id bigint, 
	node_id bigint,
	size bigint,
	tstamp timestamp,
	ext string,
	category string,
	rank bigint
) stored as parquet; 


insert into traces_file_editions_cat_ranked
select *, dense_rank() over(partition by node_id order by tstamp) as rank
 from traces_file_editions_cat;

show table stats traces_file_editions_cat_ranked;



-- comprovar cuando hay size

-- select * from ubuntu_one where size != None 
-- en el caso de put y get hay size
/*
select req_t, count(*) from default.ubuntu_one where size is not null
group by req_t
req_t	count(*)
*/
-- 0	PutContentResponse	161125183
-- 1	GetContentResponse	86888058

-- el primero lo considero make, el resto son edits
-- estan la tabla separada en categorias y 

-- con lo cual el resultado obtenido 



-- lo que ha de contenir aquesta taula:

- extreure probabilitat edició certs tipus de fitxers


# descartar le primero y conservar todos los de rango mayor de 1, no puede haber un make despues de un put



select * from traces_file_editions_cat_ranked
order by user_id, node_id



select category, count(*) edits
from traces_file_editions_cat_ranked
where rank > 1
-- and user_id in (select distinct user_id from fit_1k_2w_backup_80_ocasional) -- collect all 
group by category


categoria,edits
Compressed,	13807
Code,		276495
Pict,		472344
Docs,		264900
Audio/Video,49513
App/Binary,	67311




- el tamany del la edició de fitxers


how to obtain this?


hacer un left join y un substract de size

/*
select a.*, b.* from traces_file_editions_cat_ranked a inner join
traces_file_editions_cat_ranked b on a.rank = b.rank + 1

*/
-- select count(*) from traces_file_editions_cat_ranked
-- 13.572.151


drop table if exists traces_file_editions_size_diff;

create table traces_file_editions_size_diff(
node_id bigint,
user_id bigint,
size_ini bigint,
size_fin bigint,
size_diff bigint,
tstamp_ini timestamp,
tstamp_fin timestamp,
ext string,
category string,
rank_ini bigint,
rank_fin bigint
) stored as parquet;

insert into traces_file_editions_size_diff

select 
a.node_id,
a.user_id, 
a.size, 
b.size, 
b.size - a.size as diff_size,
a.tstamp, 
b.tstamp, 
a.ext, 
a.category, 
a.rank, 
b.rank
from traces_file_editions_cat_ranked a inner join 
traces_file_editions_cat_ranked b
on (a.node_id = b.node_id and a.rank = b.rank-1);

	show table stats traces_file_editions_size_diff;





-- ahora hay que extraer el file size change distribution


-- select count(*) from traces_file_editions_size_diff;
-- 3 612 765
-- 9 539 080 -- solo tiene una operacion por lo tanto no se puede saber mas
-- la resta de estos dos so editiones no finales sin siguiente.
/*
select count(*)
from (
select node_id, count(*) hit from traces_file_editions_cat_ranked
group by node_id
having hit <= 1 ) as t
*/

---

# refactor file edits

descartar cuando el edit file size == 0

drop table if exists traces_file_editions_size_diff_rel;
create table traces_file_editions_size_diff_rel
	(
node_id bigint,
user_id bigint,
size_ini bigint,
size_fin bigint,
size_diff bigint,
size_change double, -- porcentatge
tstamp_ini timestamp,
tstamp_fin timestamp,
ext string,
category string,
rank_ini bigint,
rank_fin bigint
		);

insert into traces_file_editions_size_diff_rel
select node_id, user_id, size_ini, size_fin, size_diff, size_fin/size_ini, tstamp_ini, tstamp_fin, ext, category, rank_ini, rank_fin  
from traces_file_editions_size_diff;

show table stats traces_file_editions_size_diff_rel;


--
-- traces_file_editions_size_diff_rel
--


select category, count(*) hit from traces_file_editions_size_diff_rel
where node_id in (select distinct node_id from fit_1k_2w_backup_20_heavy)
and size_diff > 0
group by category




-- 

-- hay que tener en cuenta que se ha filtrado el primer edit
-- que haya ficheros que solo tengan un unico edit



-- file editions size diff by stereo and file category

-- 




