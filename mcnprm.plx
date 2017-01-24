#!usr/bin/perl
use warnings;
use strict;

# By Corey Skinner

# Relative directory
my $dir = ".";

{
    opendir $dirh,$dir or die "can't open $dir: $!";
    my @dir = readdir($dirh);
    close $dirh;
}

foreach my $item (@dir)
{
    if ($item =~ /^(out\w)|(runtp\w)|(srct\w)|(comou\w)|(meshta\w)|(mcta\w)$/)
    {
        unlink $item;
    }
}

print("\nMCNP Output Removed\n")