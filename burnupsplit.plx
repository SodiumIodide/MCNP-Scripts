#! usr/bin/perl

use warnings;
use strict;
use File::ReadBackwards;

# This program is used to separate a burnup output file from MCNP into useable data

# By Corey Skinner

print "\nEnter the name of the file to read:\n";
my $filename = <>;
chomp $filename;

# Use relative directory to control
my $dir = ".";

tie *INFILE, 'File::ReadBackwards', $filename or die "can't read $filename: $!";
#my $infile = File::ReadBackwards->new( $filename ) or die "can't read $filename: $!";
my $line;
my $tf = 1;
my @newkeep;
my $flag = "the minimum estimated standard deviation for the ";
my $counter = 0;

print "\nReading $filename...\n";

# Read through the file
while ($tf == 1 and not eof(INFILE))
{
    $line = readline INFILE;
    unshift @newkeep, $line;
    if ($line =~ /$flag/)
    {
        $tf = 0;
    }
    $counter = $counter + 1;
    if ($counter % 1000 == 0)
    {
        print "\nLine: $counter\n";
    }
}

print "\nDone reading $filename\n";
if ($tf == 0)
{
    print "\nfound:\n$flag\n";
}
else
{
    print "did not find:\n$flag\n";
}

# Close
#$infile->close;
close INFILE;

# Create new file
print "\nEnter the name of the file to write:\n";
my $writename = <>;
chomp $writename;

open WRITEFILE, '>'.$writename or die "can't open $writename: $!";

foreach my $item (@newkeep)
{
    print WRITEFILE $item;
}

# Close
close WRITEFILE;

__END__