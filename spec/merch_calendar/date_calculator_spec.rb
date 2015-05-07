require 'spec_helper'

describe MerchCalendar::DateCalculator do

  subject { described_class.new }

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

  describe "#weeks_in_year" do
    it "returns 53 for a leap year" do
      expect(subject.weeks_in_year(2012)).to eq 53
    end

    it "returns 52 for a normal year" do
      expect(subject.weeks_in_year(2013)).to eq 52
    end
  end

  it "#start_of_quarter"

  it "#end_of_quarter"

end

