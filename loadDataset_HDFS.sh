#!/bin/bash

#Sistema
DATE=$(date +%Y%m%d)
DIR=/data_processing
HDFS_DIR=/atividade_1
LOG_FILE=$DATE.log

#Dataset 1
URL_BASE_WATER=https://data.ca.gov/datastore/odata3.0/b27f05a6-91af-4d76-87c9-47df0c5d1318
HDFS_WATER=$HDFS_DIR/Water_Quality

#Dataset 2
URL_BASE_COVID=https://data.cdc.gov/api/views/vbim-akqf/rows.json?accessType=DOWNLOAD
HDFS_COVID=$HDFS_DIR/COVID_19

#Faz o Download dos Datasets
wget -cO - $URL_BASE_WATER  > WaterQuality_$DATE
wget -cO - $URL_BASE_COVID  > COVID_$DATE

#Verificar se deu algum erro e registra os resultados em logs
export err=$?

#Apos o download verificar se nao teve erro e grava os arquivos no HDFS.
if [ "$err"="0" ]; then
 echo "Transferindo arquivo WaterQuality_$DATE para HDFS: $HDFS_WATER"
 hadoop fs -put $DIR/WaterQuality_$DATE $HDFS_WATER
 rm WaterQuality_$DATE

 echo "Transferindo arquivo COVID_$DATE para HDFS: $HDFS_COVID"
 hadoop fs -put $DIR/COVID_$DATE $HDFS_COVID
 rm COVID_$DATE

 echo "Script executado com sucesso: $DATE" > $LOG_FILE
 mv $DIR/$LOG_FILE $DIR/logs/
 exit 0
else
 echo "Falha no download dos datasets: $err" > $LOG_FILE
 mv $DIR/$LOG_FILE $DIR/logs/
 exit 1
fi