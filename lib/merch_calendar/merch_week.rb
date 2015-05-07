module MerchCalendar
  class MerchWeek

    MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec).freeze

    attr_reader :date

    class << self

      def from_date(julian_date)
        MerchWeek.new Date.parse("#{julian_date}")
      end

      # JULIAN MONTH
      def find(year, julian_month, week_number=nil)
        if week_number.nil?
          MerchCalendar.weeks_for_month(year, julian_month)
        else
          MerchCalendar.weeks_for_month(year, julian_month)[week_number-1]
        end
      end

      def today
        MerchWeek.from_date Date.today
      end
    end

    # Pass in a date, make sure it is a valid date object
    def initialize(date, options = {})
      @date = date

      # Placeholders. These should be populated by functions if nil
      # week_start: nil, week_end: nil, week_number: nil
      @start_of_year = options[:start_of_year]
      @end_of_year = options[:end_of_year]

      @start_of_week = options[:start_of_week]
      @end_of_week = options[:end_of_week]
      @week = options[:week]

      @start_of_month = options[:start_of_month]
      @end_of_month = options[:end_of_month]
    end

    # what week it is within the year from 1-53
    def year_week
      @year_week ||= (((date-start_of_year)+1)/7.0).ceil
    end

    # This returns the "merch month" number for a date
    # 1 = feb
    def merch_month
      # TODO: This is very inefficient, but less complex than strategic guessing
      # maybe switch to a binary search or something
      @merch_month ||= (1..12).detect do |num|
        date_calc.end_of_month(start_of_year.year, num) >= date && date >= date_calc.start_of_month(start_of_year.year, num)
      end
    end

    def year
      start_of_year.year
    end

    def month
      @month ||= date_calc.merch_to_julian(merch_month)
    end

    # Q1 --aug-oct (7,8,9)
    # Q2--nov-jan (10,11,12)
    # Q3--feb-april (1,2,3)
    # Q4--may-july (4,5,6)
    def quarter
      case merch_month
      when 7,8,9
        return 1
      when 10,11,12
        return 2
      when 1,2,3
        return 3
      else
        return 4
      end
    end

    def start_of_week
      @start_of_week ||= (start_of_month + (7 * (week - 1)))
    end

    def end_of_week
      @end_of_week ||= (start_of_week + 6)
    end

    # the number of the week within the given month
    # will be between 1 and 5
    def week
      @week ||= (((date-start_of_month)+1)/7.0).ceil
    end

    def start_of_year
      @start_of_year ||= year_start_date
    end

    def end_of_year
      @end_of_year ||= date_calc.end_of_year(year)
    end

    def start_of_month
      @start_of_month ||= date_calc.start_of_month(year, merch_month)
    end

    def end_of_month
      @end_of_month ||= date_calc.end_of_month(year, merch_month)
    end

    def season
      case merch_month
      when 1,2,3,4,5,6
        "Spring/Summer"
      when 7,8,9,10,11,12
        "Fall/Winter"
      end
    end

    def to_s(format = :short)
      case format
      when :elasticsearch
        sprintf("%04d-%02dw%02d", year, month, week)
      when :long
        "#{year}:#{year_week} #{self.to_s(:short)}"
      else
        "#{MONTHS[month - 1]} W#{week}"
      end
    end

    private

    def year_start_date
      start_date = date_calc.start_of_year(date.year)
      if start_date > date
        start_date = date_calc.start_of_year(date.year - 1)
      end
      start_date
    end

    def date_calc
      @date_calc ||= DateCalculator.new
    end

  end
end
