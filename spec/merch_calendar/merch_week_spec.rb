require 'spec_helper'

module MerchCalendar
  describe MerchWeek do

    describe ".find" do
      it "returns an array of weeks" do
        weeks = MerchWeek.find(2014,1)
        expect(weeks).to be_an Array
        expect(weeks.size).to eq 4
      end
      
      it "with year, month, week" do
        mw = MerchWeek.find(2014,1,1)
        expect(mw.year).to eq 2014
        expect(mw.month).to eq 1
        expect(mw.merch_month).to eq 12
        expect(mw.week).to eq 1
      end
    end
    
    describe ".from_date" do

      context "parameters" do
        context "allows valid date types" do
          it "allows a date string" do
            mw = MerchWeek.from_date("1990-10-01")
            expect(mw.date.to_s).to eq "1990-10-01"
            expect(mw.date.month).to eq 10
          end
        end

        context "throws exception for invalid types" do
          it { expect{MerchWeek.from_date}.to raise_error(ArgumentError) }
          it { expect{MerchWeek.from_date(1)}.to raise_error(ArgumentError) }
          it { expect{MerchWeek.from_date(true)}.to raise_error(ArgumentError) }
          it { expect{MerchWeek.from_date(1.0)}.to raise_error(ArgumentError) }
        end

        context "throws exception for invalid dates" do
          it { expect{MerchWeek.from_date("2015")}.to raise_error(ArgumentError) }
          it { expect{MerchWeek.from_date("2015-04")}.to raise_error(ArgumentError) }
        end
      end
    end

    describe ".today" do
      it "returns a merch week based on today's date" do
        mw = MerchWeek.today
        expect(mw.date.to_s).to eq Date.today.to_s
      end
    end

    it "#end_of_week" do
      mw = MerchWeek.find(2014,1,1)

      expect(mw.end_of_week).to eq (mw.start_of_week + 6)
    end

    describe "#end_of_month" do
      it "for a 4 week month" do
        # mw = MerchWeek.find(2012, )
      end

      it "for a 5 week month"
      it "for a 4 to 5 week month in a leap year"
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

        # 2014
        OpenStruct.new(date: "2014-02-02", year: 2014, month: 2,  week: 1, quarter: 3, year_week: 1,  start_date: "2014-02-02"),
        OpenStruct.new(date: "2015-01-31", year: 2014, month: 1,  week: 4, quarter: 2, year_week: 52, start_date: "2014-02-02"),
        
        OpenStruct.new(date: "2014-02-01", year: 2013, month: 1,  week: 4, quarter: 2, year_week: 52, start_date: "2013-02-03"),
        
        OpenStruct.new(date: "2015-02-01", year: 2015, month: 2,  week: 1, quarter: 3, year_week: 1, start_date: "2015-02-01"),
        
      ].each do |date_check|

        context "using date '#{date_check.date}'" do
          let(:merch_week) { MerchWeek.from_date(date_check.date) }
          
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
end