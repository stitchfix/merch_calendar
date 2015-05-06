require 'spec_helper'


describe MerchCalendar do
  describe "#reset_config!" do
    it "resets the configuration to defaults" do
      MerchCalendar.configure do |config|
        config.quarter_start_month = 1
      end

      MerchCalendar.reset_config!

      expect(MerchCalendar.configuration.quarter_start_month).to eq MerchCalendar::Configuration.new.quarter_start_month

    end
  end

  
end