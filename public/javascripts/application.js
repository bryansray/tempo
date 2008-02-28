// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/*
 * Not going to use this function for now ....

function load_panels(defaultOptions, panelIds) {
	if (!panelIds)
		return;
	
	for (var i = 0; i < panelIds.length; i++) {
		options = panelIds[i];

		for (key in defaultOptions)
		{
			options[key] = defaultOptions[key];
		}
		
		p = new Ext.Panel(options);
	}
}

 */	

Ext.DataCert = function(){
	var message_control;
	
	function create_box(t, s) {
		return ['<div class="msg">',
		 '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
		 '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc"><h3>', t, '</h3>', s, '</div></div></div>',
		 '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
		 '</div>'].join('');
	}
	
	return {
		msg : function(title, format) {
			if (!message_control)
			    message_control = Ext.DomHelper.insertFirst(document.body, {id: 'message_alert'}, true);
			
			message_control.alignTo(document, 't-t');
			
			var s = String.format.apply(String, Array.prototype.slice.call(arguments, 1));
			var m = Ext.DomHelper.append(message_control, {html: create_box(title, s)}, true);

			m.slideIn('t').pause(3).ghost('t', {remove:true});			
		}
	}
}();

function msg(title) {
	var message_alert;
	

}

function getTagsToApply(tagPickerId)
{
	var s = [];
	var tags = $(tagPickerId).getElementsByTagName( 'a' );
	for( var i = 0; i < tags.length; i++ )
	{
		if ( $(tags[i]).hasClassName( 'on' ) )
			s[s.length] = tags[i].firstChild.nodeValue;
	}
	return s.join( "," );
}
