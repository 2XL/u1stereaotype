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

q="select profile, ext, node_id, req_t, sid, tstamp, type, user_id, size from traces_sintetic.traces_sintetic order by tstamp asc"
out="traces_sintetic_profile.csv" 
echo $out
echo $q


echo "START QUERY!"

impala-shell -B -o "$out" --output_delimiter=',' -q "$q"


echo "END QUERY!"