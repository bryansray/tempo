/*******************************************************
Applies javascript to DOM objects by using CSS selectors. Cascading Style Scripts (CSS), if you will =)

A more object oriented prototype-aware port of Behaviour.js (http://www.bennolan.com/behaviour/)
Renamed to StyleScripts to accurately communicate the intent of the code (it's more than just behaviors!)

Usage Example:

	var rules = {
		// convert any elements with class="panel" into an Ext Panel
		'.panel': function(el){
			var html = el.innerHTML;
			el.innerHTML = '';
			
			new Ext.Panel({
				html:html,
				renderTo:el,
				header:true,
				collapsible:true
			});
		}
	};
	StyleScripts.register(rules);

	// Call StyleScripts.apply() directly to re-apply the rules (if you update the DOM, etc).

*******************************************************/
StyleScripts = new function StyleScripts(){
	/******[ private vars ]******/
	var StyleScripts = this;	// workaround for bug in ECMAScript Language Specification which causes 'this' to be set incorrectly for inner functions
	var cache = new Array;		// stores rulesets
	
	/******[ privileged methods ]******/
	// Store rules in cache
	this.register = function(rules){
		cache.push(rules);
	};

	// Apply rules stored in cache
	this.apply = function(){
		for (var i = 0; rules = cache[i]; i++){
			for (selector in rules){
				$$(selector).each(
					function(el){
						if (!(el.hasClassName('applied'))) rules[selector](el);
						el.addClassName('applied');
					}
				);
			}
		}
	};
	
	// Apply rules once DOM is ready
	document.observe('dom:loaded', StyleScripts.apply);
}