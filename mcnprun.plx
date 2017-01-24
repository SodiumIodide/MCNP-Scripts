#! /usr/bin/perl
use warnings;
use strict;
use Cwd;
use File::Temp;
use File::Copy;

# By Corey Skinner

# Word to match with input files
my $keyword = "_in";
# Word to NOT match with input files
my $nullword = "_key";
# Program to call
my $prog = "mcnp6";
# Relative directory to call
my $dir = ".";

print "\nThis script will call $prog to execute any and all files containing";
print "\nthe characters \"$keyword\", except those containing the characters";
print "\n\t\"$nullword\".\n";
print "\nNOTE: Ensure that you are running from within the $prog command window,";
print "\n\telse exit the execution of this script with Ctrl/Cmd+C.\n";
print "\nPress Enter to execute. Press 1 and Enter for a system tone at the\n";
print "\tend of runs.\n";
my $input = <>;
chomp $input;
my $tf;
if ($input eq "1")
{
    $tf = 1;
}
else
{
    $tf = 0;
}

print "\nEnter \"tasks\"/threads to execute:\n";
my $tasks = <>;
chomp $tasks;

# Read directory
opendir DIR,$dir or die "can't opendir $dir: $!";
my @dir = readdir(DIR);
close DIR;

my $oldcwd = getcwd;
my $tdir = File::Temp->newdir;

foreach my $item (@dir)
{
    # If $keyword is in the item
    if ($item =~ /$keyword/)
    {
        # If $nullword is NOT in the item containing $keyword
        if ($item =~ /^((?!$nullword).)*$/)
        {
            copy($item, $tdir . "/" . $item);
            chdir $tdir;
            system("$prog", "i=$item", "tasks $tasks");
            opendir TDIR,$tdir or die "can't opendir $tdir: $!";
            my @tfiles = readdir(TDIR);
            close TDIR;
            foreach my $titem (@tfiles)
            {
                if ($titem =~ /outp/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_out.txt");
                }
                elsif ($titem =~ /runtpe/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_run");
                }
                elsif ($titem =~ /srctp/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_src");
                }
                elsif ($titem =~ /comout/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_com.txt");
                }
                elsif ($titem =~ /meshtal/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_mesh.txt");
                }
                elsif ($titem =~ /mctal/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_mc.txt");
                }
                elsif ($titem =~ /ptrac/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_ptrac.txt");
                }
                elsif ($titem =~ /wwout/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_wwout.txt");
                }
                elsif ($titem =~ /wwone/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_wwone.txt");
                }
                elsif ($titem =~ /wxxa/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_wxxa");
                }
                elsif ($titem =~ /plotm/)
                {
                    copy($titem, $oldcwd . "/" . $item . "_plot.ps");
                }
            }
            chdir $oldcwd;
            unlink glob "'$tdir/*'";
        }
    }
}

print "\n**************************************";
print "\nDone\n";
print "**************************************\n";

if ($tf)
{
    $| = 1;
    print "\a";
    sleep(1);
    print "\a";
    sleep(1);
    print "\a";
}

__END__