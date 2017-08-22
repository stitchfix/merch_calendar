require "spec_helper"

RSpec.describe MerchCalendar::StitchFixFiscalYearCalendar do
  describe "#weeks_in_year" do
    it "returns 53 for a leap year - 2013" do
      expect(subject.weeks_in_year(2013)).to eq 53
    end

    it "returns 52 for a normal year - 2014" do
      expect(subject.weeks_in_year(2014)).to eq 52
    end

    it "returns 52 for a normal year - 2015" do
      expect(subject.weeks_in_year(2015)).to eq 52
    end

    it "returns 52 for a normal year - 2016" do
      expect(subject.weeks_in_year(2016)).to eq 52
    end

    it "returns 52 for a normal year - 2017" do
      expect(subject.weeks_in_year(2017)).to eq 52
    end

    it "returns 52 for a normal year - 2018" do
      expect(subject.weeks_in_year(2018)).to eq 52
    end

    it "returns 53 for a leap year - 2019" do
      expect(subject.weeks_in_year(2019)).to eq 53
    end
    
    it "returns 52 for a normal year - 2020" do
      expect(subject.weeks_in_year(2020)).to eq 52
    end
    
    it "returns 53 for a leap year - 2024" do
      expect(subject.weeks_in_year(2024)).to eq 53
    end
    
    it "returns 52 for a normal year - 2025" do
      expect(subject.weeks_in_year(2025)).to eq 52
    end
  end

  describe "#start_of_week" do
    it "returns the correct date for 2017-1-1 (2017-Aug-wk1)" do
      expect(subject.start_of_week(2017, 1, 1)).to eq Date.new(2016, 7, 31)
    end

    it "returns the correct Date for 2018-1-1 (2018-Aug-wk1)" do
      expect(subject.start_of_week(2018, 1, 1)).to eq Date.new(2017, 7, 30)
    end

    it "returns the correct Date for 2019-1-1 (2019-Aug-wk1)" do
      expect(subject.start_of_week(2019, 1, 1)).to eq Date.new(2018, 7, 29)
    end
    
    it "returns the correct Date for 2020-1-1 (2020-Aug-wk1)" do
      expect(subject.start_of_week(2020, 1, 1)).to eq Date.new(2019, 8, 4)
    end
  end

  describe "#end_of_week" do
    it "returns the correct date for 2017-6-1 (2017-Jan-wk1)" do
      expect(subject.end_of_week(2017, 6, 1)).to eq Date.new(2017, 1, 7)
    end

    it "returns the correct Date for 2018-6-4 (2018-Jan-wk4)" do
      expect(subject.end_of_week(2018, 6, 4)).to eq Date.new(2018, 1, 27)
    end

    it "returns the correct Date for 2019-10-3 (2019-May-wk3)" do
      expect(subject.end_of_week(2019, 10, 3)).to eq Date.new(2019, 5, 18)
    end
    
    it "returns the correct Date for 2019-12-5 (2019-Jul-wk5)" do
      expect(subject.end_of_week(2019, 12, 5)).to eq Date.new(2019, 8, 3)
    end
    
    it "returns the correct Date for 2020-2-5 (2020-Sept-wk5)" do
      expect(subject.end_of_week(2020, 2, 5)).to eq Date.new(2019, 10, 5)
    end
  end

  describe "#start_of_month" do
    it "returns the correct date for 2018-1 AKA 2018-Aug" do
      expect(subject.start_of_month(2018, 1)).to eq Date.new(2017, 7, 30)
    end

    it "returns the correct date for 2019-1 AKA 2019-Aug" do
      expect(subject.start_of_month(2019, 1)).to eq Date.new(2018, 7, 29)
    end
    
    it "returns the correct date for 2019-1 AKA 2019-Aug" do
      expect(subject.start_of_month(2020, 1)).to eq Date.new(2019, 8, 4)
    end
  end

  describe "#end_of_month" do
    it "returns the correct date for 2018-1 AKA 2018-Aug" do
      expect(subject.end_of_month(2018, 1)).to eq Date.new(2017, 8, 26)
    end

    it "returns the correct date for 2019-1 AKA 2019-Aug" do
      expect(subject.end_of_month(2019, 1)).to eq Date.new(2018, 8, 25)
    end
    
    it "returns the correct date for 2020-1 AKA 2020-Aug" do
      expect(subject.end_of_month(2020, 1)).to eq Date.new(2019, 8, 31)
    end
    
    it "returns the correct date for 2020-12 AKA 2020-July" do
      expect(subject.end_of_month(2020, 12)).to eq Date.new(2020, 8, 1)
    end
  end

  describe "#start_of_quarter" do
    it "returns the correct date for 2018-Q1" do
      expect(subject.start_of_quarter(2018, 1)).to eq Date.new(2017, 7, 30)
    end

    it "returns the correct date for 2018-Q4" do
      expect(subject.start_of_quarter(2018, 4)).to eq Date.new(2018, 4, 29)
    end

    it "returns the correct date for 2019-Q1" do
      expect(subject.start_of_quarter(2019, 1)).to eq Date.new(2018, 7, 29)
    end
    
    it "returns the correct date for 2019-Q2" do
      expect(subject.start_of_quarter(2019, 2)).to eq Date.new(2018, 10, 28)
    end
    
    it "returns the correct date for 2019-Q3" do
      expect(subject.start_of_quarter(2019, 3)).to eq Date.new(2019, 1, 27)
    end
    
    it "returns the correct date for 2020-Q4" do
      expect(subject.start_of_quarter(2020, 4)).to eq Date.new(2020, 5, 3)
    end
  end

  describe "#end_of_quarter" do
    it "returns the correct date for 2018-Q1" do
      expect(subject.end_of_quarter(2018, 1)).to eq Date.new(2017, 10, 28)
    end

    it "returns the correct date for 2018-Q4" do
      expect(subject.end_of_quarter(2018, 4)).to eq Date.new(2018, 7, 28)
    end

    it "returns the correct date for 2019-Q1" do
      expect(subject.end_of_quarter(2019, 1)).to eq Date.new(2018, 10, 27)
    end
    
    it "returns the correct date for 2019-Q2" do
      expect(subject.end_of_quarter(2019, 2)).to eq Date.new(2019, 1, 26)
    end
    
    it "returns the correct date for 2019-Q3" do
      expect(subject.end_of_quarter(2019, 3)).to eq Date.new(2019, 4, 27)
    end
    
    it "returns the correct date for 2020-Q4" do
      expect(subject.end_of_quarter(2020, 4)).to eq Date.new(2020, 8, 1)
    end
  end

  describe "#start_of_year" do
    it "returns the correct date for 2018" do
      expect(subject.start_of_year(2018)).to eq Date.new(2017, 7, 30)
    end

    it "returns the correct date for 2019" do
      expect(subject.start_of_year(2019)).to eq Date.new(2018, 7, 29)
    end
    
    it "returns the correct date for 2020" do
      expect(subject.start_of_year(2020)).to eq Date.new(2019, 8, 4)
    end
    
    it "returns the correct date for 2024, the next 53-week year" do
      expect(subject.start_of_year(2024)).to eq Date.new(2023, 7, 30)
    end
    
    it "returns the correct date for 2025, the next year after the 53-week year" do
      expect(subject.start_of_year(2025)).to eq Date.new(2024, 8, 4)
    end
  end

  describe "#end_of_year" do
    it "returns the correct date for 2017" do
      expect(subject.end_of_year(2017)).to eq Date.new(2017, 7, 29)
    end

    it "returns the correct date for 2018" do
      expect(subject.end_of_year(2018)).to eq Date.new(2018, 7, 28)
    end

    it "returns the correct date for 2019" do
      expect(subject.end_of_year(2019)).to eq Date.new(2019, 8, 3)
    end
    
    it "returns the correct date for 2020" do
      expect(subject.end_of_year(2020)).to eq Date.new(2020, 8, 1)
    end
    
    it "returns the correct date for 2024, the next 53-week year" do
      expect(subject.end_of_year(2024)).to eq Date.new(2024, 8, 3)
    end
    
    it "returns the correct date for 2025, the next year after the 53-week year" do
      expect(subject.end_of_year(2025)).to eq Date.new(2025, 8, 2)
    end
  end
  
  describe "#merch_months_in" do
    it "returns merch date for start_date if start_date is the same as end_date" do
      start_date = Date.new(2018,8,1)
      end_date = start_date
      start_merch_date = subject.start_of_month(start_date.year, merch_month: start_date.month)
    
      merch_months = subject.merch_months_in(start_date, end_date)
    
      expect(merch_months.count).to be(1)
      expect(merch_months.first.year).to eq start_merch_date.year
      expect(merch_months.first.month).to eq start_merch_date.month
      expect(merch_months.first.day).to eq start_merch_date.day
    end
    
    it "returns valid merch dates for 2014" do
      start_date = Date.new(2018, 8, 1)
      end_date = Date.new(2019, 7, 1)
    
      merch_months = subject.merch_months_in(start_date, end_date)
      expect(merch_months.count).to be 11
    
      expect(merch_months[0].year).to be 2018
      expect(merch_months[4].year).to be 2019
      expect(merch_months[10].year).to be 2019
      p "Merch Months: #{merch_months[0].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[1].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[2].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[3].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[4].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[5].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[6].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[7].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[8].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[9].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[10].strftime('%Y-%m-%d')}"
      p "Merch Months: #{merch_months[11].strftime('%Y-%m-%d')}"


      expect(merch_months[0].strftime('%Y-%m-%d')).to eq  '2018-09-02'
      expect(merch_months[1].strftime('%Y-%m-%d')).to eq  '2018-10-07'
      expect(merch_months[2].strftime('%Y-%m-%d')).to eq  '2018-11-04'
      expect(merch_months[3].strftime('%Y-%m-%d')).to eq  '2018-12-02'
      expect(merch_months[4].strftime('%Y-%m-%d')).to eq  '2019-01-06'
      expect(merch_months[5].strftime('%Y-%m-%d')).to eq  '2019-02-03'
      expect(merch_months[6].strftime('%Y-%m-%d')).to eq  '2019-03-03'
      expect(merch_months[7].strftime('%Y-%m-%d')).to eq  '2019-04-07'
      expect(merch_months[8].strftime('%Y-%m-%d')).to eq  '2019-05-05'
      expect(merch_months[9].strftime('%Y-%m-%d')).to eq  '2019-06-02'
      expect(merch_months[10].strftime('%Y-%m-%d')).to eq '2019-07-07'
    end
  end

  describe "#julian_to_fiscal" do
    it "converts julian months to fiscal months" do
      expect(subject.julian_to_fiscal(8)).to eq 1
      expect(subject.julian_to_fiscal(9)).to eq 2
      expect(subject.julian_to_fiscal(10)).to eq 3
      expect(subject.julian_to_fiscal(11)).to eq 4
      expect(subject.julian_to_fiscal(12)).to eq 5
      expect(subject.julian_to_fiscal(1)).to eq 6
      expect(subject.julian_to_fiscal(2)).to eq 7
      expect(subject.julian_to_fiscal(3)).to eq 8
      expect(subject.julian_to_fiscal(4)).to eq 9
      expect(subject.julian_to_fiscal(5)).to eq 10
      expect(subject.julian_to_fiscal(6)).to eq 11
      expect(subject.julian_to_fiscal(7)).to eq 12
      expect { subject.julian_to_fiscal(13) }.to raise_error ArgumentError
      expect { subject.julian_to_fiscal(0) }.to raise_error ArgumentError
    end
  end
  describe "#fiscal_to_julian" do
    it "converts fiscal months to julian months" do
      expect(subject.fiscal_to_julian(1)).to eq 8
      expect(subject.fiscal_to_julian(2)).to eq 9
      expect(subject.fiscal_to_julian(3)).to eq 10
      expect(subject.fiscal_to_julian(4)).to eq 11
      expect(subject.fiscal_to_julian(5)).to eq 12
      expect(subject.fiscal_to_julian(6)).to eq 1
      expect(subject.fiscal_to_julian(7)).to eq 2
      expect(subject.fiscal_to_julian(8)).to eq 3
      expect(subject.fiscal_to_julian(9)).to eq 4
      expect(subject.fiscal_to_julian(10)).to eq 5
      expect(subject.fiscal_to_julian(11)).to eq 6
      expect(subject.fiscal_to_julian(12)).to eq 7
      expect { subject.fiscal_to_julian(13) }.to raise_error ArgumentError
      expect { subject.fiscal_to_julian(0) }.to raise_error ArgumentError
    end
  end
end
