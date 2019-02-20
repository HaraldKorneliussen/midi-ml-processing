#!/usr/bin/perl
use strict; use warnings;

# Changes the file to make it more edible for an LSTM,
# In particular, changes times from absolute to deltas

use Path::Class;
use autodie; # die if problem reading or writing a file

#my $outfile = file("$ARGV[0].rel")->openw();
my $previous = 0;
my $abs_num = 0;
my $to_replace = 0;
while (my $line = <>)
{
    if ($line =~ /^\d+/) 
    {
       ($abs_num) = $line =~ /^(\d+)/;   # 123
       $to_replace = $abs_num - $previous;
       # can be negative
       $previous = $abs_num;
       $line =~ s/^\d+/$to_replace/;
    }
    
    if ($line =~ / On /) 
    {
       $line =~ s/ On /Y/;
    }
    
    if ($line =~ / Off /) 
    {
       $line =~ s/ Off /N/;
    }
    
    if ($line =~ / Par ch=1 c=\d+/) 
    {
       $line =~ s/ Par ch=1 c=\d+/P/;
    }
    
    if ($line =~ /ch=1 n=/) 
    {
       $line =~ s/ch=1 n=/n/;
    }
    
    if ($line =~ /MFile \d \d /) 
    {
       $line =~ s/MFile \d \d /M/;
    }
    
    if ($line =~ / v=\d+/) 
    {
       $line =~ s/ v=80/+/;
       $line =~ s/ v=0/-/;
       $line =~ s/ v=127/*/;
       $line =~ s/ v=1/:/;
    }
    
    $line =~ s/([a-g])\#/uc($1)/e;
    
    $line =~ s/TrkEnd/}/;
    $line =~ s/MTrk/{/;
    
    print($line);
}

