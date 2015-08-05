#!/bin/sh
##每个月第一天对spider_goods进行分表，将老数据存在spider_goods_YYYYMMDD里
#1 0 1 * * cd /data/dp/sql; /bin/sh merge.sh > merge.log
mysql -udp -pAylpiznihjQrrbj@5733 -heunke-db003 --default-character-set=utf8 spider_data -e "source /data/dp/sql/mergesg.sql;" > merge_db003.log
#mysql -h182.92.168.82 -uroot -peunke@root --default-character-set=utf8 spider_data -e "source /data/dp/sql/mergesg.sql;" > merge.log
