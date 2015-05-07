require 'spec_helper'

describe MerchCalendar do
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


  it "#start_of_month" do
    expect(described_class.start_of_month(2014,1)).to be_a Date
  end

  it "#end_of_month" do
    expect(described_class.end_of_month(2014,1)).to be_a Date
  end

  it "#start_of_year" do
    expect(described_class.start_of_year(2014)).to be_a Date
  end

  it "#end_of_year" do
    expect(described_class.end_of_year(2014)).to be_a Date
  end


  it "#start_of_quarter" do
    expect(described_class.start_of_quarter(2014,1)).to be_a Date
  end

  it "#end_of_quarter" do
    expect(described_class.end_of_quarter(2014,1)).to be_a Date
  end

  it "#weeks_in_year" do
    expect(described_class.weeks_in_year(2014)).to be_a Fixnum
  end


  it "#merch_to_julian" do
    expect(described_class.merch_to_julian(1)).to be_a Fixnum
  end
  it "#julian_to_merch" do
    expect(described_class.julian_to_merch(1)).to be_a Fixnum
  end

end