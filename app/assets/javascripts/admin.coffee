$ ->
  re_sort = (list) ->
    items = list.children('li')
    items.each ->
      $(this).find('.court_contacts_sort input').val items.index($(this))

  $('.field-group').click ->
    $(this).next('ul.sortable').find('li fieldset, li .sortable-summary').toggle()

  $('.sortable').sortable
    placeholder: 'ui-state-highlight'
    stop: (e, ui) ->
      re_sort $(this)

  $('.sortable').find('[class$="sort"]').hide()

  $('.court_contacts_telephone input').change ->
    val = $(this).val()
    console.log val
    console.log $(this).closest('li').children('.sortable-summary')
    $(this).closest('li').children('.sortable-summary .tel').text val