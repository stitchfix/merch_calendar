require 'spec_helper'

RSpec.describe MerchCalendar do
  context "responds to util methods" do
    [
      :start_of_month, :end_of_month,
      :start_of_year, :end_of_year,
      :start_of_quarter, :end_of_quarter,
      :merch_to_julian,
      :julian_to_merch,
      :weeks_in_year,
      :weeks_for_month
    ].each do |method_name|
      it "responds to the #{method_name} method" do
        expect(described_class).to respond_to(method_name)
      end
    end
  end

  describe "#julian_to_merch" do
    it { expect(subject.julian_to_merch(1)).to eq 12 }
    it { expect(subject.julian_to_merch(2)).to eq 1 }
    it { expect(subject.julian_to_merch(3)).to eq 2 }
    it { expect(subject.julian_to_merch(4)).to eq 3 }
    it { expect(subject.julian_to_merch(5)).to eq 4 }
    it { expect(subject.julian_to_merch(6)).to eq 5 }
    it { expect(subject.julian_to_merch(7)).to eq 6 }
    it { expect(subject.julian_to_merch(8)).to eq 7 }
    it { expect(subject.julian_to_merch(9)).to eq 8 }
    it { expect(subject.julian_to_merch(10)).to eq 9 }
    it { expect(subject.julian_to_merch(11)).to eq 10 }
    it { expect(subject.julian_to_merch(12)).to eq 11 }
  end

  describe "#merch_to_julian" do
    it { expect(subject.merch_to_julian(12)).to eq 1 }
    it { expect(subject.merch_to_julian(1)).to eq 2 }
    it { expect(subject.merch_to_julian(2)).to eq 3 }
    it { expect(subject.merch_to_julian(3)).to eq 4 }
    it { expect(subject.merch_to_julian(4)).to eq 5 }
    it { expect(subject.merch_to_julian(5)).to eq 6 }
    it { expect(subject.merch_to_julian(6)).to eq 7 }
    it { expect(subject.merch_to_julian(7)).to eq 8 }
    it { expect(subject.merch_to_julian(8)).to eq 9 }
    it { expect(subject.merch_to_julian(9)).to eq 10 }
    it { expect(subject.merch_to_julian(10)).to eq 11 }
    it { expect(subject.merch_to_julian(11)).to eq 12 }
  end


  describe "#start_of_week" do
    it "returns the correct date for a given merch week" do
      expect(described_class.start_of_week(2017, 4, 1)).to eq Date.new(2017, 4, 2)
    end
  end

  describe "#end_of_week" do
    it "returns the correct date for a given merch week" do
      expect(described_class.end_of_week(2017, 4, 1)).to eq Date.new(2017, 4, 8)
    end
  end

  describe "#start_of_month" do
    it "returns the correct date for 2017-1" do
      expect(described_class.start_of_month(2017, 1)).to eq Date.new(2017, 12, 31)
    end

    it "returns the correct date for 2017-5" do
      expect(described_class.start_of_month(2017, 5)).to eq Date.new(2017, 4, 30)
    end

    it "returns the correct date for 2018-1" do
      expect(described_class.start_of_month(2018, 1)).to eq Date.new(2019, 1, 6)
    end
  end

  describe "#end_of_month" do
    it "returns the correct date for 2017-1" do
      expect(described_class.end_of_month(2017, 1)).to eq Date.new(2018, 2, 3)
    end

    it "returns the correct date for 2017-5" do
      expect(described_class.end_of_month(2017, 5)).to eq Date.new(2017, 5, 27)
    end

    it "returns the correct date for 2018-1" do
      expect(described_class.end_of_month(2018, 1)).to eq Date.new(2019, 2, 2)
    end
  end

  describe "#start_of_year" do
    it "returns the correct date for 2014" do
      expect(described_class.start_of_year(2014)).to eq Date.new(2014, 2, 2)
    end

    it "returns the correct date for 2017" do
      expect(described_class.start_of_year(2017)).to eq Date.new(2017, 1, 29)
    end
  end

  describe "#end_of_year" do
    it "returns the correct date for 2014" do
      expect(described_class.end_of_year(2014)).to eq Date.new(2015, 1, 31)
    end

    it "returns the correct date for 2017" do
      expect(described_class.end_of_year(2017)).to eq Date.new(2018, 2, 3)
    end
  end

  describe "#start_of_quarter" do
    it "returns the correct date for 2014-Q1" do
      expect(described_class.start_of_quarter(2014,1)).to eq Date.new(2014, 8, 3)
    end
  end

  describe "#end_of_quarter" do
    it "returns the correct date for 2014-Q1" do
      expect(described_class.end_of_quarter(2014,1)).to eq Date.new(2014, 11, 1)
    end
  end

  describe "#weeks_in_year" do
    it "returns the right number of weeks for 2014" do
      expect(described_class.weeks_in_year(2014)).to eq 52
    end

    it "returns the right number of weeks for 2017" do
      expect(described_class.weeks_in_year(2017)).to eq 53
    end
  end

  describe "#merch_to_julian" do
    it "returns the right julian month" do
      expect(described_class.merch_to_julian(1)).to eq 2
    end
  end

  describe "#julian_to_merch" do
    it "returns the right merch month" do
      expect(described_class.julian_to_merch(1)).to eq 12
    end
  end

end
