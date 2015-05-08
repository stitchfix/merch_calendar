module MerchCalendar

  # Utility methods for the merch calendar
  module Util

    # The start date of the month
    #
    # @example
    #  # The following are all equivalent, and refer to May 2015
    #  MerchCalendar.start_of_month(2015, 5)
    #  MerchCalendar.start_of_month(2015, month: 5)
    #  MerchCalendar.start_of_month(2015, julian_month: 5)
    #  MerchCalendar.start_of_month(2015, merch_month: 4)
    #
    # @param year [Fixnum] the merch year
    # @param month_param [Fixnum,Hash] an integer specifying the julian month. This can also be a named hash
    # @option month_param [Fixnum] :month the julian month
    # @option month_param [Fixnum] :julian_month the julian month
    # @option month_param [Fixnum] :merch_month the MERCH month
    #
    # @return [Date] the starting date of the specified month
    def start_of_month(year, month_param)
      merch_month = get_merch_month_param(month_param)
      date_calc.start_of_month(year, merch_month)
    end

    # The end date of the month
    #
    # @param year [Fixnum] the merch year
    # @param month_param [Hash] month hash
    #
    # @see #start_of_month The start_of_month method for examples using month_param
    #
    # @return [Date]
    def end_of_month(year, month_param)
      merch_month = get_merch_month_param(month_param)
      date_calc.end_of_month(year, merch_month)
    end

    # The start date of the year
    #
    # @param year [Fixnum] the merch year
    #
    # @return [Date] the starting date of the specified year
    def start_of_year(year)
      date_calc.start_of_year(year)
    end

    # The end date of the year
    #
    # @param year [Fixnum] the merch year
    #
    # @return [Date] the ending date of the specified year
    def end_of_year(year)
      date_calc.end_of_year(year)
    end


    # The start date of the quarter
    #
    # @param year [Fixnum] the merch year
    # @param quarter [Fixnum] the quarter
    #
    # @return [Date] the starting date of the specified quarter
    def start_of_quarter(year, quarter)
      date_calc.start_of_quarter(year, quarter)
    end

    # The end date of the quarter
    #
    # @param year [Fixnum] the merch year
    # @param quarter [Fixnum] the quarter
    #
    # @return [Date] the ending date of the specified quarter
    def end_of_quarter(year, quarter)
      date_calc.end_of_quarter(year, quarter)
    end


    # Returns the number of weeks in a given merch year
    #
    # @param year [Fixnum] the merch year
    #
    # @return [Fixnum] number of weeks
    def weeks_in_year(year)
      date_calc.weeks_in_year(year)
    end



    # Converts a merch month to the correct julian month
    #
    # @param month [Fixnum] the merch month to convert
    # @return [Fixnum] the julian month
    def merch_to_julian(month)
      date_calc.merch_to_julian(month)
    end

    # Converts a julian month to a merch month
    #
    # @param month [Fixnum] the julian month to convert
    # @return [Fixnum] the merch month
    def julian_to_merch(month)
      date_calc.julian_to_merch(month)
    end

    # An array of merch weeks in a given month
    #
    # @param year [Fixnum] the merch year
    # @param month_param [Hash] month hash
    #
    # @see #start_of_month The start_of_month method for examples using month_param
    #
    # @return [Array<MerchWeek>]
    def weeks_for_month(year, month_param)
      merch_month = get_merch_month_param(month_param)

      start_date = date_calc.start_of_month(year, merch_month)

      weeks = (date_calc.end_of_month(year, merch_month) - start_date + 1) / 7

      (1..weeks).map do |week_num|
        week_start = start_date + ((week_num - 1) * 7)
        week_end = week_start + 6
        MerchWeek.new(week_start, { start_of_week: week_start, end_of_week: week_end, week: week_num })
      end
    end


    private

    def date_calc
      @date_calc ||= DateCalculator.new
    end

    # Reads the provided parameter and converts the value
    # to a MERCH MONTH
    def get_merch_month_param(param)
      if param.is_a? Fixnum
        return date_calc.julian_to_merch(param)
      elsif param.is_a? Hash
        julian_month = param.delete(:julian_month) || param.delete(:month)
        merch_month = param.delete(:merch_month)
        if merch_month
          return merch_month
        elsif julian_month
          return date_calc.julian_to_merch(julian_month)
        end
      end
      raise ArgumentError
    end

  end

  # Load the utils into the MerchCalendar namespace
  class << self
    include Util
  end

end
