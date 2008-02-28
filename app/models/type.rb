class Type < ActiveRecord::Base
  # Validations
  validates_presence_of :name
  
  # Associations
  has_many :card_types, :dependent => :destroy
  has_many :cards, :through => :card_types
  
  belongs_to :project
end
