require File.dirname(__FILE__) + '/../../spec_helper'

describe "/password/new" do
  it "should render a form that has an email text field" do
    render '/passwords/new'
    response.should have_tag('#email')
  end
end