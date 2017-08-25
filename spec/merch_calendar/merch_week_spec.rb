require 'spec_helper'

describe MerchCalendar::MerchWeek do
  let(:fiscal_calendar_options) { { calendar: MerchCalendar::StitchFixFiscalYearCalendar.new } }

  describe ".find" do
    it "returns an array of weeks" do
      weeks = described_class.find(2014,1)
      expect(weeks).to be_an Array
      expect(weeks.size).to eq 4
      expect(weeks[0].calendar.class).to eq MerchCalendar::RetailCalendar
    end

    it "with year, month, week" do
      mw = described_class.find(2014,1,1)
      expect(mw.year).to eq 2014
      expect(mw.month).to eq 1
      expect(mw.merch_month).to eq 12
      expect(mw.week).to eq 1
    end
    context "using the Fiscal Calendar instead of the Retail Calendar" do
      it "returns an array of weeks" do
        weeks = described_class.find(2019, 7, nil, fiscal_calendar_options)
        expect(weeks).to be_an Array
        expect(weeks.size).to eq 5
        expect(weeks[0].calendar.class).to eq MerchCalendar::StitchFixFiscalYearCalendar
      end
      
      it "with year, month, week" do
        mw = described_class.find(2019, 7, 5, fiscal_calendar_options)
        expect(mw.year).to eq 2019
        expect(mw.month).to eq 7
        expect(mw.merch_month).to eq 12
        expect(mw.week).to eq 5
        expect(mw.end_of_week).to eq Date.new(2019,8,3)
        expect(mw.start_of_week).to eq Date.new(2019,7,28)
        expect(mw.calendar.class).to eq MerchCalendar::StitchFixFiscalYearCalendar
      end
      
      it "with year, month, week for the next year after FY19" do
        mw = described_class.find(2020, 8, 1, fiscal_calendar_options)
        expect(mw.year).to eq 2020
        expect(mw.month).to eq 8
        expect(mw.merch_month).to eq 1
        expect(mw.week).to eq 1
        expect(mw.end_of_week).to eq Date.new(2019,8,10)
        expect(mw.start_of_week).to eq Date.new(2019,8,4)
        expect(mw.calendar.class).to eq MerchCalendar::StitchFixFiscalYearCalendar
      end
    end
  end

  describe ".from_date" do

    context "parameters" do
      context "allows valid date types" do
        it "allows a date string" do
          mw = described_class.from_date("1990-10-01")
          expect(mw.date.to_s).to eq "1990-10-01"
          expect(mw.date.month).to eq 10
        end
      end

      context "throws exception for invalid types" do
        it { expect{described_class.from_date}.to raise_error(ArgumentError) }
        it { expect{described_class.from_date(1)}.to raise_error(ArgumentError) }
        it { expect{described_class.from_date(true)}.to raise_error(ArgumentError) }
        it { expect{described_class.from_date(1.0)}.to raise_error(ArgumentError) }
      end

      context "throws exception for invalid dates" do
        it { expect{described_class.from_date("2015")}.to raise_error(ArgumentError) }
        it { expect{described_class.from_date("2015-04")}.to raise_error(ArgumentError) }
      end
      
      context "wants to know a date in a Fiscal Calendar" do
        it "allows calendar to be passed and translate date to what it looks like in a FY year" do
          mw = described_class.from_date( "2019-07-28", fiscal_calendar_options )
          expect(mw.date.to_s).to eq "2019-07-28"
          expect(mw.date.month).to eq 7
          expect(mw.calendar.class).to eq MerchCalendar::StitchFixFiscalYearCalendar
        end
      end
    end
  end

  describe ".today" do
    it "returns a merch week based on today's date" do
      mw = described_class.today
      expect(mw.date.to_s).to eq Date.today.to_s
    end
  end

  describe "#to_s" do
    let(:merch_week) { described_class.from_date("2014-01-01") }
    let(:fiscal_week) { described_class.from_date("2019-08-01", fiscal_calendar_options) }

    it ":short / default format" do
      expect(merch_week.to_s(:short)).to eq "Dec W5"
      expect(merch_week.to_s).to eq "Dec W5"
      expect("#{merch_week}").to eq "Dec W5"
      
      expect(fiscal_week.to_s(:short)).to eq "Jul W5"
      expect(fiscal_week.to_s).to eq "Jul W5"
      expect("#{fiscal_week}").to eq "Jul W5"
    end

    it ":long format" do
      expect(merch_week.to_s(:long)).to eq "2013:48 Dec W5"
      expect(fiscal_week.to_s(:long)).to eq "2019:53 Jul W5"

    end

    it ":elasticsearch format" do
      expect(merch_week.to_s(:elasticsearch)).to eq "2013-12w05"
      expect(fiscal_week.to_s(:elasticsearch)).to eq "2019-07w05"
    end
  end

  it "#end_of_week" do
    mw = described_class.find(2014,1,1)
    expect(mw.end_of_week).to eq (mw.start_of_week + 6)
  end


  describe "#end_of_month" do
    it "for a 4 week month" do
      mw = described_class.find(2014, 2, 1)
      expect(mw.end_of_month - mw.start_of_month + 1).to eq (4*7)
    end

    it "for a 5 week month" do
      mw = described_class.find(2014, 3, 1)
      expect(mw.end_of_month - mw.start_of_month + 1).to eq (5*7)
    end

    it "for a 4 to 5 week month in a leap year" do
      mw = described_class.find(2011, 1, 1)
      expect(mw.end_of_month - mw.start_of_month + 1).to eq (4*7)

      mw = described_class.find(2012, 1, 1)
      expect(mw.end_of_month - mw.start_of_month + 1).to eq (5*7)
    end
  end

  describe "#season" do
    context "Fall/Winter" do
      it { expect(described_class.from_date("2011-08-06").season).to eq "Fall/Winter" }
      it { expect(described_class.from_date("2011-09-06").season).to eq "Fall/Winter" }
      it { expect(described_class.from_date("2011-10-06").season).to eq "Fall/Winter" }
      it { expect(described_class.from_date("2011-11-06").season).to eq "Fall/Winter" }
      it { expect(described_class.from_date("2011-12-06").season).to eq "Fall/Winter" }
      it { expect(described_class.from_date("2012-01-06").season).to eq "Fall/Winter" }
    end

    context "Spring/Summer" do
      it { expect(described_class.from_date("2011-02-06").season).to eq "Spring/Summer" }
      it { expect(described_class.from_date("2011-03-06").season).to eq "Spring/Summer" }
      it { expect(described_class.from_date("2011-04-06").season).to eq "Spring/Summer" }
      it { expect(described_class.from_date("2011-05-06").season).to eq "Spring/Summer" }
      it { expect(described_class.from_date("2011-06-06").season).to eq "Spring/Summer" }
      it { expect(described_class.from_date("2011-07-06").season).to eq "Spring/Summer" }
    end
  end


  context "logic" do
    [
      OpenStruct.new(date: "2011-05-01", year: 2011, month: 5,  week: 1, quarter: 4, year_week: 14, start_date: "2011-01-30"),
      
      OpenStruct.new(date: "2014-08-31", year: 2014, month: 9,  week: 1, quarter: 1, year_week: 31, start_date: "2014-02-02"),
      OpenStruct.new(date: "2017-12-30", year: 2017, month: 12, week: 5, quarter: 2, year_week: 48, start_date: "2017-01-29"),
      OpenStruct.new(date: "2014-01-01", year: 2013, month: 12, week: 5, quarter: 2, year_week: 48, start_date: "2013-02-03"),
      OpenStruct.new(date: "2014-01-04", year: 2013, month: 12, week: 5, quarter: 2, year_week: 48, start_date: "2013-02-03"),
      OpenStruct.new(date: "2014-01-05", year: 2013, month: 1,  week: 1, quarter: 2, year_week: 49, start_date: "2013-02-03"),
      OpenStruct.new(date: "2014-01-12", year: 2013, month: 1,  week: 2, quarter: 2, year_week: 50, start_date: "2013-02-03"),
      OpenStruct.new(date: "2014-01-19", year: 2013, month: 1,  week: 3, quarter: 2, year_week: 51, start_date: "2013-02-03"),
      OpenStruct.new(date: "2014-01-26", year: 2013, month: 1,  week: 4, quarter: 2, year_week: 52, start_date: "2013-02-03"),
      
      # 2013
      OpenStruct.new(date: "2013-02-03", year: 2013, month: 2,  week: 1, quarter: 3, year_week: 1,  start_date: "2013-02-03"),

      #2014
      OpenStruct.new(date: "2014-02-02", year: 2014, month: 2,  week: 1, quarter: 3, year_week: 1,  start_date: "2014-02-02"),
      OpenStruct.new(date: "2015-01-31", year: 2014, month: 1,  week: 4, quarter: 2, year_week: 52, start_date: "2014-02-02"),
      
      OpenStruct.new(date: "2014-02-01", year: 2013, month: 1,  week: 4, quarter: 2, year_week: 52, start_date: "2013-02-03"),
      #2015
      OpenStruct.new(date: "2015-02-01", year: 2015, month: 2,  week: 1, quarter: 3, year_week: 1, start_date: "2015-02-01"),

    ].each do |date_check|

      context "using date '#{date_check.date}'" do
        let(:merch_week) { described_class.from_date(date_check.date) }

        it "#year_week" do
          expect(merch_week.year_week).to eq date_check.year_week
        end

        it "#month" do
          expect(merch_week.month).to eq date_check.month
        end

        it "#quarter" do
          expect(merch_week.quarter).to eq date_check.quarter
        end

        it "#week" do
          expect(merch_week.week).to eq date_check.week
        end

        it "#start_of_year" do
          expect(merch_week.start_of_year.to_s).to eq date_check.start_date
        end

        it "#year" do
          expect(merch_week.year).to eq date_check.year
        end
      end
    end
  end

end
