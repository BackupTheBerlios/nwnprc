#!/bin/sh

# Sample bash script for the 2da_to_sql utility
#
# It will load feat.2da and spells.2da into the database
# Note that it has to be launched AFTER the in-game cache 
# initialization (eventually while the game is running).

PATH=../../prc/2das
MYSQL=/usr/bin/mysql
#MYSQL="/c/program files/mysql/bin/mysql"
HOST=localhost
LOGIN=root

#gcc -Wall -O2 -s 2da_to_sql.c -o 2da_to_sql

echo "USE nwn;" > featspell.sql

./2da_to_sql feat   $PATH/feat.2da   >> featspell.sql
./2da_to_sql spells $PATH/spells.2da >> featspell.sql

$MYSQL -h $HOST -u $LOGIN -p < featspell.sql

rm -f featspell.sql
