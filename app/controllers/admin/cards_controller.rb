class Admin::CardsController < ApplicationController
  protect_from_forgery :except => [:set_value_for]

  def set_value_for
    @card_property = CardProperty.find_or_create_by_card_id_and_property_id(params[:id], params[:property_id])

    respond_to do |format|
      if @card_property.update_attribute :option_id, params[:option_id]
        format.js
      end
    end
  end
end
