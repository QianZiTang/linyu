## LocalAssembly_InDel_calling

### 1.System requirements

- PBS (Protable Batch System)

-  centOS 7

- canu v1.8

- NECAT v0.0.1

- minimap2 v2.17

- perl v5.18

- samtools v0.1.19

- intersectBed v2.18

- ngmlr v0.2.7

- sniffles v1.0.11

### 2. Installation guide

​    No installation needed

### 3.Instructions for use

#### assign ONT reads

```sh
# assign ONT reads of hybrid F1 to maternal or paternal
#!/bin/bash

canu  \
-p sample_name  \
-d sample_name  \

genomeSize=2.5g  \
-haplotypeMat  Mat_*.fq*.gz \
-haplotypePat   Pat_*.fq*.gz   \ 
-nanopore-raw  sample_name.Nanopore.fasta.gz  \
hapMemory=1800g   \
hapThreads=70  \
maxMemory=1800g  \
maxThreads=70 \
useGrid=false
```

#### error-correlation

``` sh
\# error-correlation of haplotype-resolved ONT reads
\#!/bin/bash
necat.pl correct Mat_config
```

##### Mat_config

```tex
PROJECT=Mat
ONT_READ_LIST=Mat.ONT_reads_list
GENOME_SIZE=2500000000
THREADS=32
MIN_READ_LENGTH=3000
PREP_OUTPUT_COVERAGE=40
OVLP_FAST_OPTIONS=-n 500 -z 20 -b 2000 -e 0.5 -j 0 -u 1 -a 1000
OVLP_SENSITIVE_OPTIONS=-n 500 -z 10 -e 0.5 -j 0 -u 1 -a 1000
CNS_FAST_OPTIONS=-a 2000 -x 4 -y 12 -l 1000 -e 0.5 -p 0.8 -u 0
CNS_SENSITIVE_OPTIONS=-a 2000 -x 4 -y 12 -l 1000 -e 0.5 -p 0.8 -u 0
TRIM_OVLP_OPTIONS=-n 100 -z 10 -b 2000 -e 0.5 -j 1 -u 1 -a 400
ASM_OVLP_OPTIONS=-n 100 -z 10 -b 2000 -e 0.5 -j 1 -u 0 -a 400
NUM_ITER=2
CNS_OUTPUT_COVERAGE=30
CLEANUP=1
USE_GRID=false
SMALL_MEMORY=0
```

#### mapping

```sh
# mapping error-correlated ONT reads
#!/bin/bash

minimap2 -t 32 -x map-ont -a --MD Sus_scrofa.Sscrofa11.1.dna.toplevel.fa  \ Mat_ONT_correlated.fa.gz |  samtools view  -bS  - >  Mat_ONT.minimap2.bam
samtools sort -m 3G Mat_ONT.minimap2.bam  Mat_ONT.minimap2.sort
```

 #### split mapped reads

``` sh
# split mapped bam files to 60-kb windows sliding by 20-kb
#!/bin/bash
perl Create_60kb_window_sliding_20kb_bed.pl > Sus11.60kb_sliding_20kb.bed

intersectBed  \
-a Mat_ONT.minimap2.sort.bam \
-b Sus11.60kb_sliding_20kb.bed  \
-wa -wb -bed  >  Mat_ONT.minimap2.sort.bam.overlap.bed

perl  \ 
Retrive_mapped_60kb_and_sliding_20kb_window_fa.pl  \
Mat_ONT.minimap2.sort.bam.overlap.bed   \
Mat_ONT_correlated.fa.gz   > Mat_ONT_correlated.fa.gz.retrived.fa

```

#### local assembly

``` sh
 #local assembly for each 60-kb window 
canu \
-assemble   \
-p  window1  \ 
-d  window1  \
genomeSize=60k  \ 
-nanopore-corrected  window1.fa  \
useGrid=false  \
maxMemory=40g  \
maxThreads=8

```

#### InDel calling  

``` sh
\#call InDels by local-assembled contigs
ngmlr \
   --bam-fix \
-r Sus_scrofa.Sscrofa11.1.dna.toplevel.fa  \
-q window_1.canu.contigs \
-t 32 \
-o window_1.bam \
-x pacbio
samtools sort -m 3G winow_1.bam window_1.sort 
sniffles \
   -m window_1.sort.bam  \
   -v window_1.SV.vcf \
-t 32  \
--min_support 2 \
--report_BND  \
--report_seq  \
--min_length 49  \
--num_reads_report -1
```



