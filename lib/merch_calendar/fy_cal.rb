require "merch_calendar/retail_calendar"
require "date"

module MerchCalendar
  class FyCal
    
    def initialize
      
    end
    
    def start_of_year
      
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
    
    def start_of_month
      
    end
    
    def end_of_month
      
    end

    def start_of_week
      
    end
    
    def end_of_week
      
    end
    
    def weeks_in_year
      
    end

  end
end
