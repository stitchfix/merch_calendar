module MerchCalendar
  class << self

    attr_writer :configuration

    # Returns the global configuration object
    #
    # @return [Configuration]
    def configuration
      @configuration ||= Configuration.new
    end

    # Used in initializers to set the global configuration
    #
    # @return [void]
    def configure
      yield(configuration)
    end

    # Resets the configuration to default values
    #
    # @return [void]
    def reset_config!
      @configuration = Configuration.new
    end

  end
end
