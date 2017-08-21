require "date"

module MerchCalendar
  class RetailCalendar
    QUARTER_1 = 1
    QUARTER_2 = 2
    QUARTER_3 = 3
    QUARTER_4 = 4
    
    FOUR_WEEK_MONTHS = [2, 5, 8, 11]
    FIVE_WEEK_MONTHS = [3, 6, 9, 12]

    def end_of_year(year)
      year_end = Date.new((year + 1), 1, -1) # Jan 31st
      wday = (year_end.wday + 1) % 7 

      if wday > 3 # this rounds up to the next saturday 
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
      when  *FOUR_WEEK_MONTHS
        # 28 = 4 weeks
        start = start + 28
      when *FIVE_WEEK_MONTHS
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
    
    #this is expecting to submit a gregorian year and a gregorian month 
    #and for it to return the merch weeks within the month
    def weeks_for_month(year, month_param)
      merch_month = get_merch_month_param(month_param)
      
      #gets the start_date of the merch_month
      start_date = start_of_month(year, merch_month)
      
      #gets the number of weeks given start_date and given end_date and divided by 7 
      weeks = (end_of_month(year, merch_month) - start_date + 1) / 7
      
      #with each number of weeks it creates a hash that has an array of weeks and their start date and end date of each week
      (1..weeks).map do |week_num|
        week_start = start_date + ((week_num - 1) * 7)
        week_end = week_start + 6
        MerchWeek.new(week_start, { start_of_week: week_start, end_of_week: week_end, week: week_num, calendar: RetailCalendar.new })
      end
    end
    
    def get_merch_month_param(param)
      if param.is_a? Fixnum
        return julian_to_merch(param)
      elsif param.is_a? Hash
        julian_month = param.delete(:julian_month) || param.delete(:month)
        merch_month = param.delete(:merch_month)

        if merch_month
          return merch_month
        elsif julian_month
          return julian_to_merch(julian_month)
        end
      end

      raise ArgumentError
    end
    
    def julian_to_merch(julian_month)
      if julian_month == 1
        12
      else
        julian_month - 1
      end
    end

  end
end
