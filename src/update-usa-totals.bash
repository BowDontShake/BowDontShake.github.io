#! /bin/bash

# Update the total COVID-19 counts for USA, located
# in covid-19-usa-totals.csv .  This script assumes that
# you have already cloned the Johns-Hopkins (JHU) github repo at
# https://github.com/CSSEGISandData/COVID-19 .
#
# Run this from the parent directory (not from the src directory):
#
#	bash update-usa-totals.bash

# Author: David Booth
# License: CC0

# Refresh COVID-19 data from Johns-Hopkins github repo.
# Assuming that cloned JHU repo is already in this directory:
pushd ~/covid19/COVID-19/csse_covid_19_data/csse_covid_19_time_series
git pull
popd

# Add up the USA daily counts.  The result is a CSV file with only 
# a header row and one data row, with the totals for all USA areas.
perl ./total-usa.perl ~/covid19/COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv > covid-19-usa-totals.csv 

