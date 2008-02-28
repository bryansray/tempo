require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::CardsController, "handling POST /admin/cards/1/set_value_for?property_id=1&option_id=1" do
  before(:each) do
    @card_property = mock_model(CardProperty, :to_param => 1)
    CardProperty.stub!(:find_or_create_by_card_id_and_property_id).and_return(@card_property)
  end
  
  def do_post
    post :set_value_for, :property_id => 1, :option_id => 1, :id => 1
  end
  
  def post_with_successful_save
    @card_property.should_receive(:update_attribute).with(:option_id, "1").and_return(true)
    do_post
  end
  
  it "should be successful" do
    post_with_successful_save
    response.should be_success
  end
  
  it 'should find the specified card property when passed the card id and the property id' do
    CardProperty.should_receive(:find_or_create_by_card_id_and_property_id).and_return(@card_property)
    post_with_successful_save
  end
  
  it "should render the RJS template on successful update" do
    post_with_successful_save
    response.should render_template("set_value_for")
  end
  
  it 'should assign the card property to the associated view' do
    post_with_successful_save
    assigns[:card_property].should eql(@card_property)
  end
end
