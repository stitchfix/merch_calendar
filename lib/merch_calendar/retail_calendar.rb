require "date"

module MerchCalendar
  class RetailCalendar
  
    QUARTER_1 = 1
    QUARTER_2 = 2
    QUARTER_3 = 3
    QUARTER_4 = 4
    
    FOUR_WEEK_MONTHS = [2, 5, 8, 11]
    FIVE_WEEK_MONTHS = [3, 6, 9, 12]
    
    # The the first date of the retail year
    #
    # @param [Fixnum] year - the retail year
    # @return [Date] the first date of the retail year
    def end_of_year(year)
      year_end = Date.new((year + 1), 1, -1)
      wday = (year_end.wday + 1) % 7 

      if wday > 3
        year_end += 7 - wday
      else
        year_end -= wday
      end
      year_end
    end

    # The last date of the retail year
    #
    # @param [Fixnum] year - the retail year
    # @return [Date] the last date of the retail year
    def start_of_year(year)
      end_of_year(year - 1) + 1
    end

    # The starting date of the given merch month
    #
    # @param [Fixnum] year - the retail year
    # @param [Fixnum] merch_month - the nth month of the retail calendar
    # @return [Date] the start date of the merch month
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

    # The ending date of the given merch month
    #
    # @param [Fixnum] year - the retail year
    # @param [Fixnum] merch_month - the nth month of the retail calendar
    # @return [Date] the end date of the merch month
    def end_of_month(year, merch_month)
      if merch_month == 12
        end_of_year(year)
      else
        start_of_month(year, merch_month + 1) - 1
      end
    end

    # Returns the date that corresponds to the first day in the merch week
    #
    # @param [Fixnum] year - the retail year
    # @param [Fixnum] merch_month - the nth month of the retail calendar
    # @param [Fixnum] merch_week - the nth week of the merch month
    # @return [Date] the start date of the merch week
    def start_of_week(year, month, merch_week)
      start_of_month(year, month) + ((merch_week - 1) * 7)
    end

    # Returns the date that corresponds to the last day in the merch week
    #
    # @param [Fixnum] year - the retail year
    # @param [Fixnum] merch_month - the nth month of the retail calendar
    # @param [Fixnum] merch_week - the nth week of the merch month
    # @return [Date] the end date of the merch week
    def end_of_week(year, month, merch_week)
      start_of_month(year, month) + (6 + ((merch_week - 1) * 7))
    end

    # Return the starting date for a particular quarter
    #
    # @param [Fixnum] year - the retail year
    # @param [Fixnum] quarter - the quarter of the year, a number from 1 - 4
    # @return [Date] the start date of the quarter
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
    #
    # @param [Fixnum] year - the retail year
    # @param [Fixnum] quarter - the quarter of the year, a number from 1 - 4
    # @return [Date] the end date of the quarter
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
    
    #Returns the season given for the merch_month
    #
    # @param [Fixnum]  merch_month - the nth month of the retail calendar
    # @return [String] the season that the merch_month falls under
    def season(merch_month)
      case merch_month
      when 1,2,3,4,5,6
        "Spring/Summer"
      when 7,8,9,10,11,12
        "Fall/Winter"
      end
    end

    # Returns the number of weeks in the retail year
    #
    # @param [Fixnum] year - the retail year
    # @return [Fixnum] the number of weeks within the retail year
    def weeks_in_year(year)
      ((start_of_year(year + 1) - start_of_year(year)) / 7).to_i
    end

    # Given any julian date it will return what retail year it belongs to
    #
    # @param [Date] the julian date to convert to its Retail Year
    # @return [Fixnum] the retail year that the julian date falls into
    def merch_year_from_date(date) #Jan 22 2017
      date_end_of_year = end_of_year(date.year)
      date_start_of_year = start_of_year(date.year) 
      return date.year - 1 if date < date_start_of_year

      if date >= date_start_of_year && date <= date_end_of_year
        date.year
      else
        date.year + 1
      end
    end
    ### IMPORTANT COVER TESTS PLEASE!!!
    
    # Converts a merch month to the correct julian month
    #
    # @param  [Fixnum] the merch month to convert
    # @return [Fixnum] the julian month
    def merch_to_julian(merch_month)
      if merch_month > 12 || merch_month <= 0
        raise ArgumentError
      end
      if merch_month == 12
        1
      else
        merch_month + 1
      end
    end
    
    # Converts a julian month to a merch month
    #
    # @param  [Fixnum] the julian month to convert
    # @return [Fixnum] the merch month
    def julian_to_merch(julian_month)
      if julian_month > 12 || julian_month <= 0
        raise ArgumentError
      end
      if julian_month == 1
        12
      else
        julian_month - 1
      end
    end
    
    # Given beginning and end dates it will return an array of Retail Month's Start date
    #
    # @param start_date [Date] the starting date
    # @param end_date [Date] the ending date
    # @return [Array] Array of start dates of each Retail Month from given dates
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
    
    # Returns an array of Merch Weeks that pertains to the Julian Month of a Retail Year
    #
    # @param year [Fixnum] the Retail year
    # @param month_param [Fixnum] the julian month
    # @return [Array] Array of MerchWeeks 
    def weeks_for_month(year, month_param)
      merch_month = get_merch_month_param(month_param)

      start_date = start_of_month(year, merch_month)

      weeks = (end_of_month(year, merch_month) - start_date + 1) / 7

      (1..weeks).map do |week_num|
        week_start = start_date + ((week_num - 1) * 7)
        week_end = week_start + 6

        MerchWeek.new(week_start, { 
          start_of_week: week_start, 
          end_of_week: week_end, 
          week: week_num, 
          calendar: RetailCalendar.new
        })
      end
    end
    
    private

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

  end
end
