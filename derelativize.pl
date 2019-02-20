#!/usr/bin/perl
use strict; use warnings;

use Path::Class;
use autodie; # die if problem reading or writing a file

#my $outfile = file("$ARGV[0].rel")->openw();
my $previous = 0;
my $rel_num = 0;
my $to_replace = 0;
while (my $line = <>)
{
    if ($line =~ /^\d+/)
    {
       ($rel_num) = $line =~ /^(\d+)/;   # 123
       $to_replace = $rel_num + $previous;
       $previous = $to_replace;
       $line =~ s/^\d+/$to_replace/;
    }
    
    
    if ($line =~ /n/) 
    {
       $line =~ s/n/ch=1 n=/;
    }
    
    if ($line =~ /Y/) 
    {
       $line =~ s/Y/ On /;
    } elsif ($line =~ /N/) 
    {
       $line =~ s/N/ Off /;
    } elsif ($line =~ /P/) 
    {
       $line =~ s/P/ Par ch=1 c=64/;
    }
    
    $line =~ s/\+/ v=80/;
    $line =~ s/-/ v=0/;
    $line =~ s/\*/ v=127/;
    $line =~ s/:/ v=1/;

    if ($line =~ /[A-G]/) {
       $line =~ s/([A-G])/$1z/;
       $line =~ s/z/#/;
       $line =~ s/([A-G])/lc($1)/e;
    }
    
    if ($line =~ /M/) 
    {
       $line =~ s/M/MFile 1 1 /;
    }
    
    $line =~ s/}/TrkEnd/;
    $line =~ s/{/MTrk/;
    
    print($line);
}
