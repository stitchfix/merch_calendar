require "merch_calendar/retail_calendar"
require "date"

module MerchCalendar
  class FyCal
    
    def initialize
      
    end
    
    def start_of_year(year)
      end_of_year(year - 1) + 1
    end
    
    def start_of_quarter
      
    end
    
    def end_of_quarter
      
    end

    def end_of_year(year)
      year_end = Date.new((year), 7, -1) # July 31st
      wday = (year_end.wday + 1) % 7 # 5

      if wday > 3 ### this rounds up to the next saturday 
        year_end += 7 - wday
      else# rounding down to the next saturday
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
    
    def end_of_month
      
    end

    def start_of_week
      
    end
    
    def end_of_week
      
    end
    
    def weeks_in_year(year)
      ((start_of_year(year + 1) - start_of_year(year)) / 7).to_i
    end

  end
end
