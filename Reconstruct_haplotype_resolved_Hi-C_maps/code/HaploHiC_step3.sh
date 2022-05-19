#!/bin/bash

prefix=sample_name

path=`pwd`

mkdir -p results/$prefix-workspace

for mark in {phMut-dEnd-h1,phMut-dEnd-h2,phMut-dEnd-hInter,phMut-sEnd-h1,phMut-sEnd-h2,unknown,phMut-sEnd-hInter,phMut-sEnd-h1.hInter,phMut-sEnd-h2.hInter,phMut-sEnd-h1.h1Intra,phMut-sEnd-h2.h2Intra}
do
	ln -s $path/$prefix.$mark.bam $path/results/$prefix-workspace
done

touch $prefix.bam
echo "$prefix.bam" > bam.list

touch $prefix.phasedSNP.vcf

perl HaploHiC.pl  haplo_div -phsvcf $path/$prefix.phasedSNP.vcf -outdir $path/results -bamlist $path/bam.list  -samt samtools-1.6/samtools -db_dir HaploHiC/1.Database -ref_v Sus11  -enzyme MboI -st_step 3 -ed_step 4


