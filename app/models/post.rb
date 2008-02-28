class Post < ActiveRecord::Base
  # acts_as ...

  # Associations
  has_one :content, :as => :owner

  belongs_to :blog
  belongs_to :user

  has_many :comments, :as => :commentable, :dependent => :destroy
  
  # Validations
  validates_associated :content
  
  def title
    content.nil? ? "" : content.title
  end
  
  def title=(value)
    content.nil? ? build_content(:title => value) : content.title = value
  end
  
  def text
    content.text
  end
  
  def text=(value)
    content.nil? ? build_content(:text => value) : content.text = value
  end
  
  def published?
	content.published?
  end
  
  def published_at
    content.published_at
  end
  
  def published_at=(value)
    content.nil? ? build_content(:published_at => value) : content.published_at = value
  end
  
  def tags
    content.tags
  end
  
  def tag_list
	content.tag_list
  end
  
  def versions
    content.versions
  end
  
  def build_comment(*args)
    comments.build(*args)
  end
  
  def create_comment(*args)
    comments.create(*args)
  end
  
  def number_of_comments
    comments.count
  end
  
  def has_comments?
    comments.any?
  end
  
  def commentless?
    comments.empty?
  end
  
  def find_widgets(*args)
    comments.find(*args)
  end
  
  protected
  	
  def self.find_published(*args)
	options = args.extract_options!
	options.merge!(:include => :content, :conditions => ["contents.published = ?", true])
	
	case args.first
		when :first then find_initial(options)
		when :all then find_every(options)
		else find_from_ids(args, options)
	end
  end
end