require "date"

module MerchCalendar
  class RetailCalendar
    QUARTER_1 = 1
    QUARTER_2 = 2
    QUARTER_3 = 3
    QUARTER_4 = 4

    def end_of_year(year)
      year_end = Date.new((year + 1), 1, -1) # Jan 31st
      wday = (year_end.wday + 1) % 7 

      if wday > 3 ### this rounds up to the next saturday 
        year_end += 7 - wday
      else # rounding down to the next saturday
        year_end -= wday
      end
      year_end
    end

    # The day after last years' end date
    def start_of_year(year)
      end_of_year(year - 1) + 1
    end

    # The starting date of a given month
    # THIS IS THE MERCH MONTH
    # 1 = feb

    def start_of_month(year, merch_month)
      # 91 = number of days in a single 4-5-4 set 
      start = start_of_year(year) + ((merch_month - 1) / 3).to_i * 91

      case merch_month
      when 2,5,8,11
        # 28 = 4 weeks
        start = start + 28
      when 3,6,9,12
        # The 5 week months
        # 63 = 4 weeks + 5 weeks
        start = start + 63
      end
      
      start
    end

    def end_of_month(year, merch_month)
      if merch_month == 12
        end_of_year(year)
      else
        start_of_month(year, merch_month + 1) - 1
      end
    end

    # Returns the date that corresponds to the first day in the merch week
    def start_of_week(year, month, merch_week)
      start_of_month(year, month) + ((merch_week - 1) * 7)
    end

    # Returns the date that corresponds to the last day in the merch week
    def end_of_week(year, month, merch_week)
      start_of_month(year, month) + (6 + ((merch_week - 1) * 7))
    end

    # Return the starting date for a particular quarter
    def start_of_quarter(year, quarter)
      case quarter
      when QUARTER_1
        start_of_month(year, 1)
      when QUARTER_2
        start_of_month(year, 4)
      when QUARTER_3
        start_of_month(year, 7)
      when QUARTER_4
        start_of_month(year, 10)
      end
    end

    # Return the ending date for a particular quarter
    def end_of_quarter(year, quarter)
      case quarter
      when QUARTER_1
        end_of_month(year, 3)
      when QUARTER_2
        end_of_month(year, 6)
      when QUARTER_3
        end_of_month(year, 9)
      when QUARTER_4
        end_of_month(year, 12)
      end
    end

    # Return the number of weeks in a particular year
    def weeks_in_year(year)
      ((start_of_year(year + 1) - start_of_year(year)) / 7).to_i
    end

    def merch_months_in(start_date, end_date)
      merch_months = []
      prev_date = start_date - 2
      date = start_date
      while date <= end_date do
        date = MerchCalendar.start_of_month(date.year, merch_month: date.month)
        next if prev_date == date
        merch_months.push(date)
        prev_date = date
        date += 14
      end
      merch_months
    end
  end
end
