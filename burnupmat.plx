#! usr/bin/perl
use warnings;
use strict;
use Text::Trim qw(trim);

# Pull materials at specific timesteps from an MCNP burnup

# By Corey Skinner

print "\nEnter the name of the burnup file to analyze:\n";
my $burnname = <>;
chomp $burnname;

open BURNFILE, "<".$burnname or die "can't open $burnname: $!";

print "\nEnter the material number:\n";
my $mat = <>;
chomp $mat;

print "\nEnter the time step:\n";
my $ts = <>;
chomp $ts;

print "\nEnter ZAID extension (e.g. .70c):\n";
my $zaidex = <>;
chomp $zaidex;

if (length $ts == 1)
{
    $ts = " ".$ts;
}
if (length $mat == 1)
{
    $mat = " ".$mat;
}

my $atag = " actinide inventory for material  $mat at end of step $ts";
my $natag = " nonactinide inventory for material  $mat at end of step $ts";
my @matarr;
my $aflag = 0;
my $endaflag = 0;
my $naflag = 0;
my $endnaflag = 0;
my $endtag = "totals";

print "\nReading file...\n";

while (my $currentline = <BURNFILE>)
{
    if (not $aflag)
    {
        if ($currentline =~ /$atag/)
        {
            $aflag = 1;
        }
    }
    elsif ($aflag and not $endaflag)
    {
        if ($currentline =~ /$endtag/)
        {
            $endaflag = 1;
        }
        my @line = split ' ', $currentline;
        if (defined $line[0])
        {
            if ($line[0] =~ /\d/)
            {
                my $return = $line[1] . $zaidex . " " . $line[6];
                push @matarr, $return;
            }
        }
    }
    
    if (not $naflag)
    {
        if ($currentline =~ /$natag/)
        {
            $naflag = 1;
        }
    }
    elsif ($naflag and not $endnaflag)
    {
        if ($currentline =~ /$endtag/)
        {
            $endnaflag = 1;
        }
        my @line = split ' ', $currentline;
        if (defined $line[0])
        {
            if ($line[0] =~ /\d/)
            {
                my $return = $line[1] . $zaidex . " " . $line[6];
                push @matarr, $return;
            }
        }
    }
}

close BURNFILE;

my $writename = "mat" . trim($mat) . "ts" . trim($ts) . "burn.txt";
print "\nWriting file to $writename...\n";
open WRITEFILE, ">".$writename or die "can't open $writename: $!";

print WRITEFILE "Material: $mat\nTimestep: $ts\nZAID    atfrac\n\n";

foreach my $item (@matarr)
{
    print WRITEFILE "     ".$item . "\n";
}

close WRITEFILE;

print "\nDone writing file.";

__END__