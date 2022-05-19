## Reconstruct_haplotype_resolved_Hi-C_maps

###  1.  System requirements

- PBS (Protable Batch System)
- centOS 7
- perl v5.18
- HiC-Pro v2.9.0
- SNPsplit v0.3.4
- HaploHiC v0.32
- Samtools v1.6

###  2. Installation guide

​    No installation needed.

### 3. Instructions for use

#### mask genome

``` sh
# mask heterozygous SNVs to ‘N’ bases
Perl  mask_genome_with_Nbases.pl  Sus_scrofa.Sscrofa11.1.dna.toplevel.fa   het.vcf   \ 
        >  Sus_scrofa.Sscrofa11.1.dna.toplevel.Nmask.fa
```

#### Hi-C process

``` sh
# use HiC-Pro to create valid Hi-C contacts
#!/bin/bash
HiC-Pro  -i  path/data/  -o  path/results  -c  path/config_test_latest.txt
```

#### add reads flags

``` sh
# add haplotype-resolved SNV information for each Hi-C reads
SNPsplit  --paired  --no_sort  --hic  --snp_file  haplotype_SNVs  valid_Hi-C.bam
```

#### Hi-C assignment

``` sh
# assign Hi-C contacts
perl Create_HaploHiC_input_files.pl  valid_Hi-C_flags.bam sample_name

sh  HaploHiC_step2.sh
    
    sh  HaploHiC_step3.sh

```

