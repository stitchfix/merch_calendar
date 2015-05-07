# Merch Calendar

This gem allows for finding merch weeks for a given date, along with manipulating the retail calendar.

## Installation

```bash
$ gem install merch_calendar
```

Add the following line to your `Gemfile`:
```ruby
gem "merch_calendar"
```


## Configuration
**NOTE: THIS IS NOT UTILIZED RIGHT NOW**
```ruby
MerchCalendar.configure do |config|
  # The month that Q1 begins. The default is 8 (August)
  config.quarter_start_month = 8
end
```

## Usage

For converting a date into a `MerchWeek` object.

```ruby
merch_week = MerchCalendar::MerchWeek.from_date("2014-01-01")
puts merch_week.year # 2013 (the merch year associated with this date)
puts merch_week.month # 12 (the julian month that the date falls in)
puts merch_week.week # 5 (the week number within the month)
puts merch_week.year_week # 48 (the week number within the year)
puts merch_week.quarter # 2

puts merch_week.start_of_week # <Date: 2013-12-29>
puts merch_week.end_of_week # <Date>

puts merch_week.start_of_month # <Date>
puts merch_week.end_of_month # <Date>

puts merch_week.start_of_quarter # <Date>
puts merch_week.end_of_quarter # <Date>

puts merch_week.start_of_year # <Date>
puts merch_week.end_of_year # <Date>

# Formatting
puts merch_week.to_s # "Dec W5"
puts merch_week.to_s(:short) # "Dec W5"
puts merch_week.to_s(:long) # "2013:48 Dec W5"
puts merch_week.to_s(:elasticsearch) # "2013-12w05"
```

This can also be used on the `MerchCalendar` module. All `start_` and `end_` methods can be called, along with a few additional ones.

```ruby
# All examples below return a Date object for the start of May within the 2014 merch year
MerchCalendar.start_of_month(2014, 5)
MerchCalendar.start_of_month(2014, month: 5)
MerchCalendar.start_of_month(2014, julian_month: 5)

# This is the same as May, because "Merch" months are shifted by 1.
# i.e. month 1 is actually February
# You probably will never use this, but it is available.
MerchCalendar.start_of_month(2014, merch_month: 4)
```

Other useful methods:

```ruby
# 52 or 53 (depending on leap year)
MerchCalendar.weeks_in_year(2015)

# returns an array of MerchWeek objects for each week within the provided month
MerchCalendar.weeks_for_month(2014, 1)
```


## Roadmap
* More detailed Yardoc
* Support for 4-4-5 calendars

## License
MerchCalendar is released under the [MIT License](http://www.opensource.org/licenses/MIT).
