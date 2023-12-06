#!/usr/bin/perl -w

use strict;
use List::Util qw(min);

my ($input) = $0 =~ /^([^.]+)/;
$input .= '_input';

my (@seeds, @tr);
{
    local $/;
    open my $fh, ($0 =~ /^([^.]+)/)[0] . '_input' or die $!;

    my @s = grep /^./, grep defined, <$fh> =~ /^(.*): (.+)$|^(.*) map:|^(.*)$/mg;
    @seeds = split /\s+/, $s[1];
    my $k;
    my @t;
    foreach (@s[2 .. @s-1]) {
	if (/^\D/) {
	    push @tr, {name => $k, values => [@t]} if $k;
	    @t = ();
	    $k = $_;
	}
	else {
	    push @t, [split /\s+/];
	}
    }

    push @tr, {name => $k, values => [@t]} if $k;
}

sub seed_to_location {
    my $key = shift;
    foreach my $map(@tr) {
	foreach my $tr( @{$map->{values}} ) {
	    if ($key >= $tr->[1] and $key < $tr->[1] + $tr->[2]) {
		$key = $tr->[0] + ($key - $tr->[1]);
		return $key if $map->{name} eq 'humidity-to-location';
		last;
	    }
	}
	
	return $key if $map->{name} eq 'humidity-to-location';
    }
}

my @locations;
@locations = min(@locations, seed_to_location($_)) foreach @seeds;

print "Lowest location number: ", min(@locations), "\n";

my @seed_ranges;
push @seed_ranges, [splice @seeds, 0, 2] while @seeds;

@locations = ();
foreach my $sr (@seed_ranges) {
    for (my $s = $sr->[0]; $s < $sr->[0]+$sr->[1]; $s++) {
	@locations = min(@locations, seed_to_location($s));
    }
}

print "Lowest location number: ", min(@locations), "\n";
