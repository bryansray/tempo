require File.dirname(__FILE__) + '/../spec_helper'

describe Attachment do
  
  it "should not be valid without content_type, size, and filename" do
    attachment = Attachment.create
    attachment.should_not be_valid
  end
  
  it "should be valid" do
    attachment = Attachment.create :content_type => 'test', :size => 10.megabytes, :filename => 'test.file'
    attachment.should be_valid
  end
  
  it "should be able to save" do
    attachment = Attachment.new :content_type => 'test', :size => 10.megabytes, :filename => 'test.file'
    attachment.save.should == true
  end

end
