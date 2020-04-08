#!/bin/bash




declare -a profile=("backup_20_heavy" "sync_20_heavy" "download_20_heavy" "backup_80_ocasional" "sync_80_ocasional" "download_80_ocasional")
declare -a category=("Docs" "Compressed" "Code" "Pict" "Audio/Video" "App/Binary")


echo "Filesize by stereotype and Category"



## now loop through the above array
for c in "${category[@]}"
do
	for p in "${profile[@]}"
	do
    
	    q="select size_min, size_max, ext, category from u1fitting.file_size_maxmin_ext_category where node_id in (select distinct node_id from u1fitting.fit_1k_2w_$p) and category = '$c'"
        out=$p"_"$c".csv"
        newname=$(echo "$out" | sed -r 's/[/]+/_/g')
        echo $out
    	echo $q
        impala-shell -B -o "$newname" --output_delimiter=',' -q "$q"
done
done






