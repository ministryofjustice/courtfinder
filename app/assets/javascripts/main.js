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

  $('a[data-disabled]:not([data-disabled="false"])').on('click', function(e){
    e.preventDefault();
  });

  $('.warning a[data-expand]').on('click', function(e){
    e.preventDefault();
    var list = $(this).parent().find('.list');
    if(list.is(':visible')){
      list.slideUp();
      $(this).html('view list');
    }else{
      list.slideDown();
      $(this).html('hide list');
    }
  });

  // User Satisfaction Survey
  var showSurvey = function (){
    if( GOVUK && GOVUK.userSatisfaction ){
      var $survey = $('#user-satisfaction-survey');
      GOVUK.userSatisfaction.showSurveyBar();

      if( $survey.css('display') != "none" ){
        $survey.removeClass('not-shown');
      }
    }
  };

  setTimeout( showSurvey, 14000 );

  $('#user-satisfaction-survey .close-on-click').click(function (event){
    $('#user-satisfaction-survey').addClass('not-shown');    
    event.preventDefault();
    return false;
  });
}());
