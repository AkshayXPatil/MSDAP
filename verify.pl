my @expvalues;
my @obvalues;
my @errorlines;
my $i = 0;
my $matched = 0;
my $error = 0;
my $line_no =0;
my $a;
open (my $expectedfile, "< data1(golden).out") or die ("could not open expected file file");
open (my $obtainedfile, "< data1.out") or die ("could not open obtained file");
open (my $outfile, ">> verify.txt") or die ("could not open verify.txt");
print $outfile "\t\t expected\t\t\t\t obtained\n";
while ((my $lineexp = <$expectedfile>) && (my $lineob = <$obtainedfile>))
{
	@expvalues = split /\s/,$lineexp;
	@obvalues = split /\s/,$lineob;
	$line_no = $line_no+1;
	if ($lineexp =~ /^\s*$/)
	{
		last;
	}
	#expvalues 3,9
		if(($expvalues[3] eq uc $obvalues[0]) && ($expvalues[9] eq uc $obvalues[1]))
		{
			print $outfile "$expvalues[3]\t$expvalues[9] | $obvalues[0]\t$obvalues[1]\t matched!\n";
			$matched = $matched +1;
		}
		else
		{
			print $outfile "$expvalues[3]\t$expvalues[9] | $obvalues[0]\t$obvalues[1]\t error!\n";
			$errorlines[$error] = $line_no;
			$error = $error +1;	
		}
	
}

if($error > 0)
{
	print "ended with $error errors on following lines: \n";
	foreach $a (@errorlines)
	{
		print "$a\n";
	}
}
else
{
	print "Congratulations! Your output is 100% correct! matched $matched values\n";
}