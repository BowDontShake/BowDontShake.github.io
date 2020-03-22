#! /usr/bin/perl -w

# Total COVID-19 counts for USA.

# Input is CSV with header, like this:
#
#	Province/State,Country/Region,Lat,Long,1/22/20,1/23/20
#	Guangdong,China,23.3417,113.4244,26,32
#	,"Korea, South",36,128,1,1
#	"Solano, CA",US,38.3105,-121.9018,0,0
#	Puerto Rico,US,18.2208,-66.5901,0,0

# Author: David Booth
# License: CC0

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
	next if $line !~ s/^.*,\s*US\s*,[^,]*,[^,]*,//i;
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
print "All,US,$totals\n";
exit 0;

