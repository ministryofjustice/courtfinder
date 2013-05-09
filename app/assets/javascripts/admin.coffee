$ ->
  $('.field-group').click ->
    $(this).next('ul.sortable').find('li fieldset, li .sortable-summary').toggle()

  $('.sortable').sortable
    placeholder: 'ui-state-highlight'
    stop: (e, ui) ->
      MOJ.reSort $(this)

  # $('.sortable').find('[class$="sort"]').hide()

  # Update the summary
  $('.court_contacts_telephone input').change ->
    val = $(this).val()
    # console.log val
    $(this).closest('li').find('.sortable-summary .tel').text val


window.MOJ = window.MOJ or {

  reSort: (list) ->
    items = list.children('li')
    items.each ->
      $(this).find('.court_contacts_sort input').val items.index($(this))

  # Add form partials on the fly (using link_to_add_fields_new)
  initNewContact: (el) ->
    console.log 'new contact'
    console.log el
    el.closest('.sortable').sortable 'refreshPositions'

  # http://stackoverflow.com/questions/359788/how-to-execute-a-javascript-function-when-i-have-its-name-as-a-string/359910#359910
  executeFunctionByName: (functionName, context) -> #, args
    args = Array::slice.call(arguments_).splice(2)
    namespaces = functionName.split(".")
    func = namespaces.pop()
    i = 0

    while i < namespaces.length
      context = context[namespaces[i]]
      i++
    context[func].apply this, args

}