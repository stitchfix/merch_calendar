module MerchCalendar
  class << self
    
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_config!
      @configuration = Configuration.new
    end

  end
end