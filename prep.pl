#!/usr/bin/perl
use strict; use warnings;

use Path::Class;
use autodie; # die if problem reading or writing a file

my $infile = file($ARGV[0])->openr();
my $outfile = file("$ARGV[0].prep")->openw();

while (my $line = <>)
{
    $line = remove_metas($line);
    $line = remove_track_markers($line);
    $line = remove_irrelevant($line);
    $line = remove_empty_lines($line);
    $line = fix_mfile($line);
    $outfile->print($line);
}

$outfile->print("TrkEnd\n");

sub fix_mfile
{
    my($string) = @_;
    $string =~ s/MFile (\d+) \d+ (\d+)/MFile $1 1 $2\nMTrk/g;
    return $string;
}

sub remove_metas
{
    my($string) = @_;
    $string =~ s/\d+ Meta.*//g;
    return $string;
}

sub remove_empty_lines
{
    my($string) = @_;
    $string =~ s/^\n//g;
    return $string;
}

sub remove_track_markers
{
    my($string) = @_;
    $string =~ s/MTrk|TrkEnd//g;
    return $string;
}

sub remove_irrelevant
{
    my($string) = @_;
    $string =~ s/^.*(TimeSig|KeySig|Tempo|SeqSpec|SMPTE|Pb|PrCh).*$//g;
    return $string;
}
