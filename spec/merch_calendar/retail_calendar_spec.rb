require 'spec_helper'

RSpec.describe MerchCalendar::RetailCalendar do
  describe "#weeks_in_year" do
    it "returns 53 for a leap year" do
      expect(subject.weeks_in_year(2012)).to eq 53
      expect(subject.weeks_in_year(2017)).to eq 53
      expect(subject.weeks_in_year(2023)).to eq 53
    end

    it "returns 52 for a normal year" do
      expect(subject.weeks_in_year(2013)).to eq 52
      expect(subject.weeks_in_year(2018)).to eq 52
      expect(subject.weeks_in_year(2019)).to eq 52
      expect(subject.weeks_in_year(2020)).to eq 52      
    end
  end

  describe "#start_of_week" do
    it "returns the correct date" do
      expect(subject.start_of_week(2017, 1, 1)).to eq Date.new(2017, 1, 29)
      expect(subject.start_of_week(2018, 1, 1)).to eq Date.new(2018, 2, 4)
    end
  end

  describe "#end_of_week" do
    it "returns the correct date" do
      expect(subject.end_of_week(2017, 1, 1)).to eq Date.new(2017, 2, 4)
      expect(subject.end_of_week(2018, 1, 1)).to eq Date.new(2018, 2, 10)
    end

    it "returns the correct date for 2017-12-w5" do
      expect(subject.end_of_week(2017, 12, 5)).to eq Date.new(2018, 2, 3)
    end
  end

  describe "#start_of_month" do
    it "returns the correct date" do
      expect(subject.start_of_month(2017, 1)).to eq Date.new(2017, 1, 29)
      expect(subject.start_of_month(2018, 1)).to eq Date.new(2018, 2, 4)
    end
  end

  describe "#start_of_quarter" do
    it "returns the correct date" do
      expect(subject.start_of_quarter(2017, 1)).to eq Date.new(2017, 1, 29)
      expect(subject.start_of_quarter(2018, 1)).to eq Date.new(2018, 2, 4)
      expect(subject.start_of_quarter(2019, 2)).to eq Date.new(2019, 5, 5)
      expect(subject.start_of_quarter(2019, 3)).to eq Date.new(2019, 8, 4)
      expect(subject.start_of_quarter(2019, 4)).to eq Date.new(2019, 11, 3)
    end
  end

  describe "#end_of_quarter" do
    it "returns the correct date" do
      expect(subject.end_of_quarter(2017, 1)).to eq Date.new(2017, 4, 29)
      expect(subject.end_of_quarter(2018, 1)).to eq Date.new(2018, 5, 5)
      expect(subject.end_of_quarter(2019, 2)).to eq Date.new(2019, 8, 3)
      expect(subject.end_of_quarter(2019, 3)).to eq Date.new(2019, 11, 2)
      expect(subject.end_of_quarter(2019, 4)).to eq Date.new(2020, 2, 1)
    end
  end
  
  describe "#quarter" do
    it "returns the correct date" do
      expect(subject.quarter(5)).to eq 2
      expect(subject.quarter(7)).to eq 3
      expect(subject.quarter(2)).to eq 1
      expect(subject.quarter(11)).to eq 4
    end
  end
  
  describe "#season" do
    context "returns Spring/Summer from its merch_month" do
      it { expect(subject.season(1)).to eq "Spring/Summer" }
      it { expect(subject.season(2)).to eq "Spring/Summer" }
      it { expect(subject.season(3)).to eq "Spring/Summer" }
      it { expect(subject.season(4)).to eq "Spring/Summer" }
      it { expect(subject.season(5)).to eq "Spring/Summer" }
      it { expect(subject.season(6)).to eq "Spring/Summer" }
    end

    context "returns Fall/Winter from its merch_month" do
      it { expect(subject.season(7)).to eq "Fall/Winter" }
      it { expect(subject.season(8)).to eq "Fall/Winter" }
      it { expect(subject.season(9)).to eq "Fall/Winter" }
      it { expect(subject.season(10)).to eq "Fall/Winter" }
      it { expect(subject.season(11)).to eq "Fall/Winter" }
      it { expect(subject.season(12)).to eq "Fall/Winter" }
    end
  end

  describe "#start_of_year" do
    it "returns the correct date" do
      expect(subject.start_of_year(2017)).to eq Date.new(2017, 1, 29)
      expect(subject.start_of_year(2018)).to eq Date.new(2018, 2, 4)
    end
  end

  describe "#end_of_year" do
    it "returns the correct date for 2016" do
      expect(subject.end_of_year(2016)).to eq Date.new(2017, 1, 28)
    end

    it "returns the correct date for 2017 (a leap year)" do
      expect(subject.end_of_year(2017)).to eq Date.new(2018, 2, 3)
    end

    it "returns the correct date for 2018" do
      expect(subject.end_of_year(2018)).to eq Date.new(2019, 2, 2)
    end

    it "returns the correct date for 2019" do
      expect(subject.end_of_year(2019)).to eq Date.new(2020, 2, 1)
    end
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
  
  describe "#merch_year_from_date" do
    it "returns the correct merch calendar year" do
      expect(subject.merch_year_from_date(Date.new(2018, 1, 24))).to eq 2017
      expect(subject.merch_year_from_date(Date.new(2018, 2, 3))).to eq 2017
      expect(subject.merch_year_from_date(Date.new(2018, 2, 4))).to eq 2018
      expect(subject.merch_year_from_date(Date.new(2019, 2, 2))).to eq 2018
      expect(subject.merch_year_from_date(Date.new(2019, 2, 3))).to eq 2019
    end
  end
  
  describe "#merch_to_julian" do
    it "converts merch months to julian months" do
      expect(subject.merch_to_julian(1)).to eq 2
      expect(subject.merch_to_julian(2)).to eq 3
      expect(subject.merch_to_julian(3)).to eq 4
      expect(subject.merch_to_julian(4)).to eq 5
      expect(subject.merch_to_julian(5)).to eq 6
      expect(subject.merch_to_julian(6)).to eq 7
      expect(subject.merch_to_julian(7)).to eq 8
      expect(subject.merch_to_julian(8)).to eq 9
      expect(subject.merch_to_julian(9)).to eq 10
      expect(subject.merch_to_julian(10)).to eq 11
      expect(subject.merch_to_julian(11)).to eq 12
      expect(subject.merch_to_julian(12)).to eq 1
      expect { subject.merch_to_julian(13) }.to raise_error ArgumentError
      expect { subject.merch_to_julian(0) }.to raise_error ArgumentError
    end
  end
  
  describe "#julian_to_merch" do
    it "converts julian months to merch months" do
      expect(subject.julian_to_merch(2)).to eq 1
      expect(subject.julian_to_merch(3)).to eq 2
      expect(subject.julian_to_merch(4)).to eq 3
      expect(subject.julian_to_merch(5)).to eq 4
      expect(subject.julian_to_merch(6)).to eq 5
      expect(subject.julian_to_merch(7)).to eq 6
      expect(subject.julian_to_merch(8)).to eq 7
      expect(subject.julian_to_merch(9)).to eq 8
      expect(subject.julian_to_merch(10)).to eq 9
      expect(subject.julian_to_merch(11)).to eq 10
      expect(subject.julian_to_merch(12)).to eq 11
      expect(subject.julian_to_merch(1)).to eq 12
      expect { subject.julian_to_merch(13) }.to raise_error ArgumentError
      expect { subject.julian_to_merch(0) }.to raise_error ArgumentError
    end
  end
  
  describe "#weeks_for_month" do
    context "correct number of weeks given julian month and fiscal year" do
      it "returns 4 weeks for a 4-week month Fiscal Year 2019 for Aug" do
        weeks = subject.weeks_for_month(2018, 2)
        expect(weeks.size).to eq 4
      end
      it "returns 5 weeks for a 5-week month Fiscal Year 2019 for Sept" do
        weeks = subject.weeks_for_month(2018, 3)
        expect(weeks.size).to eq 5
      end
      it "returns 5 weeks during a 4-5-5 quarter" do
        weeks = subject.weeks_for_month(2017, 11)
        expect(weeks.size).to eq 4

        weeks = subject.weeks_for_month(2017, 12)
        expect(weeks.size).to eq 5
        
        weeks = subject.weeks_for_month(2017, 1)
        expect(weeks.size).to eq 5
        
        weeks = subject.weeks_for_month(2018, 2)
        expect(weeks.size).to eq 4
      end
    end
  end
end
