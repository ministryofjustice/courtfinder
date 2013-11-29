/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2, nomen: true */
/*global moj, $ */

// Tabs modules for MOJ
// Dependencies: moj, jQuery

moj.Modules.postcodes = (function (){
  "use strict";

  // public vars
  var $table,
      $tagInputs,

  // private methods
  init = function (){
    cacheEls();
    bindEvts();

    $tagInputs.tagsInput({
      width: '96%',
      height: '67px',
      defaultText:  'add post code'
    });
  },

  cacheEls = function (){
    $table = $('#js-pcode-tbl');
    $tagInputs = $('.js-tags', $table);
  },

  bindEvts = function (){
    $table.on({
      submit: postcodeFormSubmit,
      'ajax:success': postcodeFormResponse, // unused args (e, data, status, xhr) or (e, xhr, status)
      'ajax:error': postcodeFormResponse // unused args ( e, xhr, status, error )
    }, '.js-postcode-tag-form');
  },

  postcodeFormSubmit = function (e){
    var $form = $(this);
    //$form.find('input[type="submit"]').val("Saving").prop('disabled', true);
    //return false;
  },

  postcodeFormResponse = function (e, xhr, status){
    moj.log("response...");
    return false;
  };

  // public methods
  return {
    init: init
  }
}());

// call as main.js is called before this file as it's admin only - REFACTOR?
moj.Modules.postcodes.init();