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

#warn Dumper(@tr);
#exit;

my @locations;
foreach my $s (@seeds) {
    warn "Seed: '$s'\n";
    my $key = $s;
    foreach my $map(@tr) {
	warn "Map: $map->{name}\n";
	foreach my $tr( @{$map->{values}} ) {
	    if ($key >= $tr->[1] and $key < $tr->[1] + $tr->[2]) {
		$key = $tr->[0] + ($key - $tr->[1]);
		warn "Key found in map '$map->{name}' for key '$key'\n";
		
		if ($map->{name} eq 'humidity-to-location') {
		    warn "Pushing location '$key'\n";
		    push @locations, $key;
		}

		last;
	    }
	}

	if ($map->{name} eq 'humidity-to-location') {
	    warn "Pushing locations\n";
	    push @locations, $key;
	}
    }
}

# 1259879174

warn Dumper(@locations);

print "Lowest location number: ", min(@locations), "\n";
