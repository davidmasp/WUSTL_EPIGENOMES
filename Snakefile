

import os
from urllib.parse import urlparse
import csv

url_list = []
folder_dest = []
with open("download_index.csv") as index:
    index_reader = csv.reader(index, delimiter = ",")
    for row in index_reader:
        url_list.append(row[0])
        url_path = urlparse(row[0])
        filename = os.path.basename(url_path.path)
        dest_path = row[1]
        outpath = os.path.join(dest_path,filename)
        folder_dest.append(outpath)


config = {url_list[i]: folder_dest[i] for i in range(len(url_list))} 

rule all:
    input:
        "dnamethylation/WGBS/FractionalMethylation_bigwig/E098_WGBS_FractionalMethylation.bigwig"

rule download:
    input:
        lambda wildcards: config[wildcards.dest_folder]
    output:
        "{dest_folder}"
    shell:
        "wget {input} -O {wildcards.dest_folder}"

