use strict;

unless(@ARGV==2){
	print "perl $0 [ref genome] [vcf file]\n";
	exit;
}

my $ref=shift;
my $vcf=shift;

my %pos;
open IN,"<","$vcf" or die;
while(<IN>){
	chomp;
	next if /^#/;
	my @a=split;
	$pos{$a[0]}{$a[1]}=1;
}
close IN;

my $count=0;
my $chr;
open IN,"<","$ref" or die;
while(<IN>){
	chomp;
	if(/^>(\S+)/){
		$chr=$1;
		print ">$chr\n";
		$count=0;
	}else{
		my @a=split //;
		my $line='';
		foreach my $f(@a){
			$count++;
			if(exists $pos{$chr}{$count}){
				$line.='N';
			}else{
				$line.=$f;
			}
		}
		print "$line\n";
	}
}
