require File.dirname(__FILE__) + '/../spec_helper'

describe Post, "with fixtures loaded" do
  fixtures :posts, :contents, :blogs, :users, :content_versions
  
  before(:each) do
    @post = posts(:one)
  end

  it "should be valid" do
    @post.should be_valid
  end
  
  it "should have a title property that returns content.title" do
    @post.title.should == contents(:one).title
  end
  
  it "should have a title= property that will set content.title" do
    @post.title = "Title"
    @post.title.should == "Title"
  end
  
  it "should have a text property that will return content.text" do
    @post.text.should == contents(:one).text
  end
  
  it "should have a text= property that will set content.text" do
    @post.text = "Text"
    @post.text.should == "Text"
  end
  
  it "should have a published? property that returns whether or not the content is published" do
	@post.should be_published
  end

  it "should have a published_at property that it gets from its associated content" do
    @post.published_at.should eql(contents(:one).published_at)
  end
  
  it "should have a tags property that refers to content.tags" do
    @post.should have(2).tags
  end
  
  it "should belong to a blog" do
    @post.blog.should == blogs(:one)
  end
  
  it "should belong to a specific user" do
  	@post.user.should == users(:one)
  end
  
  it "should have content assigned to it" do
    @post.content.should == contents(:one)
  end
  
  it "should have content of class type Post" do
    @post.content.owner.class.should == Post
  end
  
  it "should create a new comment" do
    @post.create_comment(:name => "Bryan Ray", :content => Content.new(:title => "Title", :text => "Text"))
    
    @post.should have(1).comments
  end
  
  it "should have a number_of_comments that returns zero" do
    @post.number_of_comments.should == 0
  end
  
  it "should be commentless" do
    @post.should be_commentless
  end
end