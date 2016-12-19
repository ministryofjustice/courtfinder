#jslint browser: true, evil: false, plusplus: true, white: true, indent: 2, nomen: true 

#global moj, $ 

# Tabs modules for MOJ
# Dependencies: moj, jQuery
moj.Modules.move_postcodes = (->
  "use strict"
  
  # private methods
  init = ->
    $('#selectAll').click (event) ->
      event.preventDefault()
      event.stopPropagation()
      $('#postcodes input').prop('checked', true)
      return
    
    $('#deSelectAll').click (event) ->
      event.preventDefault()
      event.stopPropagation()
      $('#postcodes input').prop('checked', false)
      return

    return

  # public methods
  init: init
)()

# call as main.js is called before this file as it's admin only - REFACTOR?
moj.Modules.move_postcodes.init()