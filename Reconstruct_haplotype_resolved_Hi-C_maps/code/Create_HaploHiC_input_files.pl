use strict;

unless(@ARGV==2){
	print "perl $0 [bam]  [prefix]\n";
	exit;
}

my $bam=shift;
my $prefix=shift;

my %chrs;
foreach my $n(1..18){
	$chrs{$n}=1;
}

open OUT1,">","$prefix.phMut-dEnd-h1.sam" or die;
open OUT2,">","$prefix.phMut-dEnd-h2.sam" or die;
open OUT3,">","$prefix.unknown.sam" or die;

open IN,"samtools view -H $bam |" or die;
while(<IN>){
	chomp;
	print OUT1 "$_\n";
	print OUT2 "$_\n";
	print OUT3 "$_\n";
}
close IN;

open IN,"samtools view $bam |" or die;
while(<IN>){
	chomp;
	my @cut1=split /\t/,$_;
	my $line=<IN>;
	chomp $line;
	my @cut2=split /\t/,$line;
	
	next unless (exists $chrs{$cut1[2]} && exists $chrs{$cut2[2]});
	
	next unless ($cut1[2] == $cut2[2]);


	my $flag1=(split /:/,$cut1[-1])[-1];
	my $flag2=(split /:/,$cut2[-1])[-1];

	next if ($flag1 eq 'CF' || $flag2 eq 'CF');
	next if ($flag1 eq 'G1' && $flag2 eq 'G2');
	next if ($flag1 eq 'G2' && $flag2 eq 'G1');


	if($flag1 eq 'G1' || $flag2 eq 'G1'){
		print OUT1 "$_\tXH:Z:h1\tXS:Z:dEndSoloHap;R1:h1;R2:h1\tXM:Z:h1\n";
		print OUT1 "$line\tXH:Z:h1\tXS:Z:dEndSoloHap;R1:h1;R2:h1\tXM:Z:h1\n";
	}elsif($flag1 eq 'G2' || $flag2 eq 'G2'){
		print OUT2 "$_\tXH:Z:h2\tXS:Z:dEndSoloHap;R1:h2;R2:h2\tXM:Z:h2\n";
                print OUT2 "$line\tXH:Z:h2\tXS:Z:dEndSoloHap;R1:h2;R2:h2\tXM:Z:h2\n";
	}elsif($flag1 eq 'UA' && $flag2 eq 'UA'){
		print OUT3 "$_\tXS:Z:unknownHap\n";
		print OUT3 "$line\tXS:Z:unknownHap\n";
	}
}
close IN;

close OUT1;
close OUT2;
close OUT3;
__END__
