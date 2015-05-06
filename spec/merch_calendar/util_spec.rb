require 'spec_helper'

describe 'Util' do
  describe ".julian_to_merch" do
    it { expect(MerchCalendar.julian_to_merch(1)).to eq 12 }
    it { expect(MerchCalendar.julian_to_merch(2)).to eq 1 }
    it { expect(MerchCalendar.julian_to_merch(3)).to eq 2 }
    it { expect(MerchCalendar.julian_to_merch(4)).to eq 3 }
    it { expect(MerchCalendar.julian_to_merch(5)).to eq 4 }
    it { expect(MerchCalendar.julian_to_merch(6)).to eq 5 }
    it { expect(MerchCalendar.julian_to_merch(7)).to eq 6 }
    it { expect(MerchCalendar.julian_to_merch(8)).to eq 7 }
    it { expect(MerchCalendar.julian_to_merch(9)).to eq 8 }
    it { expect(MerchCalendar.julian_to_merch(10)).to eq 9 }
    it { expect(MerchCalendar.julian_to_merch(11)).to eq 10 }
    it { expect(MerchCalendar.julian_to_merch(12)).to eq 11 }
  end

  describe ".merch_to_julian" do
    it { expect(MerchCalendar.merch_to_julian(12)).to eq 1 }
    it { expect(MerchCalendar.merch_to_julian(1)).to eq 2 }
    it { expect(MerchCalendar.merch_to_julian(2)).to eq 3 }
    it { expect(MerchCalendar.merch_to_julian(3)).to eq 4 }
    it { expect(MerchCalendar.merch_to_julian(4)).to eq 5 }
    it { expect(MerchCalendar.merch_to_julian(5)).to eq 6 }
    it { expect(MerchCalendar.merch_to_julian(6)).to eq 7 }
    it { expect(MerchCalendar.merch_to_julian(7)).to eq 8 }
    it { expect(MerchCalendar.merch_to_julian(8)).to eq 9 }
    it { expect(MerchCalendar.merch_to_julian(9)).to eq 10 }
    it { expect(MerchCalendar.merch_to_julian(10)).to eq 11 }
    it { expect(MerchCalendar.merch_to_julian(11)).to eq 12 }
  end
end