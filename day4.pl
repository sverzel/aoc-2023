#!/usr/bin/perl -w

use strict;
use List::Util qw(sum);

my ($input) = $0 =~ /^([^.]+)/;
$input .= '_input';

open my $fh, $input or die $!;

my $s1 = 0;
my %cards;
while (<$fh>) {
    my $p = 0;
    foreach my $t(grep /\d/, split /\s+/, join '', map $_, /\|(.*)$/) {
	$p++ if /^Card\s+\d+:\s.*\b$t\b.*\|/;
    }
    
    $s1 += ($p > 0 ? 2**($p-1) : 0);
    
    my ($c) = /^Card\s+(\d+):/;
    $cards{$c}++;
    for (my $n = 0; $n < $p; $n++) {
	$cards{$c+$n+1} += $cards{$c};
    }
}

print "Points in total: $s1\n";
print "Total scratchcards: ", sum(map $cards{$_}, keys %cards), "\n";
