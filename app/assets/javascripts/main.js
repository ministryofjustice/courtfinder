/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2 */
/*global moj, $ */

(function(){

  "use strict";

  // Initialise all moj modules
  moj.init();

  // Open browser print dialog
  $('.print-link').on('click', function (e) {
    e.preventDefault();
    window.print();
  });

  // Open external links in a new window (add rel="ext" to the link)
  $('a[rel~=ext], a[rel~=help]').on('click', function (e) {
    e.preventDefault();
    window.open($(this).attr('href'));
  });

  $('a[data-disabled]').click(function(e){
    e.preventDefault();
    false;
  })

}());
