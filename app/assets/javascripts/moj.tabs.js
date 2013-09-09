/*jslint browser: true, evil: false, plusplus: true, white: true, indent: 2, nomen: true */
/*global moj, $ */

// Tabs modules for MOJ
// Dependencies: moj, jQuery

(function(){

  "use strict";

  // Define the class
  var Tabs = function (el) {
    this.cacheEls(el);
    this.bindEvents();
  };

  Tabs.prototype = {

    classes: {
      active:'is-active'
    },

    cacheEls: function (wrap) {
      this.$tabNav = $('ul', wrap);
      this.$tabs = $('a', this.$tabNav);
      this.$tabPanes = $('.js-tabs-content', wrap).children();
    },

    bindEvents: function () {
      // store a reference to obj before 'this' becomes jQuery obj
      var self = this;

      this.$tabs.on('click', function (e) {
        e.preventDefault();
        self._activateLink($(this));
        self._activateTab($(this).attr('href'));
      });
    },

    _activateLink: function (el) {
     this.$tabs.removeClass(this.classes.active).filter(el).addClass(this.classes.active);
    },

    _activateTab: function (hash) {
      var shown = this.$tabPanes.hide().filter(hash).show();
      this._focusFirstLink(shown);
    },

    _focusFirstLink: function (el) {
      el.find('a:first').focus();
    }

  };

  // Add module to MOJ namespace
  moj.Modules.tabs = {
    init: function () {
      $('.js-tabs').each(function () {
        $(this).data('moj.tabs', new Tabs($(this)));
      });
    }
  };

}());