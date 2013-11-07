// TODO
// done - Recognise Postcode
// done - Cache results
// done - Display results
// done - Cursor through results and enter to select
// done - Match term anywhere (uses Ruby)
// done - Highlight match
// done - Prevent fire of search on cursor movement
// done - Position with input box
// done - Escape key closes predictions
// done - Limit results length to ~20

$(function () {
	
	var search = $('#search-main'),
		results = $('#results'),
		active = false,
		selectedResult = null,
		klass = 'selected',
		minText = 0,
		postcode = /^([g][i][r][0][a][a])$|^((([a-pr-uwyz]{1}\d{1,2})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1,2})|([a-pr-uwyz]{1}\d{1}[a-hjkps-uw]{1})|([a-pr-uwyz]{1}[a-hk-y]{1}\d{1}[a-z]{1})) ?(\d[abd-hjlnp-uw-z]{2})?)$/i;
	
	var showResults = function () {
		active = true;
		return results.show();
	};
	
	var hideResults = function () {
		active = false;
		return results.delay(200).fadeOut(0); // add delay so we have time to click links before they disappear. use fade, as delay needs to work with an animation so hide doesn't work.
	};
	
	var markMatched = function (term, text) {
		var reg = new RegExp(term, 'gi');
		return text.replace(reg, '<b>$&</b>');
	};

    var processTextualInput = function(term) {
        if (term.length > minText) {
            if (postcode.test(term)) {
                results.html("<ul><li>It looks you've entered a postcode<br /><small>Press enter to find a court near " + term + "</small></li></ul>");
                showResults()
            } else {
                // Find a match client side
                var patt = new RegExp(term, 'i'),
                matches = [], list;
                
                var listResults = function (items) {
                    var name, i = 0, results = [], item;
                    
                    while (i < items.length && i < 14) {
                        item = items[i];
                        name = markMatched(term, item[0]);
                        results.push('<li><a href="/courts/' + item[1] + '">' + name + '</a></li>');
                        i++;
                    }
                    
                    return results
                }

                var next = function() {
                    for (var i = 0; i < moj.courts.length; i++) {
                        if (patt.test(moj.courts[i][0])) {
                            matches.push(moj.courts[i]);
                        }
                    }
                    
                    if (matches.length) {
                        list = listResults(matches);
                        if (matches.length > list.length) {
                            list.push('<li style="border-top:1px solid #000">Continue typing to see more results</li>')
                        }
                        results.html('<ul>' + list.join('') + '</ul>');
                        showResults()
                    } else {
                        hideResults()
                    }
                }
                
                if (typeof moj.courts === "undefined") {
                    $.get("/courts.json?compact=1", function(data) {
                        moj.courts = data;
                        next();
                    });
                } else {
                    next();
                }
            }
        } else {
            hideResults()
        }
    };

	// Only run on pages where the search box is found
	if (search.length) {
		// Position the predictions under the search box
		pos = search.position();
		results.css({
			position: 'absolute',
			width: search.outerWidth() - 4,
			top: pos.top + search.outerHeight() - parseInt(search.css('borderBottomWidth')) - 1,
			left: pos.left + parseInt(search.css('marginLeft')) - 1
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
                        .on('compositionupdate', function() {
                            // This is a workaround for Chrome on Android.
                            var term = $.trim($(this).val());
		            processTextualInput(term);
                        }).keyup(function(e) {
                            var term, k = e.keyCode;
                            // Allow only characters, numbers, space and hyphen
                            if (!((k === 8 || k === 32 || k === 189) || (k >= 65 && k <= 90) || (k >= 48 && k <= 57))) { // backspace, spacebar, hyphen (8, 32, 189), a - z (65 - 90) or 0 - 9 (48 - 57)
                                return;
                            }

                            term = $.trim($(this).val());
                            processTextualInput(term);
                        })
			.blur(function () {
				hideResults()
			})
			.focus(function () {
				showResults()
			});
		
		$(document).keyup(function (e) {
			if (e.keyCode === 191) { // forward slash
				search.focus()
			}
		});
	};

	var form = $('#local-locator-form'),
	  submit = $('[type=submit]', form);

	// test whether we allow the form to be submitted
	var submitable = function () {
		return !!$.trim(search.val()).length;
	};

	// disable form until search box contains a string
	form.on('submit', function (e) {
		if (!submitable()) {
			e.preventDefault();
		};
	});

	// disable submit button until search box contains a string
	search.on('keyup', function (e) {
		submit.attr('disabled', !submitable());
	}).keyup();

	search.focus()
});
