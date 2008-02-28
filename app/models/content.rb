class Content < ActiveRecord::Base
  before_save :set_published_at
  
  # Acts As ...
  acts_as_versioned
  acts_as_taggable
  acts_as_ferret

  # Associations
  belongs_to :owner, :polymorphic => true
  belongs_to :user
  
  scope_out :published, :conditions => ["contents.published = ?", true]
  
  has_many :attachments, :order => "attachments.filename"

  # Validations
  validates_presence_of :text
  
  private
  def set_published_at
    if published_at.nil? 
      self.published_at = DateTime.now    
    end
  end
end