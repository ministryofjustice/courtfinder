$ ->
  $('.field-group').click (e) ->
    e.preventDefault()
    $(this).siblings('ul.sortable').find('li fieldset, li .sortable-summary').toggle()
    $(this).siblings('.add_fields').toggle()

  $('.sortable').on 'click', '.remove', (e) ->
    e.preventDefault()
    $(this).closest('.destroy').siblings('div').hide()
    $(this).hide().siblings('.undo').show()
    $(this).siblings('input').prop 'checked', true
  $('.sortable').on 'click', '.undo', (e) ->
    e.preventDefault()
    $(this).closest('.destroy').siblings('div').not('[class$="sort"]').show()
    $(this).hide().siblings('.remove').show()
    $(this).siblings('input').prop 'checked', false

  $('.sortable').sortable
    placeholder: 'ui-state-highlight'
    stop: (e, ui) ->
      MOJ.reSort $(this)

  # Update the summary
  $('.sortable').on 'change', '.court_contacts_contact_type select', ->
    val = $(this).find(':selected').text()
    $(this).closest('li').find('.sortable-summary .type').text val
  $('.sortable').on 'change', '.court_contacts_name input', ->
    val = $(this).val()
    $(this).closest('li').find('.sortable-summary .name span').text(val).parent()[if val.length then 'show' else 'hide']()
  $('.sortable').on 'change', '.court_contacts_telephone input', ->
    val = $(this).val()
    $(this).closest('li').find('.sortable-summary .tel span').text(val).parent()[if val.length then 'show' else 'hide']()

  # Update the summaries on load
  $('.court_contacts_contact_type select, .court_contacts_name input, .court_contacts_telephone input').change()


window.MOJ = window.MOJ or {

  reSort: (list) ->
    items = list.children('li')
    items.each ->
      $(this).find('.court_contacts_sort input').val items.index($(this))

  # Add form partials on the fly (using link_to_add_fields_new)
  initNewFieldBlock: (el) ->
    el.closest('.sortable').sortable 'refreshPositions'
    MOJ.reSort el

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