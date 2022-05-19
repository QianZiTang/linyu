prefix=sample_name

head -617 $prefix.unknown.sam > $prefix.phMut-dEnd-hInter.sam
samtools view -bS $prefix.phMut-dEnd-hInter.sam > $prefix.phMut-dEnd-hInter.bam
chmod 550 $prefix.phMut-dEnd-hInter.bam

cp $prefix.phMut-dEnd-hInter.bam  $prefix.phMut-sEnd-h1.bam
cp $prefix.phMut-dEnd-hInter.bam  $prefix.phMut-sEnd-h2.bam
cp $prefix.phMut-dEnd-hInter.bam  $prefix.phMut-sEnd-hInter.bam
cp $prefix.phMut-dEnd-hInter.bam  $prefix.phMut-sEnd-h1.hInter.bam
cp $prefix.phMut-dEnd-hInter.bam  $prefix.phMut-sEnd-h2.hInter.bam
cp $prefix.phMut-dEnd-hInter.bam  $prefix.phMut-sEnd-h1.h1Intra.bam
cp $prefix.phMut-dEnd-hInter.bam  $prefix.phMut-sEnd-h2.h2Intra.bam


chmod 550 $prefix.phMut-sEnd-h1.bam  $prefix.phMut-sEnd-h2.bam  $prefix.phMut-sEnd-hInter.bam  $prefix.phMut-sEnd-h1.hInter.bam  $prefix.phMut-sEnd-h2.hInter.bam $prefix.phMut-sEnd-h1.h1Intra.bam  $prefix.phMut-sEnd-h2.h2Intra.bam

for mark in {phMut-dEnd-h1,phMut-dEnd-h2,unknown}
do
	echo "#!/bin/bash"
	echo "perl Sort_sam.pl $prefix.$mark.sam > $prefix.$mark.sort.sam"
	echo "samtools view -bS $prefix.$mark.sort.sam > $prefix.$mark.bam"
	echo "chmod 550 $prefix.$mark.bam"
done
