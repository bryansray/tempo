class Page < ActiveRecord::Base
  # acts_as ...
  
  # Relationships
  has_one :content, :as => :owner
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
  belongs_to :user

  # Validations
  validates_associated :content
  
  def title
    content.title
  end
  
  def title=(value)
    content.nil? ? build_content(:text => value) : content.title = value
  end
  
  def published?
	content.published?
  end
  
  def tags
    content.tags
  end
  
  def tag_list
	content.tag_list
  end
  
  def text
    content.text
  end
  
  def text=(value)
    content.nil? ? build_content(:text => value) : content.text = value
  end
end
