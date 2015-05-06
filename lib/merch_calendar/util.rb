module MerchCalendar
  class << self

    # Converts a merch month to the correct julian month
    def merch_to_julian(month)
      date_calc.merch_to_julian(month)
    end

    def julian_to_merch(month)
      date_calc.julian_to_merch(month)
    end


    private

    def date_calc
      @date_calc ||= DateCalculator.new
    end

    # Reads the provided parameter and converts the value
    # to a MERCH MONTH
    def get_merch_month_param(param)
      if param.is_a? Fixnum
        date_calc.julian_to_merch(param)
      else

      end
    end


  end
end