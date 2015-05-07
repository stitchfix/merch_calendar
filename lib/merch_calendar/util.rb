module MerchCalendar
  module Util

    # MONTH
    def start_of_month(year, month_param)
      merch_month = get_merch_month_param(month_param)
      date_calc.start_of_month(year, merch_month)
    end

    def end_of_month(year, month_param)
      merch_month = get_merch_month_param(month_param)
      date_calc.end_of_month(year, merch_month)
    end

    # YEAR
    def start_of_year(year)
      date_calc.start_of_year(year)
    end

    def end_of_year(year)
      date_calc.end_of_year(year)
    end


    # QUARTER
    def start_of_quarter(year, quarter)
      date_calc.start_of_quarter(year, quarter)
    end

    def end_of_quarter(year, quarter)
      date_calc.end_of_quarter(year, quarter)
    end


    def weeks_in_year(year)
      date_calc.weeks_in_year(year)
    end



    # Converts a merch month to the correct julian month
    def merch_to_julian(month)
      date_calc.merch_to_julian(month)
    end

    def julian_to_merch(month)
      date_calc.julian_to_merch(month)
    end

    # Merch Year
    # Returns an array of each merch week
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

end

MerchCalendar.singleton_class.include(MerchCalendar::Util)
