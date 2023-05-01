# Trabalho HDFS
Atividade 1 da aula de Data Processing, MBA Engenharia de Dados - 25ABD

Marco Aurelio Kawassa Nakasima - 350086

-------------------------------------------

Ambiente:

Foi necessário ajustar o ambiente para utilizarmos as ferramentas Wget e Zip.

Alteramos o arquivo /etc/apt/sources.list e colocamos:
```
deb http://security.debian.org/ jessie/updates main

deb-src http://security.debian.org/ jessie/updates main

deb http://archive.debian.org/debian/ jessie-backports main

deb-src http://archive.debian.org/debian/ jessie-backports main

deb http://archive.debian.org/debian/ jessie main contrib non-free

deb-src http://archive.debian.org/debian/ jessie main contrib non-free
```
E em seguidas rodamos os comandos abaixo:
```
apt-get update
apt-get install wget
apt-get install zip
```
-------------------------------------------
Escolhemos dois Datasets:
- Qualidade da Água em cada estação - https://data.ca.gov/dataset/water-quality-data/resource/b27f05a6-91af-4d76-87c9-47df0c5d1318Ç = Escolhemos esse Dataset pois ele possuí atualizações frequentes.


- Vigilância de casos de covid-19 - https://catalog.data.gov/dataset/covid-19-case-surveillance-public-use-data/resource/a03f3502-58e9-4ec4-95a9-a651ca4e86e8?inner_span=True = Escolhemos esse Dataset por conta do volume alto de registros, sendo assim muito pesado para carregar no HDFS.
-------------------------------------------
Estrutura de pastas dentro do HDFS:
```
hadoop fs -mkdir /atividade_1/
hadoop fs -mkdir /atividade_1/COVID_19/
hadoop fs -mkdir /atividade_1/COVID_19/bkp
hadoop fs -mkdir /atividade_1/Water_Quality/
hadoop fs -mkdir /atividade_1/Water_Quality/bkp
```
![image](https://user-images.githubusercontent.com/13857701/235383811-e817ee56-da65-4fa1-be72-81c76478e8d9.png)

Criamos uma pasta para cada um dos Datasets e armazenamos os datasets diariamente, colocando a data na qual ela foi extraída junto ao nome do arquivo.

E para os arquivos de backup, criamos uma pasta /bkp/ em cada um dos diretórios no qual armazenamos diretórios zipados contendo 30 dias de arquivo coletado.

![image](https://user-images.githubusercontent.com/13857701/235384543-b4487673-4ff8-4e11-8b60-bbc6d3997cb0.png)

A imagem a seguir, resgatamos o ZIP gerado pelo script de backup, contendo os arquivos dos últimos 30 dias:
![image](https://user-images.githubusercontent.com/13857701/235388538-52354451-d41a-4a2f-93e5-14820c15a629.png)


Desenhamos essa estrutura pois conseguimos identificar facilmente cada dataset e quando que foi extraída apenas pelos nomes do arquivos, e por estarem ordenados no formato YYYY/mm/dd, conseguimos percorrer os arquivos de forma crescente caso necessário.

Também fizemos um step extra de registros de logs, para cada execução dos scripts loadDataset_HDFS.sh e backup_HDFS.sh, guardamos o resultado da execução dos scripts (Sucesso ou Falha) em suas respectivas datas que foram rodados.

![image](https://user-images.githubusercontent.com/13857701/235386533-665deca7-83af-472a-a782-8ba791d36e0c.png)

-------------------------------------------
Scripts:

Demos upload nos scripts shellscript (.sh) semi-automatizados, um para carregar os datasets dentro do HDFS e o outro para os backups. Ambos os scripts estão comentados para facilitar o entendimento. Tivemos que fazer a alteração de permissão nos scripts para que pudesse ser utilizado por todos os integrantes:

```
chmod 777 loadDataset_HDFS.sh
chmod 777 backup_HDFS.sh
```

loadDataset_HDFS.sh - RODA DIARIAMENTE

backup_HDFS.sh - RODA A CADA 30 DIAS (Joga os arquivos dos ultimos 30 dias em uma pasta zipada e coloca na pasta /bkp do HDFS e deleta os arquivos separados do HDFS)
