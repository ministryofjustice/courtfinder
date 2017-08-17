$(function() {
  var contactSort, sortList;
  contactSort = function(a, b) {
    if ($(a).data('contact-type') < $(b).data('contact-type')) {
      return -1;
    } else {
      return 1;
    }
  };
  sortList = function(e) {
    var $dxs, $enquiries, $faxs, $li, $ul;
    e.preventDefault();
    $ul = $('ul#contactNumbers');
    $li = $ul.find('li');
    $enquiries = $li.filter('[data-contact-type="Enquiries"]').clone(true);
    $faxs = $li.filter('[data-contact-type="Fax"]').clone(true);
    $dxs = $li.filter('[data-contact-type="DX"]').clone(true);
    if ($enquiries.length) {
      $ul.find('[data-contact-type="Enquiries"]').remove();
    }
    if ($faxs.length) {
      $ul.find('[data-contact-type="Fax"]').remove();
    }
    if ($dxs.length) {
      $ul.find('[data-contact-type="DX"]').remove();
    }
    $li = $li.not('[data-contact-type="Enquiries"]').not('[data-contact-type="Fax"]').not('[data-contact-type="DX"]');
    $li.sort(contactSort).appendTo($ul);
    if ($enquiries.length) {
      $ul.prepend($enquiries);
    }
    if ($faxs.length) {
      $ul.append($faxs);
    }
    if ($dxs.length) {
      $ul.append($dxs);
    }
    moj.Modules.admin.reSort($ul);
    return false;
  };
  return $(this).find('#sortContactNumbers').click(sortList);
});
