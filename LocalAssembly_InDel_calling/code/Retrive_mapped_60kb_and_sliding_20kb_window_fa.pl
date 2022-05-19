use strict;

unless(@ARGV==2){
	print "perl $0 [overlap bed] [ONT fasta]\n";
	exit;
}

my $bed=shift;
my $seq=shift;

my %HASH=();
open IN,"<","$bed" or die;
while(<IN>){
	chomp;
	my @a=split /\t/;
	$HASH{$a[3]}{$_}=1;
}
close IN;


open IN,"gunzip -c $seq |" or die;
while(<IN>){
	chomp;
	my $id=$_;
	$id=~s/>//;
	my $fa=<IN>;
	chomp $fa;

	if(exists $HASH{$id}){
		foreach my $k(sort keys%{$HASH{$id}}){
			print "$k\t$fa\n";
		}
	}
}
close IN;
