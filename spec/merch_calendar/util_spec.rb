require 'spec_helper'

describe MerchCalendar::Util do

  describe "#weeks_for_month" do
    context "correct number of weeks" do
      it "returns 4 weeks for a 4-week month" do
        weeks = MerchCalendar.weeks_for_month(2014, 4)
        expect(weeks.size).to eq 4
      end
      
      it "returns 5 weeks for a 5-week month" do
        weeks = MerchCalendar.weeks_for_month(2014, 3)
        expect(weeks.size).to eq 5
      end

      it "returns 5 weeks for a 4-week end month if leap year" do
        weeks = MerchCalendar.weeks_for_month(2012, 1)
        expect(weeks.size).to eq 5

        weeks = MerchCalendar.weeks_for_month(2014, 1)
        expect(weeks.size).to eq 4
      end
    end

    context "gives correct weeks" do
      let!(:weeks) { MerchCalendar.weeks_for_month(2014,1) }
      
      it "misc checks" do
        expect(weeks.size).to eq 4
      end

      it "#week" do
        expect(weeks[0].week).to eq 1
        expect(weeks[1].week).to eq 2
        expect(weeks[2].week).to eq 3
        expect(weeks[3].week).to eq 4
      end

      it "#date" do
        expect(weeks[0].date).to eq Date.new(2015,1,4)
        expect(weeks[1].date).to eq Date.new(2015,1,11)
        expect(weeks[2].date).to eq Date.new(2015,1,18)
        expect(weeks[3].date).to eq Date.new(2015,1,25)
      end

      it "#start_of_week" do
        expect(weeks[0].start_of_week).to eq Date.new(2015,1,4)
        expect(weeks[1].start_of_week).to eq Date.new(2015,1,11)
        expect(weeks[2].start_of_week).to eq Date.new(2015,1,18)
        expect(weeks[3].start_of_week).to eq Date.new(2015,1,25)
      end
      
      it "#start_of_year" do
        expect(weeks.map(&:start_of_year)).to all( eq Date.new(2014,2,2) )
      end

      it "#end_of_year" do
        expect(weeks.map(&:end_of_year)).to all( eq Date.new(2015,1,31) )
      end

      it "#month" do
        expect(weeks.map(&:month)).to all( eq 1 )
      end

    end
  end

  describe '#get_merch_month_param' do
    let(:retail_calendar) { MerchCalendar::RetailCalendar.new }
    before(:each) do
      allow(MerchCalendar).to receive(:retail_calendar).and_return(retail_calendar)
    end

    context "valid calls" do
      before(:each) do
        expect(retail_calendar).to receive(:start_of_month).with(2014, 1)
      end      
      it "assumes an integer is a julian month" do
        MerchCalendar.start_of_month(2014, 2)
      end

      context "when passed a hash" do
        it "accepts :month as julian month" do
          MerchCalendar.start_of_month(2014, month: 2)
        end

        it "accepts :julian_month as julian month" do
          MerchCalendar.start_of_month(2014, julian_month: 2)
        end

        it "accepts :merch_month as merch month" do
          MerchCalendar.start_of_month(2014, merch_month: 1)
        end
      end
    end

    context "errors" do
      before(:each) do
        expect(retail_calendar).to_not receive(:start_of_month)
      end
      it { expect { MerchCalendar.start_of_month(2014, :april) }.to raise_error(ArgumentError) }
    end
  end
end
