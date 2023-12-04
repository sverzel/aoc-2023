#!/usr/bin/perl -w

use strict;
use List::Util qw(sum);

my ($input) = $0 =~ /^([^.]+)/;
$input .= '_input';

open my $fh, $input or die $!;

my $s1 = 0;
my %cards;
while (my $line = <$fh>) {
    my $p = sum(map $line =~ /^Card\s+\d+:\s.*\b$_\b.*\|/, grep /\d/, split /\s+/, join '', map $_, $line =~ /\|(.*)$/) || 0;
    
    $s1 += ($p ? 2**($p-1) : 0);
    
    my ($c) = $line =~ /^Card\s+(\d+):/;
    $cards{$c}++;
    $cards{$c+$_+1} += $cards{$c} for 0 .. $p-1;
}

print "Points in total: $s1\n";
print "Total scratchcards: ", sum(map $cards{$_}, keys %cards), "\n";
