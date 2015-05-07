module MerchCalendar
  # THIS IS NOT BEING USED YET
  class Configuration

    # The JULIAN month of the quarter start
    attr_accessor :quarter_start_month

    def initialize
      @quarter_start_month = 8
    end

  end
end