#!/usr/bin/perl -w

use strict;
use List::Util qw(min);
use Data::Dumper;

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

my @locations;
foreach my $s (@seeds) {
    my $key = $s;
    foreach my $map(@tr) {
	foreach my $tr( @{$map->{values}} ) {
	    if ($key >= $tr->[1] and $key < $tr->[1] + $tr->[2]) {
		$key = $tr->[0] + ($key - $tr->[1]);
		push @locations, $key if $map->{name} eq 'humidity-to-location';
		last;
	    }
	}

	push @locations, $key if $map->{name} eq 'humidity-to-location';
    }
}

print "Lowest location number: ", min(@locations), "\n";
