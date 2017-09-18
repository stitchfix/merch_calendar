module MerchCalendar
  class StitchFixFiscalYearCalendar

    QUARTER_1 = 1
    QUARTER_2 = 2
    QUARTER_3 = 3
    QUARTER_4 = 4
    
    FOUR_WEEK_MONTHS = [2, 5, 8, 11]
    FIVE_WEEK_MONTHS = [3, 6, 9, 12]

    # The date of the first day of the fiscal year
    #
    # @param year [Integer] the fiscal year
    # @return [Date] the first date of the fiscal year
    def start_of_year(year)
      end_of_year(year - 1) + 1
    end

    # The date of the last day of the fiscal year
    #
    # @param year [Integer] the fiscal year
    # @return [Date] the last date of the fiscal year
    def end_of_year(year)
      year_end = Date.new((year), 7, -1) # Jul 31st
      wday = (year_end.wday + 1) % 7

      if wday > 3
        year_end += 7 - wday
      else
        year_end -= wday
      end
      year_end
    end

    # Return the starting date for a particular quarter
    #
    # @param year [Integer] the fiscal year
    # @param quarter [Integer] the quarter of the year, a number from 1 - 4
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
      else
        raise "invalid quarter"
      end
    end
    
    # Returns the quarter that the merch month falls in
    #
    # @param merch_month [Integer] merch month
    # @return [Date] the quarter that the merch_month falls in
    def quarter(merch_month)
      case merch_month
      when 1,2,3
        return QUARTER_1
      when 4,5,6
        return QUARTER_2
      when 7,8,9
        return QUARTER_3
      when 10,11,12
        return QUARTER_4
      else
        raise "invalid merch month"
      end
    end

    # Return the ending date for a particular quarter
    #
    # @param year [Integer] the fiscal year
    # @param quarter [Integer] the quarter of the year, a number from 1 - 4
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
      else
        raise "invalid quarter"
      end
    end

    #Returns the season given for the merch_month
    #
    # @param  merch_month [Integer] the nth merch month of the retail calendar
    # @return [String] the season that the merch month falls under
    def season(merch_month)
      case merch_month
      when 1,2,3,4,5,6
        "Fall/Winter"
      when 7,8,9,10,11,12
        "Spring/Summer"
      else
        raise "invalid merch month"
      end
    end

    # The starting date of the given merch month
    #
    # @param year [Integer] the fiscal year
    # @param merch_month [Integer] the nth merch month of the fiscal calendar
    # @return [Date] the start date of the merch month
    def start_of_month(year, merch_month)
      # 91 = number of days in a single 4-5-4 set 
      start = start_of_year(year) + ((merch_month - 1) / 3).to_i * 91

      case merch_month
      when *FOUR_WEEK_MONTHS
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
    # @param year [Integer] the fiscal year
    # @param merch_month [Integer] the nth merch month of the fiscal calendar
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
    # @param year [Integer] the fiscal year
    # @param merch_month [Integer] the nth month of the fiscal calendar
    # @param merch_week [Integer] the nth week of the merch month
    # @return [Date] the start date of the merch week
    def start_of_week(year, month, merch_week)
      start_of_month(year, month) + ((merch_week - 1) * 7)
    end

    # Returns the date that corresponds to the last day in the merch week
    #
    # @param  year [Integer] the fiscal year
    # @param  merch_month [Integer] the nth merch month of the fiscal calendar
    # @param  merch_week [Integer] the nth week of the merch month
    # @return [Date] the end date of the merch week
    def end_of_week(year, month, merch_week)
      start_of_month(year, month) + (6 + ((merch_week - 1) * 7))
    end

    # Returns the number of weeks in the fiscal year
    #
    # @param year [Integer] the fiscal year
    # @return [Integer] the number of weeks within the fiscal year
    def weeks_in_year(year)
      ((start_of_year(year + 1) - start_of_year(year)) / 7).to_i
    end

    # Given any julian date it will return what Fiscal Year it belongs to
    #
    # @param date [Date] the julian date to convert to its Fiscal Year
    # @return [Integer] the fiscal year that the julian date falls into
    def merch_year_from_date(date)
      if end_of_year(date.year) >= date
        return date.year
      else
        return date.year + 1
      end
    end

    # Converts a merch month to the correct julian month
    #
    # @param merch_month [Integer] the merch month to convert
    # @return [Integer] the julian month
    def merch_to_julian(merch_month)
      if merch_month > 12 || merch_month <= 0
        raise ArgumentError
      end

      if merch_month <= 5
        merch_month + 7
      else
        merch_month - 5
      end
    end

    # Converts a julian month to a fiscal month
    #
    # @param julian_month [Integer] the julian month to convert
    # @return [Integer] the merch month
    def julian_to_merch(julian_month)
      if julian_month > 12 || julian_month <= 0
        raise ArgumentError
      end

      if julian_month <= 7
        julian_month + 5
      else
        julian_month - 7
      end
    end
    
    # Given beginning and end dates it will return an array of Fiscal Month's Start date
    #
    # @param start_date [Date] the starting date
    # @param end_date [Date] the ending date
    # @return [Array] Array of start dates of each Fiscal Month from given dates
    def merch_months_in(start_date, end_date) 
      merch_months_combos = merch_year_and_month_from_dates(start_date, end_date)
      merch_months_combos.map { | merch_month_combo | start_of_month(merch_month_combo[0], merch_month_combo[1]) }
    end

    # Returns an array of Merch Weeks that pertains to the Julian Month of a Fiscal Year
    #
    # @param year [Integer] the fiscal year
    # @param month_param [Integer] the julian month
    # @return [Array] Array of MerchWeeks that falls within that julian month
    def weeks_for_month(year, month_param)
      merch_month = julian_to_merch(month_param)
      
      start_date = start_of_month(year, merch_month)
      
      weeks = (end_of_month(year, merch_month) - start_date + 1) / 7
      
      (1..weeks).map do |week_num|
        week_start = start_date + ((week_num - 1) * 7)
        week_end = week_start + 6

        MerchWeek.new(week_start, { 
          start_of_week: week_start, 
          end_of_week: week_end, 
          week: week_num, 
          calendar: StitchFixFiscalYearCalendar.new 
        })
      end
    end

    private
    
    # Returns an array of merch_months and year combination that falls in and between the start and end date
    # 
    # Ex: if start_date = August 1, 2018 and end_date = October 1, 2018
    # it returns [[2019, 1], [ 2019, 2], [2019, 3]] 
    def merch_year_and_month_from_dates(start_date, end_date)
      merch_months = []

      middle_of_start_month = Date.new(start_date.year, start_date.month, 14)
      middle_of_end_month = Date.new(end_date.year, end_date.month, 14)
      date = middle_of_start_month
        
      while date <= middle_of_end_month do
        merch_months.push(date_conversion(date))
        date = date >> 1
      end
      merch_months
    end
 
    # This isn't a true date conversion, only used for merch_year_and_month_from_dates
    # when its julian month actually falls in the wrong merch year
    # EX: The true date_conversion of July 1, 2018 => [ 2019, 1 ]
    # BUT this method here will return [2019, 12] because July is merch_month 12 for fiscal year
    def date_conversion(date)
      [ merch_year_from_date(date), julian_to_merch(date.month) ]
    end
  end
end
