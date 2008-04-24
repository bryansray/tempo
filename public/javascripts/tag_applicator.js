var TagApplicator = {
	editTags: function(panel_id) {
		$('tag-list-panel-' + panel_id).toggle();
		$('tag-editor-inputs-' + panel_id).toggle();
		$('tag_list_text-' + panel_id).focus();
	}
}