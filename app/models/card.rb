class Card < ActiveRecord::Base
  # Acts As ...
  acts_as_taggable
  
  # Associations
  has_one :content, :as => :owner
  
  has_many :card_types, :dependent => :destroy
  has_many :card_properties, :dependent => :destroy
  has_many :properties, :through => :card_properties
  has_many :types, :through => :card_types
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  belongs_to :project
  belongs_to :iteration
  belongs_to :team

  # Validations
  validates_presence_of :title
  
  def title
    content.nil? ? "" : content.title
  end
  
  def title=(value)
    content.nil? ? build_content(:title => value) : content.title = value
  end
  
  def description
    content.text unless content.nil?
  end
  
  def description=(value)
    content.nil? ? build_content(:text => value) : content.text = value
  end
  
  def user
    content.user.nil? ? '' : content.user
  end
  
  def to_s
    content.title
  end
  
  # TODO : Should this be a first class model rather than a property?
  def status
    cp = self.card_properties.find( :first, :include => :property, :conditions => "properties.name = 'Status' AND properties.scope_id IS NULL" )
    cp.option.nil? ? '' : cp.option.name
  end
  
  def merged_audits
  	audits = self.audits
  	self.card_properties.each do |cp|
  		audits += cp.audits
  	end
  	return audits
  end
end
