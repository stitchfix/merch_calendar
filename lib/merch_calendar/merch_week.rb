module MerchCalendar

  # Represents the Merch Week for a specified date.
  class MerchWeek

    MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec).freeze

    # The Julian date that is being represented
    #
    # @!attribute [r] date
    #   @return [Date] the date for this merch week
    attr_reader :date

    class << self

      # Locates the +MerchWeek+ for a given Julian date.
      #
      # @overload from_date(String)
      #   @param [String] julian_date a julian date in the format of +YYYY-MM-DD+
      # @overload from_date(Date)
      #   @param [Date] julian_date a +Date+ object
      #
      # @return [MerchWeek]
      def from_date(julian_date)
        MerchWeek.new Date.parse("#{julian_date}")
      end

      # Returns an array of merch weeks for a month, or a specific week.
      #
      # @overload find(year, julian_month)
      #   Returns an array of +MerchWeek+s for a given month
      #   @param year [Fixnum] the merch year to locate
      #   @param julian_month [Fixnum] the month to find merch months for
      #   @return [Array<MerchWeek>]
      # @overload find(year, julian_month, week_number)
      #   @param year [Fixnum] the merch year to locate
      #   @param julian_month [Fixnum] the month to find merch months for
      #   @param week_number [Fixnum] the specific week number.
      #   @return [MerchWeek] the specific merch week
      def find(year, julian_month, week_number=nil)
        if week_number.nil?
          MerchCalendar.weeks_for_month(year, julian_month)
        else
          MerchCalendar.weeks_for_month(year, julian_month)[week_number-1]
        end
      end

      # Returns the +MerchWeek+ for today's date
      #
      # @return [MerchWeek]
      def today
        MerchWeek.from_date Date.today
      end
    end



    # Pass in a date, make sure it is a valid date object
    # @private
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

    # What week it is within the year from 1-53
    #
    # @return [Fixnum] The week number of the year, from 1-53
    def year_week
      @year_week ||= (((date-start_of_year)+1)/7.0).ceil
    end

    # This returns the "merch month" number for a date
    # Merch months are shifted by one. Month 1 is Feb
    #
    # @return [Fixnum]
    def merch_month
      # TODO: This is very inefficient, but less complex than strategic guessing
      # maybe switch to a binary search or something
      @merch_month ||= (1..12).detect do |num|
        date_calc.end_of_month(start_of_year.year, num) >= date && date >= date_calc.start_of_month(start_of_year.year, num)
      end
    end

    # The merch year
    #
    # @return [Fixnum]
    def year
      start_of_year.year
    end

    # The julian month that this merch week falls in
    #
    # @return [Fixnum]
    def month
      @month ||= date_calc.merch_to_julian(merch_month)
    end

    # The specific quarter this week falls in
    #
    # @return [Fixnum]
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

    # Returns the date of the start of this week
    #
    # @return [Date]
    def start_of_week
      @start_of_week ||= (start_of_month + (7 * (week - 1)))
    end

    # Returns the date of the end of this week
    #
    # @return [Date]
    def end_of_week
      @end_of_week ||= (start_of_week + 6)
    end

    # the number of the week within the given month
    # will be between 1 and 5
    #
    # @return [Fixnum]
    def week
      @week ||= (((date-start_of_month)+1)/7.0).ceil
    end

    # The date of the start of the corresponding merch year
    #
    # @return [Date]
    def start_of_year
      @start_of_year ||= year_start_date
    end

    # The end date of the corresponding merch year
    #
    # @return [Date]
    def end_of_year
      @end_of_year ||= date_calc.end_of_year(year)
    end

    # The start date of the merch month
    #
    # @return [Date]
    def start_of_month
      @start_of_month ||= date_calc.start_of_month(year, merch_month)
    end

    # The end date of the merch month
    #
    # @return [Date]
    def end_of_month
      @end_of_month ||= date_calc.end_of_month(year, merch_month)
    end

    # The merch season this date falls under.
    # Returns a string of +Fall/Winter+ or +Spring/Summer+
    #
    # @return [String]
    def season
      case merch_month
      when 1,2,3,4,5,6
        "Spring/Summer"
      when 7,8,9,10,11,12
        "Fall/Winter"
      end
    end

    # Outputs a text representation of this merch week
    #
    # Format keys:
    # * +:short+ (default) "Dec W5"
    # * +:long+ "2012:48 Dec W5"
    # * +:elasticsearch+ (default) "2012-12w05"
    #
    # @param format [Symbol] the format identifier to return. Default is +:short+
    #
    # @return [Date]
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
