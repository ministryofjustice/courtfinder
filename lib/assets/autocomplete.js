// Constructor
var Predictions = function(options) {

	this.defaults = {
		search: $('#search'),
		results: $('#results'),
		active: false,
		selectedResult: null,
		pos: search.position(),
		klass: 'selected',
		minText: 2
	};

	this.settings = $.extend({'', this.defaults, options})

	this.search = $(this.settings.search);

};