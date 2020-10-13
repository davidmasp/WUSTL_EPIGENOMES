# README

The WUSTL Roadmap consolidated epigenomes are a resource for uniformly processed epigenomes which have went through QC.

They contain data from Roadmap Epigenome project.

https://egg2.wustl.edu/roadmap/web_portal/processed_data.html#MethylData


## Usage

The download instructions are in the download scrtipt in R. It is built
within parallelization because the bandwith from their server is way
lower than our max bandwith normally. Thus, we should be able to benefit
from parallelization. The cpu efficiency will be low anyway I think.

To launch from slurm:

```
srun --mem=3Gb -c 15 Rscript download.R 15
```




## Data description

They are grouped in the following categories:

## Genome-wide signal coverage tracks

This includes DHS and Chip-Seq and they are given either as poison p-value or as fold-change. The most case use is the fold-change over input.

