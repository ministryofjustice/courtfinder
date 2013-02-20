// TODO
// Recognise Postcode
// Cache results
// done - Display results
// done - Cursor through results and enter to select
// done - Match term anywhere (uses Ruby)
// done - Highlight match
// done - Prevent fire of search on cursor movement
// done - Position with input box
// done - Escape key closes predictions
// Inifite scroll results

$(function () {
	
	var search = $('#search'),
		results = $('#results'),
		active = false,
		selectedResult = null,
		pos = search.position(),
		klass = 'selected',
		minText = 2;
	
	var showResults = function () {
		active = true;
		if (search.val().length > minText) {
			return results.show();
		}
	};
	
	var hideResults = function () {
		active = false;
		return results.delay(100).fadeOut(0); // add delay so we have time to click links before they disappear. use fade, as delay needs to work with an animation so hide doesn't work.
	};
	
	var markMatched = function (term, text) {
		var reg = new RegExp(term, 'gi');
		return text.replace(reg, '<b>$&</b>');
	};

	results.css({
		position: 'absolute',
		width: search.outerWidth() - parseInt(search.css('borderLeftWidth')) * 2,
		top: pos.top + search.outerHeight() - parseInt(search.css('borderBottomWidth')) - 3,
		left: pos.left
	});
	
	search
		.keydown(function (e) {
			var path;
			switch (e.keyCode) {
				
				case 38: // up arrow
				case 40: // down
					e.preventDefault();
					
					if (!active) {
						showResults();
						return;
					}
					
					selectedResult = results.find('li.' + klass).removeClass(klass);
					
					if (selectedResult.length) {
						switch (e.keyCode) {
							case 40:
								selectedResult = selectedResult.next('li');
								break;
							case 38:
								selectedResult = selectedResult.prev('li');
						}
					} 
					// Default to the first item
					else {
						selectedResult = results.find('li:first-child');
					}
					
					selectedResult.addClass(klass);

					break;
				
				case 13: // enter
					if (active) {
						path = results.find('li.selected a').attr('href');
						
						if (path.length) {
							e.preventDefault();
							window.location.href = path;
						}
					}
					break;
				
				case 27: // esc
					hideResults();
			}
		})
		.keyup(function (e) {
			var term,
				k = e.keyCode;
			
	    	// Allow only characters, numbers, space and hyphen
			if (!((k === 8 || k === 32 || k === 189) || (k >= 65 && k <= 90) || (k >= 48 && k <= 57))) { // backspace, spacebar, hyphen (8, 32, 189), a - z (65 - 90) or 0 - 9 (48 - 57)
				return;
			}
			
			term = $(this).val();

			if (term.length > minText) {
				// Find a match server side
				$.get('/courts.json', { search: term }, function (courtData) {
					var court, courts, name, i, len;

					if (courtData.length === 0) {
						hideResults();
					} else {
						courts = [];

						for (i = 0; i < courtData.length; i++) {
							court = courtData[i];
							name = markMatched(term, court.name);
							courts.push('<li><a href="/courts/' + court.id + '">' + name + '</a></li>');
						}
						
						results.html('<ul>' + courts.join('') + '</ul>');
						
						showResults();
					}
				});
			} else {
				hideResults();
			}
		})
		.blur(function () {
			hideResults();
		})
		.focus(function () {
			showResults();
		});
	
	$(document).keyup(function (e) {
		if (e.keyCode === 191) { // forward slash
			search.focus();
		}
	});
});
