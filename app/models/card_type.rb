class CardType < ActiveRecord::Base
  belongs_to :card
  belongs_to :type
end
