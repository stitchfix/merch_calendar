require "merch_calendar/retail_calendar"

module MerchCalendar
  class FiscalYearCalendar
    QUARTER_1 = 1
    QUARTER_2 = 2
    QUARTER_3 = 3
    QUARTER_4 = 4

    def start_of_year(year)
      end_of_year(year - 1) + 1
    end
    
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

    def end_of_year(year)
      year_end = Date.new((year), 7, -1) # July 31st
      wday = (year_end.wday + 1) % 7

      if wday > 3
        year_end += 7 - wday
      else
        year_end -= wday
      end
      year_end
    end
    
    def start_of_month(year, merch_month)
      # 91 = number of days in a single 4-5-4 set 
      start = start_of_year(year) + ((merch_month - 1) / 3).to_i * 91

      case merch_month
      when 2,5,8,11
        # 28 = 4 weeks
        start = start + 28
      when 3,6,9,12
        # The 5 week months
        # 63 = 4 weeks + 5 weeks
        start = start + 63
      end
      
      start
    end
    
    def end_of_month(year, merch_month)
      if merch_month == 12
        end_of_year(year)
      else
        start_of_month(year, merch_month + 1) - 1
      end
    end

    def start_of_week(year, month, merch_week)
      start_of_month(year, month) + ((merch_week - 1) * 7)
    end
    
    def end_of_week(year, month, merch_week)
      start_of_month(year, month) + (6 + ((merch_week - 1) * 7))
    end
    
    def weeks_in_year(year)
      ((start_of_year(year + 1) - start_of_year(year)) / 7).to_i
    end
    
  end
end
