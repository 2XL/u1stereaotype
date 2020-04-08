#!/bin/bash
# query.sh



# benchbox metrics
influx -host 10.30.103.232 -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute 'select * from benchbox_workload' > benchbox_workload.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute 'select * from benchbox_workload' > benchbox_workload.csv



# benchbox_workload_dropbox_backup_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_backup_occasional.csv

# benchbox_workload_dropbox_download_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_download_heavy.csv

# benchbox_workload_dropbox_download_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_download_occasional.csv

# benchbox_workload_dropbox_sync_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_sync_heavy.csv

# benchbox_workload_dropbox_sync_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_sync_occasional.csv


# --

# benchbox_workload_googledrive_backup_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_workload_googledrive_backup_heavy.csv

# benchbox_workload_googledrive_download_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_workload_googledrive_download_heavy.csv

# benchbox_workload_googledrive_download_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_workload_googledrive_download_occasional.csv


# benchbox_workload_googledrive_sync_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_workload_googledrive_sync_heavy.csv

# benchbox_workload_googledrive_sync_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_workload_googledrive_sync_occasional.csv










# ==========================================



# sandbox_ metrics
influx -host 10.30.103.232 -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute 'select * from benchbox' > sandbox_workload.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute 'select * from benchbox' > sandbox_workload.csv





# benchbox_dropbox_backup_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_backup_occasional.csv

# benchbox_dropbox_download_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_download_heavy.csv

# benchbox_dropbox_download_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_download_occasional.csv

# benchbox_dropbox_sync_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_sync_heavy.csv

# benchbox_dropbox_sync_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_sync_occasional.csv



# benchbox_googledrive_backup_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_googledrive_backup_heavy.csv

# benchbox_googledrive_download_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_googledrive_download_heavy.csv

# benchbox_googledrive_download_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_googledrive_download_occasional.csv

# benchbox_googledrive_sync_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_googledrive_sync_heavy.csv

# benchbox_googledrive_sync_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd107' or hostname = 'd108' or hostname = 'd109' or hostname = 'd110'  or hostname = 'd111'  or hostname = 'd112'" > benchbox_googledrive_sync_occasional.csv





#### 1xN


# benchbox_workload_dropbox_group_backup_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_group_backup_heavy.csv

# benchbox_dropbox_group_backup_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_group_backup_heavy.csv



# benchbox_workload_dropbox_group_backup_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_group_backup_occasional.csv

# benchbox_dropbox_group_backup_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_group_backup_occasional.csv



#### NxM



# benchbox_workload_dropbox_group_backup_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_group_NxM_backup_heavy.csv

# benchbox_dropbox_group_backup_heavy.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_group_NxM_backup_heavy.csv



# benchbox_workload_dropbox_group_backup_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox_workload where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_workload_dropbox_group_NxM_backup_occasional.csv

# benchbox_dropbox_group_backup_occasional.csv
influx -host localhost -port 8086 -database 'metrics' -format 'csv' -precision 'ms' -execute "select * from benchbox where hostname = 'd101' or hostname = 'd102' or hostname = 'd103' or hostname = 'd104'  or hostname = 'd105'  or hostname = 'd106'" > benchbox_dropbox_group_NxM_backup_occasional.csv

