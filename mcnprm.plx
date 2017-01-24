#!usr/bin/perl
use warnings;
use strict;

# By Corey Skinner

# Relative directory
my $dir = ".";

opendir DIR,$dir or die "can't open $dir: $!";
my @dir = readdir(DIR);
close DIR;

foreach my $item (@dir)
{
    if ($item =~ /^(out\w)|(runtp\w)|(srct\w)|(comou\w)|(meshta\w)|(mcta\w)$/)
    {
        unlink $item;
    }
}

print("\nMCNP Output Removed\n")