// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery.ui.core
//= require jquery.ui.widget
//= require jquery.ui.mouse
//= require jquery.ui.sortable
//= require ckeditor-jquery
//= require_tree .


$(function() {
	$('form').on('click', '.remove_fields', function (e) {
		$(this).prev('input[type=hidden]').val('1');
		$(this).closest('fieldset').hide();
		e.preventDefault();
	});

	$('form').on('click', '.add_fields', function (e) {
		var time = new Date().getTime(),
			regexp = new RegExp($(this).data('id'), 'g'),
			callback = $(this).data('callback');
		var obj = $(this).prev('ul').append($(this).data('fields').replace(regexp, time));
		console.log(callback)
		MOJ.initNewContact(obj)
	    if ($.isFunction(callback)) {
	    	console.log('firing callback')
	    	callback(obj);
		}
		e.preventDefault();
	});

	var filters = $('#filters').hide();
	$('#advanced-search').click(function (e) { 
			e.preventDefault();
			filters.toggle('fast');
	});
});