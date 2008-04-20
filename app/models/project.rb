class Project < ActiveRecord::Base
  # Acts
  acts_as_taggable

  # Associations
  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  has_many :members
  has_many :teams, :through => :members, :group => "members.team_id"
  has_many :users, :through => :members, :group => "members.user_id"
  
  has_many :cards
  has_many :card_types, :class_name => "Type"
  has_many :properties, :as => :scope
  
  # Validations
  validates_presence_of :name
  
  # HACK : This needs to be re-factored, the only reason it is here is to acts as an Interface for Tag#show
  def title
    name
  end
  
  def to_s
    self.name
  end

  def properties
    Property.find :all, :conditions => ["scope_type = ? OR scope_type IS NULL", 'Project'], :order => 'name'
  end
end
