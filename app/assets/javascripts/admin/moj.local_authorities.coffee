#jslint browser: true, evil: false, plusplus: true, white: true, indent: 2, nomen: true 

#global moj, $ 

# Tabs modules for MOJ
# Dependencies: moj, jQuery
moj.Modules.localAuthorities = (->
  "use strict"
  
  # public vars
  $table = undefined
  $tagInputs = undefined
  
  # private methods
  init = ->
    cacheEls()
    $tagInputs.tagsInput
      width: "96%"
      height: "67px"
      defaultText: "add local authority"
      autocomplete_url: '/admin/local_authorities/complete'
      autocomplete:
        selectFirst: true
        autoFill: true

    return

  cacheEls = ->
    $table = $("#js-local-authority-tbl")
    $tagInputs = $(".local-authority.js-tags", $table)
    return
  # public methods
  init: init
)()

# call as main.js is called before this file as it's admin only - REFACTOR?
moj.Modules.localAuthorities.init()
