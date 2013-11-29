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

    $tagInputs.tagsInput({
      width: '96%',
      height: '67px',
      defaultText:  'add post code'
    });
  },

  cacheEls = function (){
    $table = $('#js-pcode-tbl');
    $tagInputs = $('.js-tags', $table);
  };

  // public methods
  return {
    init: init
  }
}());

// call as main.js is called before this file as it's admin only - REFACTOR?
moj.Modules.postcodes.init();