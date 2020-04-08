#!/bin/bash


declare -a profile=("backup_20_heavy" "sync_20_heavy" "download_20_heavy" "backup_80_ocasional" "sync_80_ocasional" "download_80_ocasional")
declare -a category=("Docs" "Compressed" "Code" "Pict" "Audio/Video" "App/Binary")


# parse
# xl_traces_sync_min_raw

# ssh lab144@ast12.recerca.intranet.urv.es

# -- 1r carregar un array amb els possibles variables

#q="select size_diff from u1fitting.traces_file_editions_size_diff order by size_diff asc"
#echo $q
#impala-shell -B -o "traces_file_editions_all.csv" --output_delimiter=',' -q "$q"



## now loop through the above array
for c in "${category[@]}"
do
	for p in "${profile[@]}"
	do
    
	    q="select size_ini, size_fin, size_change, ext, category from u1fitting.traces_file_editions_size_diff_rel where node_id in (select distinct node_id from u1fitting.fit_1k_2w_$p) and category = '$c' and size_diff != 0 "
        out=$p$c".csv"
        newname=$(echo "$out" | sed -r 's/[/]+/_/g')
        echo $out
    	echo $q
        impala-shell -B -o "$newname" --output_delimiter=',' -q "$q"
done
done



