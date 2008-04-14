var Comments = {
	addComment: function(element_id) {
		comments = $(element_id);
		Tempo.notify('New Comment Created', '' )
	}
};

var CardProperties = {
    displayOptions: function(property_id) {
        $('property-' + property_id).hide();
        $('property-edit-' + property_id).show();
        $('property-edit-' + property_id).focus();
    },
    
    afterValueChanged: function (property_id) {
        var property = $('property-' + property_id)
        var propertyEdit = $('property-edit-' + property_id)
        
        property.innerHTML = propertyEdit.options[propertyEdit.selectedIndex].text;
        property.show();
        propertyEdit.hide();

    }
};

var _isDragged = false;
var SwimmingPool = {
    afterCardDrop: function afterCardDrop(drag, drop) {
        _isDragged = true;
        drag.select('img.card-updating-icon')[0].show();
        drop.select('.cards-container')[0].insert(drag, { 'position': 'bottom' });
        drag.setStyle({'left': 0, 'top': 0});
        
        dropped_values = drop.id.split("-")
        
        property_id = dropped_values[1]
        option_id = dropped_values[2]
        card_id = drag.id.split("-")[1]

        var params = 'property_id=' + property_id + '&option_id=' + option_id

        new Ajax.Request( '/admin/cards/' + card_id + '/set_value_for', 
            {
                asynchronous: true,
                evalScripts: true,
                parameters: params,
                onComplete: function(request) { SwimmingPool.afterCardUpdated(drag); }
            }
        );
    },

    afterCardUpdated: function (element) {
        element.select('img.card-updating-icon')[0].hide();
        element.highlight();
    },
    
    displayCardInfo: function displayCardInfo(event) {
        if (!_isDragged && this.getStyle('left') == "0px") 
        {
            console.info('Not Yet Implemented - Display an inline popup about this card.')
        }
        
        _isDragged = false;
    }
};
