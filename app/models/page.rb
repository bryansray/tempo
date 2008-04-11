
class Page < ActiveRecord::Base
  # acts_as ...
  
  # Relationships
  has_one :content, :as => :owner
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
  belongs_to :user

  # Validations
  validates_associated :content
  
  delegate :published?, :tags, :tag_list, :title, :title=, :text, :text=, :to => :content
end