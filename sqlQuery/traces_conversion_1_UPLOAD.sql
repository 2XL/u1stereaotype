

# append UPLOAD operations to traces_sintetic


drop table if exists traces_sintetic;
create table traces_sintetic(
t string,
ext string,
logfile_id string,
node_id bigint,
req_t string,
sid string,
tstamp timestamp,
type string,
user_id bigint,
size bigint -- ,
-- size_diff double
) stored as parquet;


insert into traces_sintetic
select t, ext, logfile_id, node_id, "UPLOAD" as req_t, sid, tstamp, type, user_id, size
from traces_2w_3k_tmp_upload_rank_unique
where rank = 1

 

 select req_t, count(*) from traces_sintetic
group by req_t

-- UPLOAD 16.335.931



---------------------
-- RE size fix
---------------------

drop table if exists traces_sintetic_re;
create table traces_sintetic_re(
t string,
ext string,
logfile_id string,
node_id bigint,
req_t string,
sid string,
tstamp timestamp,
type string,
user_id bigint,
size bigint  -- ,
-- size_diff double -- # añadir la division de 1r / 2n
) stored as parquet;



---------------------
-- RE size fix
---------------------

insert into traces_sintetic_re
select t, ext, logfile_id, node_id, "UPLOAD" as req_t, sid, tstamp, type, user_id, size
from traces_2w_3k_tmp_upload_rank_unique
where rank = 1
