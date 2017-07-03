
#
module MerchCalendar
  DEPRECATION_DATE = Date.new(2018, 1, 1)
end

require_relative 'merch_calendar/version'
require_relative 'merch_calendar/util'
require_relative 'merch_calendar/merch_week'
require_relative 'merch_calendar/retail_calendar'
require_relative 'merch_calendar/fiscal_year_calendar'
