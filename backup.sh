#!/bin/bash
exec > backup.log 2>&1
set -x

name=electricca

# exit 0

DAY=`date +%d`

cd /opt/electric/collectiveaccess
docker-compose -p $name stop

docker exec -ti electricca_db_1 mysqldump -h localhost --all-databases -uroot -prootpass --result-file=/var/lib/mysql/backup.sql

BFILE=/root/backup/"$name"_`date +%Y%m%d_%H%M`.tbz
# rsync -av --delete -e ssh . root@www.arrlee.ch:/opt/backup/collectiveaccess/$DAY/
tar jcvf $BFILE .


echo "Finished creating backup file $BFILE"

echo "Starting CA again"
docker-compose -p $name start
sleep 10
docker-compose -p $name start



cd -
