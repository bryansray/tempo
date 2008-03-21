var rules = {
	// convert any elements with class="panel" into an Ext Panel
	// uses the first <h2> element it finds as the title for the panel
	'div.panel': function(el){
		var title = '';
		var h2s = Ext.query('h2', el);
		if (h2s.length > 0) {
			var h2 = Ext.get(h2s[0]);
			title = h2.dom.innerHTML;
			h2.remove();
		}
		var newEl = Ext.DomHelper.insertAfter( el, { tag: "div" } );
		
		new Ext.Panel({
			//html:html,
			contentEl:el,
			renderTo:newEl,
			title:title,
			header:true,
			collapsible:true,
			collapsed: Ext.get(el).hasClass( "collapsed" )
		});
	}
};
StyleScripts.register(rules);		