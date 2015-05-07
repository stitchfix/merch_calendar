require 'spec_helper'

describe MerchCalendar::Configuration do
  describe "#quarter_start_month" do
    it "default value is 8" do
      expect(described_class.new.quarter_start_month).to eq 8
    end
  end

  describe "#quarter_start_month=" do
    it "can set value" do
      config = described_class.new
      config.quarter_start_month = 7
      expect(config.quarter_start_month).to eq 7
    end
  end
end
