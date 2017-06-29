require 'spec_helper'

RSpec.describe MerchCalendar::DateCalculator do
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

  it "#start_of_quarter" do
    expect(subject.start_of_quarter(2017, 1)).to eq Date.new(2017, 1, 29)
    expect(subject.start_of_quarter(2018, 1)).to eq Date.new(2018, 2, 4)
  end

  it "#end_of_quarter" do
    expect(subject.end_of_quarter(2017, 1)).to eq Date.new(2017, 4, 29)
    expect(subject.end_of_quarter(2018, 1)).to eq Date.new(2018, 5, 5)
  end

  describe "#merch_months_in" do
    it "returns merch date for start_date if start_date is the same as end_date" do
      start_date = Date.new(2014,8,1)
      end_date = start_date
      start_merch_date = MerchCalendar.start_of_month(start_date.year, merch_month: start_date.month)

      merch_months = subject.merch_months_in(start_date, end_date)
      expect(merch_months.count).to be(1)
      expect(merch_months.first.year).to eq start_merch_date.year
      expect(merch_months.first.month).to eq start_merch_date.month
      expect(merch_months.first.day).to eq start_merch_date.day
    end

    it "returns valid merch dates for 2014" do
      start_date = Date.new(2014, 1, 1)
      end_date = Date.new(2014, 12, 1)

      merch_months = subject.merch_months_in(start_date, end_date)
      expect(merch_months.count).to be 11

      merch_months.each do |merch_month|
        expect(merch_month.year).to be 2014
      end

      expect(merch_months[0].strftime('%Y-%m-%d')).to eq  '2014-02-02'
      expect(merch_months[1].strftime('%Y-%m-%d')).to eq  '2014-03-02'
      expect(merch_months[2].strftime('%Y-%m-%d')).to eq  '2014-04-06'
      expect(merch_months[3].strftime('%Y-%m-%d')).to eq  '2014-05-04'
      expect(merch_months[4].strftime('%Y-%m-%d')).to eq  '2014-06-01'
      expect(merch_months[5].strftime('%Y-%m-%d')).to eq  '2014-07-06'
      expect(merch_months[6].strftime('%Y-%m-%d')).to eq  '2014-08-03'
      expect(merch_months[7].strftime('%Y-%m-%d')).to eq  '2014-08-31'
      expect(merch_months[8].strftime('%Y-%m-%d')).to eq  '2014-10-05'
      expect(merch_months[9].strftime('%Y-%m-%d')).to eq  '2014-11-02'
      expect(merch_months[10].strftime('%Y-%m-%d')).to eq '2014-11-30'
    end
  end

end

