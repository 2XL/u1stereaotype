
drop table if exists user_files_req;


create table user_files_req (
	ext string,
	mime string,
	type string,
node_id bigint,
user_id bigint,
tstamp timestamp,
req_t string
) stored as parquet;


insert into user_files_req
select ext, mime, type, node_id, user_id, tstamp, req_t from default.ubuntu_one 
where  t = "storage_done" and type != "Directory";


show table stats user_files_req;

--- filtro dos semanas




drop table if exists user_files_req_2w;


create table user_files_req_2w like user_files_req;


	insert into user_files_req_2w
		select ext, mime, type, node_id, user_id, tstamp, req_t from user_files_req
			where tstamp < adddate("2014-01-11 06:25:30.752000000", 14);

show table stats user_files_req_2w;

-- una vez tenemos lo de las dos semanas


* hay que realizar queries individuales para cada tipo de fichero en sequencial


* lo que queremos es:


categoria de usuario, node_id, type fichero


---  hacer un distinct de ficheros unicos y clasificarlos por categoria
-- tabla file_ext
	node_id, ext


-- tabla node_unique_ext
	node_id, hit

drop table if exists node_unique_ext;

create table node_unique_ext(
  node_id bigint,
  hit bigint
  ) stored as parquet;
  
  

 insert into node_unique_ext
select node_id, count(*) hit
from file_ext
group by node_id
having hit = 1


-- tabla file_ext_category



-- node_id with unique ext but we dont know which ext
select node_id from node_unique_ext 
where hit = 1





drop table if exists file_ext_all;
create table file_ext_all(
node_id bigint, ext string) stored as parquet;

insert into file_ext_all
select node_id, ext from file_ext
where node_id in (select node_id from node_unique_ext 
where hit = 1)
group by node_id, ext;

show table stats file_ext_all;
-- node_id extension :D












---
/*

 	ext	node_id	user_id
0		0	2765732678
1		0	3674688134
2		0	166631763
3		0	2312684815
4		0	3004584212
5		0	2475692361
6		0	1974934728
7		0	3183186802
8		0	1754711714
9		0	3004584212
10		0	1595694630
11		0	1257460900
12		0	3206631960
13		0	2476460502
14		0	1588136249
15		0	1754711714
16		0	1194522690
17		0	294978377
18		0	1374961108
19		0	

-- todo el mundo tiene el node id = 0 

es la carpeta root no todo el mundo comparte la carpeta root


*/




-- clasificar los fichero por categoria

drop table if exists file_ext_category;
create table file_ext_category(
	node_id bigint, 
	ext string,
	category string
) stored as parquet;

	-- un mismo fichero puede tener muchas categorias :/ 
/*
0	NULL	66
1	2209927945	21
2	2728513444	21
3	3237423095	20
4	2779290201	20
5	523431292	20
6	374048497	
*/
show table stats file_ext_category;



 


insert into file_ext_category
	select node_id, ext, "Pict" as category     from file_ext_all
	where ext in ("jpg", 'png', 'gif', 'tif', 'svg', 'bmp') ;
-- show table stats file_ext_category;
 

insert into file_ext_category
	select node_id, ext,  "Code" as category     from file_ext_all
	where ext in ("php", 'html', 'js', 'xml', 'h', 'c', 'java','py','css', 'htm','cpp', 'json', 'r', 'hpp', 'd','m') ;
-- show table stats file_ext_category;
 

insert into file_ext_category
		select node_id, ext,  "Docs" as category     from file_ext_all
	where ext in ("pdf", 'txt', 'doc', 'tmp', 'odt', 'docx', 'xls', 'csv', 'tex', 'po') ;
-- show table stats file_ext_category;
 

insert into file_ext_category
		select node_id, ext, "Audio/Video" as category     from file_ext_all
	where ext in ("mp3", 'ogg', 'wav', 'au') ;
-- show table stats file_ext_category;
 

insert into file_ext_category
		select node_id, ext, "Compressed" as category     from file_ext_all
	where ext in ("gz", 'zip') ;
-- show table stats file_ext_category;
 

insert into file_ext_category
		select node_id, ext, "App/Binary" as category     from file_ext_all
	where ext in ("o", 'msf', 'jar', 'dat', 'ini', 'dll','log','lock','npy', 'exe', 'mo') ;
-- show table stats file_ext_category;
 


-- hacer tantos inserts como numero de categorias



 



-- case when type='active' then 0 else 1 end


select category, count(*) hit from file_ext_category
where node_id in (select distinct node_id from fit_1k_2w_backup_20_heavy)
group by category

/*


fit_1k_2w_download_80_ocasional
fit_1k_2w_sync_80_ocasional
fit_1k_2w_backup_80_ocasional

fit_1k_2w_download_20_heavy
fit_1k_2w_sync_20_heavy
fit_1k_2w_backup_20_heavy

*/

UNIQUE FILES PER CATEGORY
