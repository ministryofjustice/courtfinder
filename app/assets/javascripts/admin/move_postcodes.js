moj.Modules.move_postcodes = (function() {
  "use strict";
  var init;
  init = function() {
    $('#selectAll').click(function(event) {
      event.preventDefault();
      event.stopPropagation();
      $('#postcodes input').prop('checked', true);
    });
    $('#deSelectAll').click(function(event) {
      event.preventDefault();
      event.stopPropagation();
      $('#postcodes input').prop('checked', false);
    });
  };
  return {
    init: init
  };
})();

moj.Modules.move_postcodes.init();
