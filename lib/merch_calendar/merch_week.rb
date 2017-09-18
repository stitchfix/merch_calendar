module MerchCalendar

  # Represents the Merch Week for a specified date and calendar
  class MerchWeek

    MONTHS = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec).freeze

    # The Julian date that is being represented
    #
    # @!attribute [r] date
    #   @return [Date] the date for this merch week
    attr_reader :date
    
    # The Merch Calendar that is being represented, either Fiscal or Retail
    #
    # @!attribute [r] calendar
    #   @return [Class] the calendar that determines the merch week
    attr_reader :calendar

    # Locates the +MerchWeek+ for a given Julian date.
    #
    # @overload from_date(String)
    #   @param julian_date [String] a julian date in the format of +YYYY-MM-DD+
    #   @param options [Hash] opts the options to set your calendar, if none it will default to RetailCalendar
    #   # @option opts [Class] :calendar The Calendar Class
    # @overload from_date(Date)
    #   @param julian_date [Date] julian_date a +Date+ object
    #   @param options [Hash] opts the options to set your calendar, if none it will default to RetailCalendar
    #   # @option opts [Class] :calendar The Calendar Class
    # @return [MerchWeek]
    def self.from_date(julian_date, options = {})
      MerchWeek.new(Date.parse("#{julian_date}"), options)
    end

    # Returns an array of merch weeks for a month, or a specific week.
    #
    # @overload find(year, julian_month, week_number=nil, options)
    #   Returns an array of +MerchWeek+s for a given month
    #   @param year [Integer] the merch year to locate
    #   @param julian_month [Integer] the month to find merch months for
    #   @param week_number [Nil] set week_number to nil
    #   @param options [Hash] options to set your calendar, if none it will default to RetailCalendar
    #   @return [Array<MerchWeek>]
    # @overload find(year, julian_month, week_number)
    #   @param year [Integer] the merch year to locate
    #   @param julian_month [Integer] the month to find merch months for
    #   @param week_number [Integer] the specific week number.
    #   @param options [Hash] options to set your calendar, if none it will default to RetailCalendar
    #   @return [MerchWeek] the specific merch week based on the week number
    def self.find(year, julian_month, week_number=nil, options={})
      calendar = options.fetch(:calendar, RetailCalendar.new)
      if week_number.nil?
        calendar.weeks_for_month(year, julian_month)
      else
        calendar.weeks_for_month(year, julian_month)[week_number-1]
      end
    end

    # Returns the +MerchWeek+ for today's date
    #
    #   @param options [Hash] opts the options to set your calendar, if none it will default to RetailCalendar
    #   # @option opts [Class] :calendar The Calendar Class
    # @return [MerchWeek]
    def self.today(options={})
      MerchWeek.from_date(Date.today, options)
    end

    # Pass in a date, make sure it is a valid date object
    # @private
    def initialize(date, options = {})
      @date = date
      
      #defaults to Retail Calendar if no other calendar is defined
      @calendar = options.fetch(:calendar, RetailCalendar.new)
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
    # @return [Integer] The week number of the year, from 1-53
    def year_week
      @year_week ||= (((date-start_of_year)+1)/7.0).ceil
    end

    # This returns the "merch month" number for a date
    # Month 1 is Feb for the retail calendar
    # Month 1 is August for the fiscal calendar
    #
    # @return [Integer]
    def merch_month
      # TODO: This is very inefficient, but less complex than strategic guessing
      # maybe switch to a binary search or something
      merch_year = calendar.merch_year_from_date(date)
      @merch_month ||= (1..12).detect do |num|
        calendar.end_of_month(merch_year, num) >= date && date >= calendar.start_of_month(merch_year, num)
      end
    end

    # Returns the Merch year depending whether it is from the Retail or Fiscal calendar
    #
    # @return [Integer]
    def year
      @year ||= calendar.merch_year_from_date(date)
    end

    # Returns julian month where the merch week falls
    #
    # @return [Integer]
    def month
      @month ||= calendar.merch_to_julian(merch_month)
    end

    # Returns the quarter that this merch week falls
    #
    # @return [Integer]
    def quarter
      @quarter ||= calendar.quarter(merch_month)
    end

    # Returns the start date of this week
    #
    # @return [Date]
    def start_of_week
      @start_of_week ||= (start_of_month + (7 * (week - 1)))
    end

    # Returns the end date of this week
    #
    # @return [Date]
    def end_of_week
      @end_of_week ||= (start_of_week + 6)
    end

    # The number of the week within the given merch month
    # will be between 1 and 5
    #
    # @return [Integer]
    def week
      @week ||= (((date-start_of_month)+1)/7.0).ceil
    end

    # The start date of the corresponding merch year
    #
    # @return [Date]
    def start_of_year
      @start_of_year ||= calendar.start_of_year(year)
    end

    # The end date of the corresponding merch year
    #
    # @return [Date]
    def end_of_year
      @end_of_year ||= calendar.end_of_year(year)
    end

    # The start date of the merch month
    #
    # @return [Date]
    def start_of_month
      @start_of_month ||= calendar.start_of_month(year, merch_month)
    end

    # The end date of the merch month
    #
    # @return [Date]
    def end_of_month
      @end_of_month ||= calendar.end_of_month(year, merch_month)
    end

    # The merch season this date falls under.
    # Returns a string of +Fall/Winter+ or +Spring/Summer+
    #
    # @return [String]
    def season
      @season ||= calendar.season(merch_month)
    end

    # Outputs a text representation of this merch week
    #
    # Format keys:
    # * +:short+ (default) "Dec W5"
    # * +:long+ "2012:48 Dec W5"
    # * +:elasticsearch+ (default) "2012-12w05"
    #
    # @param format [Symbol] the format identifier to return. Default is +:short+
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
  end
end
