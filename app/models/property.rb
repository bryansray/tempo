class Property < ActiveRecord::Base
  # Associations
  belongs_to :scope, :polymorphic => true
  has_many :card_properties, :dependent => :destroy 
  has_many :cards, :through => :card_properties
  has_many :options
  
  # Validations
  validates_presence_of :name
  
  def to_s
	self.name
  end
end
