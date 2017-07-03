require "merch_calendar/retail_calendar"

module MerchCalendar
  class FiscalYearCalendar
    # @param fy_quarter_offset [Fixnum]
    #   The number of quarters before or after the start of the traditional NRF retail calendar that the year
    #   should begin.
    #     ex) Stitch Fix's fiscal year calendar starts in August of the prior gregorian calendar year.
    #         February 2017 = Traditional retail month 1, year 2017 
    #         August 2016 = Offset retail month 1, year 2017 (2 quarters earlier)
    def initialize(fy_quarter_offset = (-2))
      @fy_quarter_offset = fy_quarter_offset

      # TODO: support other fiscal year offsets
      if fy_quarter_offset != -2
        raise NotImplementedError.new("FY quarter offset of #{fy_quarter_offset} not yet supported")
      end

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
      yr, qt = if quarter >= 1 + @fy_quarter_offset.abs 
                 [year, quarter + @fy_quarter_offset]
               else
                 [year - 1, quarter - @fy_quarter_offset]
               end
    end

    def offset_month(year, month)
      # 3 - number of months in a quarter
      month_offset = @fy_quarter_offset * 3

      yr, mn = if month >= (month_offset.abs + 1) 
                 [year, month + month_offset] 
               else
                 [year - 1, month - month_offset]
               end
    end
  end
end
