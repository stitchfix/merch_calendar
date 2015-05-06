module MerchCalendar
  class << self

    def end_of_year(year)
      year_end = Date.new (year + 1), 1, -1
      wday = (year_end.wday + 1) % 7

      if wday > 3
        year_end += 7 - wday
      elsif wday > 0
        year_end -= wday
      end
      year_end
    end

    # The day after last years' end date
    def start_of_year(year)
      end_of_year(year - 1) + 1
    end

    # The starting date of a given month
    # THIS IS THE MERCH MONTH
    # 1 = feb
    # 
    def start_of_month(year, month)
      # 91 = number of days in a single 4-5-4 set 
      start = start_of_year(year) + ((month - 1) / 3).to_i * 91

      case month
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

    def end_of_month(year, month)
      if month == 12
        end_of_year(year)
      else
        start_of_month(year, month + 1) - 1
      end
    end

    # Return the starting date for a particular quarter
    def start_of_quarter(year, quarter)
      case quarter
      when 1
        start_of_month(year, 7)
      when 2
        start_of_month(year, 10)
      when 3
        start_of_month(year, 1)
      when 4
        start_of_month(year, 4)
      end
    end

    # Return the ending date for a particular quarter
    def end_of_quarter(year, quarter)
      case quarter
      when 1
        end_of_month(year, 9)
      when 2
        end_of_month(year, 12)
      when 3
        end_of_month(year, 3)
      when 4
        end_of_month(year, 6)
      end
    end

    # Return the number of weeks in a particular year
    def weeks_in_year(year)
      ((start_of_year(year + 1) - start_of_year(year)) / 7).to_i
    end

    # Merch Year
    # Julian month
    # Returns an array of each merch week
    def weeks_for_month(year, month)
      merch_month = julian_to_merch(month)

      start_date = start_of_month(year, merch_month)

      weeks = (end_of_month(year, merch_month) - start_date + 1) / 7

      (1..weeks).map do |week_num|
        week_start = start_date + ((week_num - 1) * 7)
        week_end = week_start + 6
        MerchWeek.new(week_start, {
          start_of_week: week_start, 
          end_of_week: week_end, 
          week: week_num
          })
      end

    end


  end
end