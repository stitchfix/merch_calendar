require "merch_calendar/retail_calendar"

module MerchCalendar
  class FiscalYearCalendar
    def initialize
      @retail_calendar = RetailCalendar.new
    end

    # The day after last years' end date
    def start_of_year(year)
      start_of_quarter(year, 1)
    end

    def end_of_year(year)
      end_of_quarter(year, 4)
    end

    # Return the starting date for a particular quarter
    def start_of_quarter(year, quarter)
      @retail_calendar.start_of_quarter(*offset_quarter(year, quarter))
    end

    # Return the ending date for a particular quarter
    def end_of_quarter(year, quarter)
      @retail_calendar.end_of_quarter(*offset_quarter(year, quarter))
    end

    def start_of_month(year, merch_month)
      @retail_calendar.start_of_month(*offset_month(year, merch_month))
    end

    def end_of_month(year, merch_month)
      @retail_calendar.end_of_month(*offset_month(year, merch_month))
    end

    # Returns the date that corresponds to the first day in the merch week
    def start_of_week(year, merch_month, merch_week)
      @retail_calendar.start_of_week(*offset_month(year, merch_month), merch_week)
    end

    # Returns the date that corresponds to the last day in the merch week
    def end_of_week(year, merch_month, merch_week)
      @retail_calendar.end_of_week(*offset_month(year, merch_month), merch_week)
    end

    def weeks_in_year(year)
      @retail_calendar.weeks_in_year(year - 1)
    end

    private

    def offset_quarter(year, quarter)
      # first quarter in fiscal calendar is Q3 of retail calendar of previous year
      yr, qt = quarter >= 3 ? [year, quarter - 2] : [year - 1, quarter + 2]
    end

    def offset_month(year, month)
      # first month in fiscal calendar is the sixth month in the retail calendar
      yr, mn = month >= 7 ? [year, month - 6] : [year - 1, month + 6]
    end
  end
end
