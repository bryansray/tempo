class Content < ActiveRecord::Base
  before_save :set_published_at
  
  # Acts As ...
  acts_as_taggable
  acts_as_ferret(:fields => [:title, :text])

  # Associations
  belongs_to :owner, :polymorphic => true
  belongs_to :user
  
  has_many :attachments, :order => "attachments.filename"
  
  protected
  def self.published_pages
    find(:all, :conditions => ["published = ? AND owner_type = ?", true, 'Page'])
  end
  
  private
  def set_published_at
    if published_at.nil? 
      self.published_at = DateTime.now    
    end
  end
end