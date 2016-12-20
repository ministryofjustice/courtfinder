#jslint browser: true, evil: false, plusplus: true, white: true, indent: 2, nomen: true 

#global moj, $ 

# Tabs modules for MOJ
# Dependencies: moj, jQuery
moj.Modules.postcodes = (->
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
      defaultText: "add post code"
      pattern: /^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y])))( {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2})?))$/

    return

  cacheEls = ->
    $table = $("#js-pcode-tbl")
    $tagInputs = $(".postcode.js-tags", $table)
    return

  # public methods
  init: init
)()

# call as main.js is called before this file as it's admin only - REFACTOR?
moj.Modules.postcodes.init()