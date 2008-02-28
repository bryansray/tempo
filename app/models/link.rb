class Link < ActiveRecord::Base
  has_one :content, :as => :owner, :dependent => :destroy
  belongs_to :user
  
  validates_presence_of :url, :title
  validates_associated :content
  
  def save
    super
    content.save
  end
  
  def title
    content.title
  end

  def title=(title)
    if content.nil?
      self.build_content(:title => title, :text => "Default Text")
    else
      content.title = title
    end
  end
  
  def description
    content.text
  end
  
  def description=(description)
    if content.nil?
      self.build_content(:text => description)
    else
      content.text = description
    end
  end
end