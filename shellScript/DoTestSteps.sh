#!/bin/bash 


clear
# Dropbox

# 
echo "Take Credentials for Machine $1"

more ~/BenchBox/workload_generator/py_publish/plugin/credentials/api_credentials.csv | grep machine$1 | awk -F "\"*,\"*" '{print NR "\t" $6}'



echo "Manually Setup windows sandBox PersonalCloud credentials"
gedit ~/BenchBox/workload_generator/py_publish/publisher_credentials.py



echo "actualitzar el seed d'acord amb el machine IDx $1"
gedit ~/BenchBox/workload_generator/constants.py
