$('form').on('click', '.remove_fields', function(e) {
  e.preventDefault();
  $(this).prev('input[type=hidden]').val('1');

  return $(this).closest('fieldset').hide();
});

$('form').on('click', '.add_fields', function(e) {
  var callback, fields, obj, regexp, sortable, time;
  e.preventDefault();

  time = new Date().getTime();
  regexp = new RegExp($(this).data('id'), 'g');
  callback = $(this).data('callback');
  sortable = $(this).siblings('ul.sortable');
  fields = $($(this).data('fields').replace(regexp, time));

  if (sortable.length) {
    obj = sortable.append(fields);
  } else {
    obj = $(this).before(fields);
  }

  if (callback) {
    return moj.Modules.admin[callback](obj, fields);
  }
});

$('.field-group').click(function(e) {
  var alt, text;
  e.preventDefault();

  $(this).siblings('ul.sortable').find('li fieldset, li .sortable-summary').toggle();
  $(this).siblings('.add_fields').toggle();
  $(this).siblings('#sortContactNumbers').toggle();
  alt = $(this).data('alt');
  text = $(this).text();
  $(this).text(alt);

  return $(this).data('alt', text);
});

$('.simple_form').on('click', '.destroy .remove', function(e) {
  e.preventDefault();

  $(this).closest('.destroy').siblings('div').hide();
  $(this).hide().siblings('.undo').show();

  return $(this).siblings('input').prop('checked', true);
});

$('.simple_form').on('click', '.destroy .undo', function(e) {
  e.preventDefault();

  $(this).closest('.destroy').siblings('div').not('[class$="sort"]').show();
  $(this).hide().siblings('.remove').show();

  return $(this).siblings('input').prop('checked', false);
});

$('.sortable').sortable({
  placeholder: 'ui-state-highlight',
  stop: function(e, ui) {
    return moj.Modules.admin.reSort($(this));
  }
});

$('.sortable').on('change', '.court_contacts_contact_type select', function() {
  var val;

  val = $(this).find(':selected').text();
  $(this).closest('li').find('.sortable-summary .type').text(val);

  return $(this).closest('li').attr('data-contact-type', val);
});

$('.sortable').on('change', '.court_contacts_name input', function() {
  var val;
  val = $(this).val();

  return $(this).closest('li').find('.sortable-summary .name span').text(val).parent()[val.length ? 'show' : 'hide']();
});

$('.sortable').on('change', '.court_contacts_telephone input', function() {
  var val;
  val = $(this).val();

  return $(this).closest('li').find('.sortable-summary .tel span').text(val).parent()[val.length ? 'show' : 'hide']();
});

$('.sortable').on('change', '.court_opening_times_opening_type select', function() {
  var val;
  val = $(this).find(':selected').text();

  return $(this).closest('li').find('.sortable-summary .type').text(val);
});

$('.sortable').on('change', '.court_opening_times_name input', function() {
  var val;
  val = $(this).val();

  return $(this).closest('li').find('.sortable-summary .name').text(val);
});

$('.sortable').on('change', '.court_court_facilities_facility select', function() {
  var val;
  val = $(this).find(':selected').text();

  return $(this).closest('li').find('.sortable-summary .facility').text(val);
});

$('.sortable').on('change', '.court_emails_contact_type select', function() {
  return $(this).closest('li').find('.sortable-summary .type').text($(this).find(':selected').text());
});

$('.sortable').on('change', '.court_emails_address input', function() {
  return $(this).closest('li').find('.sortable-summary .add').text($(this).val());
});

$('.court_contacts_contact_type, .court_contacts_name, .court_contacts_telephone, .court_opening_times_name, .court_opening_times_opening_type, .court_emails_description, .court_emails_address, .court_court_facilities_facility').find('input, select').change();

$('.edit-court').on('keyup', 'textarea.leaflet', function() {
  var $ta, charlimit, notice;
  $ta = $(this);
  charlimit = 2500;
  notice = $ta.siblings('.char-limit');

  if ($ta.val().length > charlimit) {
    $ta.val($ta.val().substr(0, charlimit)).css('outline', 'solid 3px #ff0000');
    return notice.css('color', '#ff0000');
  } else {
    return $ta.add(notice).removeAttr('style');
  }
});

moj.Modules.admin = {
  reSort: function(list) {
    var items;
    items = list.children('li');
    return items.each(function() {
      return $(this).find('input[id$="_sort"]').val(items.index($(this)));
    });
  },

  initNewFieldBlock: function(el) {
    el.closest('.sortable').sortable('refreshPositions');
    return moj.Modules.admin.reSort(el);
  },

  isPrimaryAddress: function(el) {
    var primary;
    primary = el.siblings('fieldset').addBack().filter(function() {
      return $(this).find('.destroy input[type=checkbox]').prop('checked') === false;
    }).first();
    return el[0] === primary[0];
  },

  initNewAddressBlock: function(el, newFields) {
    var input, primary;
    input = newFields.find('.court_addresses_is_primary input');
    primary = newFields.find('.court_addresses_primary');

    if (this.isPrimaryAddress(newFields)) {
      input.val(true);
      return primary.removeClass('hidden');
    } else {
      input.val(false);
      return primary.addClass('hidden');
    }
  }
};
