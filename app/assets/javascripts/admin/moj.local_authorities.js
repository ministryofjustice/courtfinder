moj.Modules.localAuthorities = (function() {
  "use strict";
  var $table, $tagInputs, cacheEls, init;
  $table = void 0;
  $tagInputs = void 0;
  init = function() {
    cacheEls();
    $tagInputs.tagsInput({
      width: "96%",
      height: "67px",
      defaultText: "add local authority",
      autocomplete_url: '/admin/local_authorities/complete',
      autocomplete: {
        selectFirst: true,
        autoFill: true
      }
    });
  };
  cacheEls = function() {
    $table = $("#js-local-authority-tbl");
    $tagInputs = $(".local-authority.js-tags", $table);
  };
  return {
    init: init
  };
})();

moj.Modules.localAuthorities.init();
