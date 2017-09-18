# Merch Calendar

[![Gem Version](https://badge.fury.io/rb/merch_calendar.svg)](http://badge.fury.io/rb/merch_calendar)
[![Build Status](https://travis-ci.org/stitchfix/merch_calendar.svg?branch=master)](https://travis-ci.org/stitchfix/merch_calendar)
[![Code Climate](https://codeclimate.com/github/stitchfix/merch_calendar/badges/gpa.svg)](https://codeclimate.com/github/stitchfix/merch_calendar)
[![Coverage Status](https://coveralls.io/repos/stitchfix/merch_calendar/badge.svg)](https://coveralls.io/r/stitchfix/merch_calendar)

This gem allows for finding retail/merchandising weeks for a given date, along with manipulating the retail calendar. 
This gem is used at [Stitch Fix](http://www.stitchfix.com/).

## Installation

```bash
$ gem install merch_calendar
```

Add the following line to your `Gemfile`:
```ruby
gem "merch_calendar"
```

## Ruby Version Compatibility
This gem has been tested against Ruby 2.0 - 2.4.

Support for Ruby 1.9.3 was discontinued as of version 0.3.0 of this gem.  If you're on Ruby 1.9.3, you'll want to 
install the gem like so:

```ruby
gem "merch_calendar", "0.3.0"
```

## Usage

For converting a date into a `MerchWeek` object.

```ruby
merch_week = MerchCalendar::MerchWeek.from_date("2014-01-01", calendar: MerchCalendar::RetailCalendar.new)

merch_week.year                 # 2013 (the merch year associated with this date)
merch_week.month                # 12 (the julian month that the date falls in)
merch_week.week                 # 5 (the week number within the month)
merch_week.year_week            # 48 (the week number within the retail calendar year)
merch_week.quarter              # 4

merch_week.start_of_week        # <Date: 2013-12-29>
merch_week.end_of_week          # <Date: 2014-01-04>

merch_week.start_of_month       # <Date: 2013-12-01>
merch_week.end_of_month         # <Date: 2014-01-04>

merch_week.start_of_year        # <Date: 2013-02-03>
merch_week.end_of_year          # <Date: 2014-02-01>

merch_week.calendar             # <MerchCalendar::RetailCalendar> (the calendar we're using)
                                # if you don't initialize a calendar, it defaults to RetailCalendar

# Formatting
merch_week.to_s                 # "Dec W5"
merch_week.to_s(:short)         # "Dec W5"
merch_week.to_s(:long)          # "2013:48 Dec W5"
merch_week.to_s(:elasticsearch) # "2013-12w05"
```


### Merch retail calendar

Retail calendars have their first month in February, and the last (12th) month is in January of the
following year.

```ruby
# This is asking "In the Merch year of 2014, what is the Gregorian calendar date of
# the start of the first month?"
retail_calendar = MerchCalendar::RetailCalendar.new

retail_calendar.start_of_month(2014, 1)
# => 2014-02-02

retail_calendar.start_of_month(2014, 12)
# => 2015-01-04
```

This table should describe the progression of dates:

| N   |  `start_of_month(2014, N)` |
| ------------- | ------------- |
| 1   | 2014-02-02 |
| 2   | 2014-03-02 |
| 3   | 2014-04-06 |
| 4   | 2014-05-04 |
| 5   | 2014-06-01 |
| 6   | 2014-07-06 |
| 7   | 2014-08-03 |
| 8   | 2014-08-31 |
| 9   | 2014-10-05 |
| 10  | 2014-11-02 |
| 11  | 2014-11-30 |
| 12  | 2015-01-04 |


Other useful methods:

```ruby
# 52 or 53 (depending on leap year)
retail_calendar.weeks_in_year(2016)
# => 52
retail_calendar.weeks_in_year(2017)
# => 53

# get the start date of a given merch week
retail_calendar.start_of_week(2017, 4, 1)
# => #<Date: 2017-04-30 ((2457874j,0s,0n),+0s,2299161j)>

# get the end date of a given merch week
retail_calendar.end_of_week(2017, 4, 1)
#=> #<Date: 2017-05-06 ((2457880j,0s,0n),+0s,2299161j)>
```

### Stitch Fix Fiscal Year Calendars
Some companies, one of which being Stitch Fix, operate on a fiscal year calendar that instead starts in August 
rather than in February in a the traditional retail calendar.  The `MerchCalendar::StitchFixFiscalYearCalendar` class 
allows you to easily translate Gregorian dates to a Stitch Fix Fiscal Year date.

```ruby
fiscal_calendar = MerchCalendar::StitchFixFiscalYearCalendar.new

fiscal_calendar.weeks_in_year(2018)
# => 52
fiscal_calendar.weeks_in_year(2019)
# => 53

# get the start date of a given merch week
fiscal_calendar.start_of_week(2017, 1, 1)
# => #<Date: 2016-07-31 ((2457601j,0s,0n),+0s,2299161j)>

# get the end date of a given merch week
fiscal_calendar.end_of_week(2017, 4, 1)
#=> #<Date: 2017-05-06 ((2457880j,0s,0n),+0s,2299161j)>
```

#### Stitch Fix Fiscal Year Calendar in Relation to MerchWeek object
You can set MerchWeek object respond to the Stitch Fix Fiscal Calendar, by passing in `StitchFixFiscalYearCalendar.new` in the calendar parameter:

```ruby
merch_week = MerchCalendar::MerchWeek.from_date("2018-07-02", calendar: MerchCalendar::StitchFixFiscalYearCalendar.new)

merch_week.year                 # 2018 (the merch year associated with this date)
merch_week.month                # 7 (the julian month that the date falls in)
merch_week.merch_month          # 12 (this fiscal month the date falls in)
merch_week.week                 # 1 (the week number within the month)
merch_week.year_week            # 49 (the week number within the retail calendar year)
merch_week.quarter              # 4

merch_week.start_of_week        # <Date: 2018-07-01>
merch_week.end_of_week          # <Date: 2018-07-07>

merch_week.start_of_month       # <Date: 2018-07-01>
merch_week.end_of_month         # <Date: 2018-07-28>

merch_week.start_of_year        # <Date: 2017-07-30>
merch_week.end_of_year          # <Date: 2018-07-28>

merch_week.calendar             # <MerchCalendar::StitchFixFiscalYearCalendar> (the calendar
                                # we're using)
                                # if you don't initialize a calendar, it defaults to RetailCalendar

# Formatting
merch_week.to_s                 # "Jul W1"
merch_week.to_s(:short)         # "Jul W1"
merch_week.to_s(:long)          # "2018:49 Jul W1"
merch_week.to_s(:elasticsearch) # "2018-07w01"
```

## Documentation
You can view the documentation for this gem on [RubyDoc.info](http://www.rubydoc.info/github/stitchfix/merch_calendar/master).

## License
MerchCalendar is released under the [MIT License](http://www.opensource.org/licenses/MIT).
