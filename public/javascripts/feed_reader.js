var FeedReader = {
	show: function(type) {
		$$('#recents div.FeedItem').each(function(item) {
			if (type == undefined)
				item.show();
			else {
			    if (item.hasClassName(type))
					item.show();
				else
					item.hide();
			}
		});
	}
}