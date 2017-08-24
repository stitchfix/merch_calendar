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
    # @param [Fixnum] year - the fiscal year
    # @return [Date] the first date of the fiscal year
    def start_of_year(year)
      end_of_year(year - 1) + 1
    end

    # The date of the last day of the year
    #
    # @param [Fixnum] year - the fiscal year
    # @return [Date] the last date of the fiscal year
    def end_of_year(year)
      year_end = Date.new((year), 7, -1)
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
    # @param [Fixnum] year - the fiscal year
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
    # @param [Fixnum] year - the fiscal year
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

    # The first date of the merch month
    #
    # @param [Fixnum] year - the fiscal year
    # @param [Fixnum] merch_month - the nth month of the fiscal calendar
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

    # The last date of the merch month
    #
    # @param [Fixnum] year - the fiscal year
    # @param [Fixnum] merch_month - the nth month of the fiscal calendar
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
    # @param [Fixnum] year - the fiscal year
    # @param [Fixnum] merch_month - the nth month of the fiscal calendar
    # @param [Fixnum] merch_week - the nth week of the merch month
    # @return [Date] the start date of the merch week
    def start_of_week(year, month, merch_week)
      start_of_month(year, month) + ((merch_week - 1) * 7)
    end

    # Returns the date that corresponds to the last day in the merch week
    #
    # @param [Fixnum] year - the fiscal year
    # @param [Fixnum] merch_month - the nth month of the fiscal calendar
    # @param [Fixnum] merch_week - the nth week of the merch month
    # @return [Date] the end date of the merch week
    def end_of_week(year, month, merch_week)
      start_of_month(year, month) + (6 + ((merch_week - 1) * 7))
    end

    # Returns the number of weeks in the fiscal year
    #
    # @param [Fixnum] year - the fiscal year
    # @return [Fixnum] the number of weeks within the fiscal year
    def weeks_in_year(year)
      ((start_of_year(year + 1) - start_of_year(year)) / 7).to_i
    end
    
    # Converts a merch month to the correct julian month
    #
    # @param merch_month [Fixnum] the merch month to convert
    # @return [Fixnum] the julian month
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

    # Given any julian date it will return what Fiscal Year it belongs to
    #
    # @param [Date] the julian date to convert to its Fiscal Year
    # @return [Fixnum] the fiscal year that the julian date falls into
    def merch_year_from_date(date)
      if end_of_year(date.year) >= date
        return date.year
      else
        return date.year + 1
      end
    end
    ### IMPORTANT ADD MORE GOOD TESTS FOR THIS METHOD ^^^^^^

    # Converts a julian month to a fiscal month
    #
    # @param julian_month [Fixnum] the julian month to convert
    # @return [Fixnum] the fiscal month
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
      merch_months_combos = merch_month_combo_from_dates(start_date, end_date)
      merch_months_combos.map { | merch_month_combo | start_of_month(merch_month_combo[0], merch_month_combo[1]) }
    end
    
    # Returns an array of Merch Weeks that pertains to the Julian Month of a Fiscal Year
    #
    # @param year [Fixnum] the fiscal year
    # @param month_param [Fixnum] the julian month
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

    def merch_month_combo_from_dates(start_date, end_date)
      merch_months = []

      first_of_start = Date.new(start_date.year, start_date.month, 14)
      first_of_end = Date.new(end_date.year, end_date.month, 14)
      date = first_of_start
        
      while date <= first_of_end do
        merch_months.push(date_conversion(date))
        date = date >> 1
      end
      merch_months
    end

    def date_conversion(date)
      [ merch_year_from_date(date), julian_to_merch(date.month) ]
    end
  end
end
