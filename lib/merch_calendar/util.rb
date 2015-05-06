module MerchCalendar
  class << self

    # Converts a merch month to the correct julian month
    def merch_to_julian(month)
      if month == 12
        1
      else
        month + 1
      end
    end

    def julian_to_merch(month)
      if month == 1
        12
      else
        month - 1
      end
    end
  end
end