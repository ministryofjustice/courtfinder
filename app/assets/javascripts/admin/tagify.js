$('textarea[name="court[postcode_list]"]').tagify({
  inputValidation: /^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y])))( {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2})?))$/,
  placeholder: 'Add postcode',
  addNewDelimiter: [13],
  addCb: validate_tag
})

function validate_tag(tags) {
  postcode = tags[0].tag
  self = this

  $.get('/admin/official_postcodes/validate/'+postcode)
  .done(function(data) {
    if (data.valid == false) {
      remove_tag($(self))
    }
  })
  .fail(function() {
    remove_tag($(self))
  })

}

function remove_tag(tag){
  tag.parent().find('div.tagify-tag').last().remove()
}


