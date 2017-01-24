#! /usr/bin/perl
use warnings;
use strict;

# By Corey Skinner

# All MCNP output files are "out?"
my $keyword = "out";
# Relative directory to open
my $dir = ".";
# File search parameter
my $sp = "final result";
# Name of logfile
my $logname = "k_values.txt";
# String indicating title
my $titlestr = "i=";

print "\nThis script will create a file called $logname to store data.";
print "\nOutput will be displayed in the active command window.\n";
print "\nNOTE: Unexpected behavior will occur if any additional filenames\n";
print "\tcontain the word \"out\"\n";
print "\nPress Enter to execute.\n";
<>;

# Read directory
opendir DIR,$dir or die "can't opendir $dir: $!";
my @dir = readdir(DIR);
close DIR;

# Open a log file
open(LOGFILE, '>'.$logname) or die "can't open logfile $logname: $!";

foreach my $item (@dir)
{
    # If keyword is in the item
    if ($item =~ /$keyword/)
    {
        # Open the file for reading
        open(my $fh, '<:encoding(UTF-8)', $item) or die "can't open file $item: $!";
        while (my $row = <$fh>)
        {
            chomp $row;
            # Title
            if ($row =~ /$titlestr/)
            {
                # Display to user
                print "$item:\n$row\n";
                # Write to logfile
                print LOGFILE "$item:\n$row\n";
            }
            if ($row =~ /$sp/)
            {
                # Display to user
                print "$row\n\n";
                # Write to logfile
                print LOGFILE "$row\n\n";
            }
        }
        close $fh;
    }
}

close LOGFILE;

__END__