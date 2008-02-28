class CardProperty < ActiveRecord::Base
  belongs_to :card
  belongs_to :property
  belongs_to :option
end
