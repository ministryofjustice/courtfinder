/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

// Initialise all moj modules
moj.init();

(function(){

  "use strict";

  // Admin
  // ==================================================================

  // Adding/removing records
  $('form').on('click', '.remove_fields', function (e) {
    e.preventDefault();
    $(this).prev('input[type=hidden]').val('1');
    $(this).closest('fieldset').hide();
  });

  $('form').on('click', '.add_fields', function (e) {
    e.preventDefault();
    var time = new Date().getTime(),
      regexp = new RegExp($(this).data('id'), 'g'),
      callback = $(this).data('callback'),
      sortable = $(this).siblings('ul.sortable'),
      fields = $($(this).data('fields').replace(regexp, time)),
      obj;
    
    if (sortable.length) {
      obj = sortable.append(fields);
    } else {
      obj = $(this).before(fields);
    }

    if (callback) {
      moj[callback](obj, fields);
    }
  });

  // Open browser print dialog
  $('.print-link').on('click', function (e) {
    e.preventDefault();
    window.print();
  });

  // Open external links in a new window (add rel="ext" to the link)
  $('a[rel*=ext], a[rel*=help]').on('click', function (e) {
    e.preventDefault();
    window.open($(this).attr('href'));
  });
  
}());
