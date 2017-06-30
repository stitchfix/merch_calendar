require "simplecov"
require "coveralls"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start { add_filter "/spec/" }

require "pry"
require "merch_calendar"

RSpec.configure do |config|
  config.mock_with :rspec do |mocks_config|
    mocks_config.verify_doubled_constant_names = true
    mocks_config.verify_partial_doubles = true
  end

  config.around do |example|
    # Hide deprecation warnings within this gem from showing up in tests
    if Date.today < MerchCalendar::DEPRECATION_DATE
      Gem::Deprecate.skip_during do
        example.run
      end
    else
      example.run
    end
  end
end
