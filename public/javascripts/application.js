// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Event.observe(window, 'load', function() {
	$A(document.getElementsByClassName('alert')).each(function(o) {
		o.opacity = 100;
		Effect.Fade(o, { duration: 8.0})
	});
});

var Tempo = {
	notify: function(title, message) {
		Ext.DataCert.msg(title, message);
	}
};

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

// This supports the generic_update helpers. Given a link and form field, this object will allow the
// user to toggle to an editable view for the field by clicking the link. The object waits for the user
// to press the Enter key before submitting the value by calling the update_func function.
function PropertySetter( field_id, link_id, update_func, null_text )
{
  this.link_el = $(link_id);
  this.field_el = $(field_id);
  this.update_func = update_func;
  this.active = false;
  this.null_text = null_text || "";
  this.isSelect = false;
  this.init();
}

PropertySetter.prototype.init = function()
{
  switch ( this.field_el.tagName.toLowerCase() )
  {
    case 'input':
      this.field_el.observe( 'keypress', this.update.bindAsEventListener(this) );
      break;
    case 'select':
      this.field_el.observe( 'keypress', this.update.bindAsEventListener(this) );
      this.field_el.observe( 'change', this.update.bindAsEventListener(this) );
      this.isSelect = true;
      break;
  }
  this.field_el.observe( 'blur', this.reset.bindAsEventListener(this) );
  this.link_el.observe( 'click', this.setActive.bindAsEventListener(this) );
  this.working = document.createElement( "img" );
  this.working.src = "/images/dots-white.gif";
};
PropertySetter.prototype.toggle = function(event)
{
  this.field_el.toggle();
  this.link_el.toggle();
};
PropertySetter.prototype.setActive = function(event)
{
  this.toggle();
  
  // get the original value so that we can put it back in the textbox
  // if the user cancels the operation
  this.original_value = this.field_el.value;
  
  this.field_el.focus();
  this.active = true;
  return false;
};
PropertySetter.prototype.update = function(event)
{
  if ( ( event.keyCode == Event.KEY_RETURN || ( this.isSelect && event.keyCode != Event.KEY_ESC ) ) && this.active )
  {
    var el = event.element();
    this.update_func(el, el.value);
    this.link_el.firstChild.nodeValue = '';
    this.link_el.appendChild(this.working);
    this.active = false;
    this.toggle();
  }
  else if ( event.keyCode == Event.KEY_ESC )
  {
    this.reset();
  }
};
PropertySetter.prototype.reset = function(event)
{
  if ( this.active )
  {
    this.toggle();
    this.active = false;
    this.field_el.blur();
    this.field_el.value = this.original_value;
    this.resetLinkText();
  }
};
PropertySetter.prototype.success = function(request)
{
  this.working.remove();
  if ( request.responseJSON.success )
    this.updateLinkText();
  else
    this.resetLinkText();
};
PropertySetter.prototype.resetLinkText = function()
{
  if ( this.isSelect )
    this.link_el.firstChild.nodeValue = this.original_value == -1 ? this.null_text : $$('#' + this.field_el.id + ' option[value=' + this.original_value + ']')[0].text;
  else
    this.link_el.firstChild.nodeValue = this.original_value == "" ? this.null_text : this.original_value;
};
PropertySetter.prototype.updateLinkText = function()
{
  if ( this.isSelect )
    this.link_el.firstChild.nodeValue = this.field_el.value == -1 ? this.null_text : this.field_el.options[this.field_el.selectedIndex].text;
  else
    this.link_el.firstChild.nodeValue = this.field_el.value == "" ? this.null_text : this.field_el.value;
};