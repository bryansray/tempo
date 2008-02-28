require File.dirname(__FILE__) + '/../spec_helper'

describe Iteration, "with fixtures loaded" do
  fixtures :iterations, :cards, :card_properties, :options, :properties, :teams
  
  before(:each) do
    @iteration1 = iterations(:one)
	@iteration2 = iterations(:two)
	@iteration3 = Iteration.create( :started_at => Date.today-6, :ended_at => Date.today+7 )
  end

  it "should be valid" do
    @iteration1.should be_valid
  end
  
  it "should be 10 working days" do
	@iteration1.days.should == 10
  end
  
  it "should return the number of working days for 'day of' if today's date is post ended_date" do
	@iteration1.day_of.should == 10
  end
  
  it "should return current 'day of' the iteration" do
	@iteration3.day_of.should == 5
  end
  
  it "should have multiple cards" do
    @iteration2.should have(2).cards
  end
  
  it "should have multiple properties" do
    @iteration1.should have(2).properties
  end
  
  it "should belong to a team" do
    @iteration1.team.title.should == "Team 1"
  end
  
  it "should be able to count completed cards" do
	@iteration2.should have(1).cards_completed
  end
  
  it "should be able to sum estimated hours for cards" do
	@iteration2.card_hours.should == 60
  end
  
  it "should be able to sum estimated hours when there are no cards" do
	@iteration3.card_hours.should == 0
  end
  
  it "should be able to sum actual hours for cards that are complete" do
	@iteration2.actual_hours.should == 10.5
  end
  
  it "should be able to sum acutal hours when there are no cards" do
	@iteration3.actual_hours.should == 0
  end
  
  it "should be able to sum remaining hours for non-complete cards" do
	@iteration2.remaining_hours.should == 55
  end
  
  it "should be able to sum remaining hours for non-complete cards when there are no cards" do
	@iteration3.remaining_hours.should == 0
  end
  
  it "should be able to calculate real hours which is actual + remaining" do
	@iteration2.real_hours.should == 65.5
  end
end
