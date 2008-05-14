
class Page < ActiveRecord::Base
  # acts_as ...
  
  # Relationships
  has_one :content, :as => :owner
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
  belongs_to :user
  
  delegate :published?, :tags, :tag_list, :title, :text, :title=, :text=, :to => :content

  # Validations
  validates_associated :content
end