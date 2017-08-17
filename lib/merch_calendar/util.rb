require "merch_calendar/retail_calendar"
require "merch_calendar/stitch_fix_fiscal_year_calendar"

module MerchCalendar

  # Utility methods for the merch calendar
  module Util

    # The start date of the week
    #
    # @param year [Fixnum] the merch year
    # @param month [Fixnum] an integer specifying the julian month.
    # @param week [Fixnum] an integer specifying the merch week.
    #
    # @return [Date] the starting date of the specified week
    def start_of_week(year, month, week)
      retail_calendar.start_of_week(year, julian_to_merch(month), week)
    end

    # The end date of the week
    #
    # @param year [Fixnum] the merch year
    # @param month [Fixnum] an integer specifying the julian month.
    # @param week [Fixnum] an integer specifying the merch week.
    #
    # @return [Date] the ending date of the specified week
    def end_of_week(year, month, week)
      retail_calendar.end_of_week(year, julian_to_merch(month), week)
    end

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
      retail_calendar.start_of_month(year, merch_month)
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
      retail_calendar.end_of_month(year, merch_month)
    end

    # The start date of the year
    #
    # @param year [Fixnum] the merch year
    #
    # @return [Date] the starting date of the specified year
    def start_of_year(year)
      retail_calendar.start_of_year(year)
    end

    # The end date of the year
    #
    # @param year [Fixnum] the merch year
    #
    # @return [Date] the ending date of the specified year
    def end_of_year(year)
      retail_calendar.end_of_year(year)
    end


    # The start date of the quarter
    #
    # @param year [Fixnum] the merch year
    # @param quarter [Fixnum] the quarter
    #
    # @return [Date] the starting date of the specified quarter
    def start_of_quarter(year, quarter)
      fiscal_year_calendar.start_of_quarter(year + 1, quarter)
    end

    # The end date of the quarter
    #
    # @param year [Fixnum] the merch year
    # @param quarter [Fixnum] the quarter
    #
    # @return [Date] the ending date of the specified quarter
    def end_of_quarter(year, quarter)
      fiscal_year_calendar.end_of_quarter(year + 1, quarter)
    end


    # Returns the number of weeks in a given merch year
    #
    # @param year [Fixnum] the merch year
    #
    # @return [Fixnum] number of weeks
    def weeks_in_year(year)
      retail_calendar.weeks_in_year(year)
    end


    # An array of merch dates in start_date to end_date
    #
    # @param start_date [Date] the start date
    # @param end_date [Date] the end date
    #
    # @return [Array<Date>] array of merch months
    def merch_months_in(start_date, end_date)
      retail_calendar.merch_months_in(start_date, end_date)
    end


    # Converts a merch month to the correct julian month
    #
    # @param merch_month [Fixnum] the merch month to convert
    # @return [Fixnum] the julian month
    def merch_to_julian(merch_month)
      if merch_month == 12
        1
      else
        merch_month + 1
      end
    end


    # Converts a julian month to a merch month
    #
    # @param julian_month [Fixnum] the julian month to convert
    # @return [Fixnum] the merch month
    def julian_to_merch(julian_month)
      if julian_month == 1
        12
      else
        julian_month - 1
      end
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

      start_date = retail_calendar.start_of_month(year, merch_month)

      weeks = (retail_calendar.end_of_month(year, merch_month) - start_date + 1) / 7

      (1..weeks).map do |week_num|
        week_start = start_date + ((week_num - 1) * 7)
        week_end = week_start + 6
        MerchWeek.new(week_start, { start_of_week: week_start, end_of_week: week_end, week: week_num })
      end
    end


    private

    def retail_calendar
      @retail_calendar ||= RetailCalendar.new
    end

    def fiscal_year_calendar
      @fiscal_year_calendar ||= StitchFixFiscalYearCalendar.new
    end

    # Reads the provided parameter and converts the value
    # to a MERCH MONTH
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

  # Load the utils into the MerchCalendar namespace
  class << self
    include Util
    extend Gem::Deprecate

    [
      :start_of_week, 
      :end_of_week,
      :start_of_month, 
      :end_of_month,
      :start_of_year, 
      :end_of_year,
      :weeks_in_year,
      :merch_months_in,
    ].each do |method|
      deprecate method, "#{MerchCalendar::RetailCalendar}##{method}", DEPRECATION_DATE.year, DEPRECATION_DATE.month
    end

    [
      :start_of_quarter, 
      :end_of_quarter
    ].each do |method|
      deprecate method, "#{MerchCalendar::FiscalYearCalendar}##{method}", DEPRECATION_DATE.year, DEPRECATION_DATE.month
    end

  end

end
