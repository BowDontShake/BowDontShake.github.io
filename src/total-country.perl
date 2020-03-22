#! /usr/bin/perl -w

# Total COVID-19 counts for USA.

# Usage:
#
#	perl src/total-usa.perl US < time_series_19-covid-Confirmed.csv > covid-19-usa-totals.csv 
#	perl src/total-usa.perl China < time_series_19-covid-Confirmed.csv > covid-19-china-totals.csv 
#
# Input is CSV with header, like this:
#
#	Province/State,Country/Region,Lat,Long,1/22/20,1/23/20
#	Guangdong,China,23.3417,113.4244,26,32
#	,"Korea, South",36,128,1,1
#	"Solano, CA",US,38.3105,-121.9018,0,0
#	Puerto Rico,US,18.2208,-66.5901,0,0

# Author: David Booth
# License: CC0

# Argument should be "US", "China" or some other country name.
my $country = shift @ARGV || die;
die if $country =~ m/,/;
my $qCountry = quotemeta($country);

my @total = ();
my $header = <>;
chomp $header;
$header =~ s/\s+$//;

# Count the dates in the header, for error checking.
my $dates = $header;
# Delete the first four fields:
die if $dates !~ s/^[^,]*,[^,]*,[^,]*,[^,]*,//i;
my @dates = split(/\s*,\s*/, $dates);
my $nDates = scalar(@dates);

while (my $line = <>) {
	chomp $line;
	# We can get away with not worrying about quoted fields,
	# because they only appear in the first column.
	# Ignore empty lines:
	next if $line !~ m/\S/;		
	# Skip non-US and trim off the first four columns:
	next if $line !~ s/^.*,\s*$qCountry\s*,[^,]*,[^,]*,//i;
	# Delete leading and trailing whitespace:
	$line =~ s/^\s+//;
	$line =~ s/\s+$//;
	# Split to fields and add to totals:
	my @count = split(/\s*,\s*/, $line);
	die if $nDates != scalar(@count);
	for (my $i=0; $i<@count; $i++) {
		$total[$i] += $count[$i];
	}
}

my $totals = join(",", @total);
print "$header\n";
print "All,$country,,,$totals\n";
exit 0;

