#!/usr/bin/perl -w

use strict;
use List::Util qw(sum);

my @g;
{
    local $/;
    open my $fh, ($0 =~ /^([^.]+)/)[0] . '_input' or die $!;
    push @g, map [split //], split "\n", <$fh>;
}

my @part_numbers;
for (my $y = 0; $y < 140; $y++) {
    for (my $x = 0; $x < 140; $x++) {
	if ($g[$y][$x] =~ /[^\d\.]/) {
	    warn "Found '$g[$y][$x]' at $x, $y\n";
	    foreach my $dy(-1 .. 1) {
	      scope: foreach my $dx(-1 .. 1) {
		  if ($g[$y+$dy][$x+$dx] =~ /\d/) {
		      my $s = $dx;
		      my $n = '';
		      1 while ($x+ --$s >= 0 && $g[$y+$dy][$x+$s] =~ /\d/);
		      $n .= $g[$y+$dy][$x+$s] while ($x+ ++$s < 140 && $g[$y+$dy][$x+$s] =~ /\d/);
		      warn "Found part number $n\n";
		      push @part_numbers, $n;
		      last scope if $s > 0;
		  }
	      }
	    }
	}
    }
}

print "Sum of part numbers: ", sum(@part_numbers), "\n";
