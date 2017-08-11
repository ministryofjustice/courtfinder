
$('textarea[name="court[postcode_list]"]').tagify({
  placeholder: 'Add postcode',
  addNewDelimiter: [13],
  addCb: validateTag,
})

$('form.js-postcode-tag-form').on('submit', function(event){
  if(!confirm('Do you really want to save changes?')){
    event.preventDefault();
  }

});

function validateTag(tags) {
  postcode = tags[0].tag
  self = this

  $.get('/admin/official_postcodes/validate/'+postcode)
  .done(function(data) {
    if (data.valid == false) {
      removeTag($(self), postcode)
    }
  })
  .fail(function() {
    removeTag($(self), postcode)
  })

}

function removeTag(tag){
  alert('Postcode that you entered ('+postcode+') is not valid, please try again.')
  tag.parent().find('i.tagify-remove').last().click()
}
