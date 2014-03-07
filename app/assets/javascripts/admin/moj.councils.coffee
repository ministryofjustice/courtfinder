#jslint browser: true, evil: false, plusplus: true, white: true, indent: 2, nomen: true 

#global moj, $ 

# Tabs modules for MOJ
# Dependencies: moj, jQuery
moj.Modules.councils = (->
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
      defaultText: "add council"
      autocomplete:
        selectFirst: true
        autoFill: true
        source: (request, response) ->
          $.ajax
            url: '/admin/councils/complete'
            dataType: 'json'
            data:
              term: request.term
              court_id: 1
            success: (data) ->
              response(data)

    return

  cacheEls = ->
    $table = $("#js-council-tbl")
    $tagInputs = $(".council.js-tags", $table)
    return

  # public methods
  init: init
)()

# call as main.js is called before this file as it's admin only - REFACTOR?
moj.Modules.councils.init()