class Blog < ActiveRecord::Base
	# Associations
	belongs_to :user
	
	has_many :posts, :order => "posts.created_at"
  has_many :published_posts, :class_name => "Post", :include => :content, :conditions => ["contents.published = ?", true], :order => "posts.created_at DESC"
	
	# Validations
	validates_presence_of :name
  
  def test
  end
end
