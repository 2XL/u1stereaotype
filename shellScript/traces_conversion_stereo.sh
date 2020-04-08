#!/bin/bash



# t string,
# ext string,
# logfile_id string,
# node_id bigint,
# req_t string,
# sid string,
# tstamp timestamp,
# type string,
# user_id bigint,
# size bigint
declare -a profile=("backup_20_heavy" "sync_20_heavy" "download_20_heavy" "backup_80_ocasional" "sync_80_ocasional" "download_80_ocasional")


for p in "${profile[@]}"
do

	#q="select size_ini, size_fin, size_change, ext, category from u1fitting.traces_file_editions_size_diff_rel where user_id in (select distinct user_id from u1fitting.fit_1k_2w_$p)"
	q="select ext, node_id, req_t, sid, tstamp, type, user_id, size from traces_sintetic.traces_sintetic where user_id in (select distinct user_id from u1fitting.fit_1k_2w_$p)"
	out=$p"_traces_sintetic.csv" 
	echo $out
	echo $q


	echo "START QUERY!"

	impala-shell -B -o "$out" --output_delimiter=',' -q "$q"


done


echo "END QUERY!"




