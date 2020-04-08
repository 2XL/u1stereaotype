-- select count(distinct user_id) from user_folders_2w

-- 60037

select user_id, count(distinct node_id) folders
from user_folders_2w

group by user_id
order by folders desc


-- filtro por cada categoria de usuarios

/*
select user_id, count(distinct node_id) folders
from user_folders_2w

group by user_id
order by folders desc
*/ 

/*
where user_id in (
select distinct user_id
from fit_1k_2w_download_80_ocasional )
*/

/*

fit_1k_2w_download_80_ocasional
fit_1k_2w_sync_80_ocasional
fit_1k_2w_backup_80_ocasional

fit_1k_2w_download_20_heavy
fit_1k_2w_sync_20_heavy
fit_1k_2w_backup_20_heavy

*/




--- CHECK results

-- select distinct node_id from user_folders_2w
/*
select req_t 
from default.ubuntu_one
where node_id in (
select distinct node_id from  user_folders_2w

  )
group by req_t
*/

/*
 select *
 from user_folders_req_2w
 where node_id = 2778069519
 and req_t = "MakeResponse"
 order by tstamp desc
 */
/* 
 select node_id, count(dis*) hit
 from user_folders_req_2w
 group by node_id
 order by hit desc
 */
/*
select user_id, count(distinct node_id) folders
from user_folders_req_2w
where req_t = "MakeResponse"
group by user_id
order by folders desc
*/



-- 


	req_t	count(*)
0	MoveResponse	122309
1	GetContentResponse	151040
2	MakeResponse	7121276
3	PutContentResponse	251674
4	Unlink	2364826


-- clasificar estas operaciones por tipo de usuarios

drop table if exists user_folders_activities_2w_category;

create table user_folders_activities_2w_category
	(
		user_id bigint, 
		node_id bigint, 
		req_t string,  
		stereo string
	) stored as parquet;


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "backup_heavy" as stereo from user_folders_activities_2w
where user_id in (select distinct user_id from fit_1k_2w_backup_20_heavy);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "sync_heavy" as stereo from user_folders_activities_2w
where user_id in (select distinct user_id from fit_1k_2w_sync_20_heavy);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "download_heavy" as stereo from user_folders_activities_2w
where user_id in (select distinct user_id from fit_1k_2w_download_20_heavy);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "backup_ocasional" as stereo from user_folders_activities_2w
where user_id in (select distinct user_id from fit_1k_2w_backup_80_ocasional);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "sync_ocasional" as stereo from user_folders_activities_2w
where user_id in (select distinct user_id from fit_1k_2w_sync_80_ocasional);


insert into user_folders_activities_2w_category
select user_id, node_id, req_t, "download_ocasional" as stereo from user_folders_activities_2w
where user_id in (select distinct user_id from fit_1k_2w_download_80_ocasional);
 
 show table stats user_folders_activities_2w_category;

/*


fit_1k_2w_download_80_ocasional
fit_1k_2w_sync_80_ocasional
fit_1k_2w_backup_80_ocasional

fit_1k_2w_download_20_heavy
fit_1k_2w_sync_20_heavy
fit_1k_2w_backup_20_heavy

*/




884068961	194
	1096596828	17435
1	3773936101	1062
2	1358221248	516
3	3083954084	372
4	3841095879	349
5	3690654082	343
6	598577180	333
7	2778069519	301
8	3762308057	217
9	347033926	199
10	3488988723	198
11	2246648792
13	2305446956	193
14	1532583795	170
15	2790720395	161
16	3743345946	140
17	3069419591	140
18	1711255576	133
19	738993018	127
20	2854542247	123
21	2267854265	123
22	2997686870	119
23	846753227	118
24	1564227730	113
25	2544940020	110
26	2268667106	105
27	3656542414



select stereo, req_t, count(*) hit 
from user_folders_activities_2w_category
where node_id not in (1096596828, 3773936101, 1358221248, 3083954084) -- blacklist some folders
and stereo = "download_heavy"
group by stereo, req_t