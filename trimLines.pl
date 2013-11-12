############################
# Name: trimLines.pl
# Author: Jeremiah Burley
#
# perl trimLines.pl -in <input file> -out <output file>
#
# Reads each line in the input file, splitting lines found that exceeds a
# specified limit.  The current limit is set to 5000.  Any line with characters
# more than 5000 is split.  All lines, whether split or not, are written out to
# a specified output file.   For example, if a line contains 10234 characters,
# that line would be split three times.  Example output (to STDOUT):
#
#  Line "1147491" is too long at "10234" characters. Splitting Line... 5000, 5000, 234,
#
############################
use strict;
use Getopt::Long;

# Define command line options
my $inFile = "";
my $outFile = "";

# Get command line options
GetOptions(
    'in=s'  => \$inFile,
    'out=s' => \$outFile
) or die "Incorrect usage!\n";

# Report errors if command line options not specified
if( !$inFile && !$outFile ) {
    print "Please specify input and output files using options -in and -out.  Thank you.\n";
}
elsif ( !$inFile ) {
    print "Please specify an input file using option -in.  Thank you.\n";
}
elsif( !$outFile ) {
    print "Please specify an output file using option -out.  Thank you.\n";

# Process input file...
} else {

    # Define Variables
    my $lnNum     = 1;
    my $lnMaxChrLgth = 5000;      # The maximum number of characters any line can have...
    
    # Open File Handlers...
    open( OUT, '>', $outFile) || die "\nUnable to create $outFile\n";
    open( IN,  '<', $inFile ) || die "Can't open $inFile: $!";

    # Look at each line in the input file, slitting lines that exceed the maximum number of
    # characters allowed for a line into shorter lines, writing all lines to output file.
    foreach my $line (<IN>) {

        chomp($line);                   # Removing newline character
        my $lnLgth = length($line);     # Storing line length for STDOUT
        
        if ($lnLgth > $lnMaxChrLgth){

            # Define Variables
            my @lineSplits  = ();
            
            # Print Output
            print "Line \"$lnNum\" is too long at \"$lnLgth\" characters. Splitting Line...\t";
            
            # Populate temp array with line "splits"...
            push @lineSplits, $1 while ($line =~ /(.{1,$lnMaxChrLgth})/msxog);
            
            # Write out line splits to output file
            foreach (@lineSplits) {
                my $elemLgth = length($_);
                print "$elemLgth, ";
                print OUT "$_\n";
            }
            print "\n";
            
        }
        else {
            print OUT "$line\n";
        }
        
        $lnNum++;
    }

    # close the file handles.
    close IN;
    close OUT;
}