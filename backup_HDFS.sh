#!/bin/bash

#Sistema
DATE=$(date +%Y%m%d)
DIR=/data_processing
HDFS_DIR=/atividade_1
LOG_FILE=Backup_$DATE.log

#Dataset 1
HDFS_WATER=$HDFS_DIR/Water_Quality
DIR_WATER=$DIR/WATER_ZIP

#Dataset 2
HDFS_COVID=$HDFS_DIR/COVID_19
DIR_COVID=$DIR/COVID_ZIP

#Cria diretorios para colocar os arquivos do HDFS
mkdir $DIR_WATER
mkdir $DIR_COVID

#Pega os arquivos do HDFS do ultimo mes e deleta
for i in {30..1}
 do
  DATE=$(date +%Y%m%d -d "-$i days")

  hadoop fs -get $HDFS_WATER/WaterQuality_$DATE $DIR_WATER
  hadoop fs -rm $HDFS_WATER/WaterQuality_$DATE

  hadoop fs -get $HDFS_COVID/COVID19_$DATE $DIR_COVID
  hadoop fs -rm $HDFS_COVID/COVID19_$DATE
 done

#Zipa o diretorio contendo os arquivos dos ultimos 30 dias e envia pro backup do HDFS e deleta os diretorios criados
zip $DIR/WATER_$DATE.zip $DIR_WATER
hadoop fs -put $DIR/WATER_$DATE.zip $HDFS_WATER/bkp/
rm $DIR/WATER_$DATE.zip
rm -r $DIR_WATER

zip $DIR/COVID_$DATE.zip $DIR_COVID
hadoop fs -put $DIR/COVID_$DATE.zip $HDFS_COVID/bkp/
rm $DIR/COVID_$DATE.zip
rm -r $DIR_COVID

#Verifica se deu algum erro e registra o resultado nos logs para manter o historico
export err=$?

if [ "$err"="0" ]; then
 echo "Backup Realizado com Sucesso dos últimos 30 dias: $DATE" > $LOG_FILE
 mv $LOG_FILE $DIR/logs
 exit 0
else
 echo "Falha ao realizar o backup dos arquivos: $err" > $LOG_FILE
 mv $LOG_FILE $DIR/logs
 exit 1
fi
