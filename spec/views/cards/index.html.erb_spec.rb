require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/1/cards" do
  before(:each) do
    @property = mock_model(Property, :id => 1, :name => "Status")

    @not_set = mock_model(Option, :id => nil, :name => "(not set)")
    @completed = mock_model(Option, :id => 2, :name => "Completed", :to_param => 2)
    
    card1 = mock_model(Card, :id => 1, :title => "Card 1", :to_param => 1)
    card2 = mock_model(Card, :id => 2, :title => "Card 2", :to_param => 2)
    cards = [card1, card2]
    @lanes = []
    @lanes << [@not_set, *cards]
    @lanes << [@completed, *cards]
    assigns[:lanes] = @lanes
    assigns[:property] = @property
  end
  
  it "should display two lanes that each card can be sorted in to" do
    render '/cards/index'
    
    response.should have_tag('td#lane-1-')
    response.should have_tag('td#lane-1-2')
  end
  
  it "should display a list of cards broken up in to their lanes" do
    render '/cards/index'
    response.should have_tag('td#lane-1-') do
      with_tag('div#cards-container-') do
        with_tag('div#card-1')
        with_tag('div#card-2')
      end
    end
  end
  
  it "should render a column called '(not set)' that will let users set the value of that card to nil" do
    render '/cards/index'
    response.should have_tag('td#lane-1-') do
      with_tag('span.group')
    end
  end
end