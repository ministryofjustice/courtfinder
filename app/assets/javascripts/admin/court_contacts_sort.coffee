  $ ->
    contactSort = (a, b) ->
      if $(a).data('contact-type') < $(b).data('contact-type') then -1 else 1

    sortList = (e) ->
      e.preventDefault()
      $ul = $('ul#contactNumbers')
      $li = $ul.find('li')

      $enquiries = $li.filter('[data-contact-type="Enquiries"]').clone(true)
      $faxs = $li.filter('[data-contact-type="Fax"]').clone(true)
      $dxs = $li.filter('[data-contact-type="DX"]').clone(true)

      $ul.find('[data-contact-type="Enquiries"]').remove() if $enquiries.length
      $ul.find('[data-contact-type="Fax"]').remove() if $faxs.length
      $ul.find('[data-contact-type="DX"]').remove() if $dxs.length
      
      $li = $li.not('[data-contact-type="Enquiries"]').not('[data-contact-type="Fax"]').not('[data-contact-type="DX"]')
            
      $li.sort(contactSort).appendTo $ul

      $ul.prepend $enquiries if $enquiries.length
      $ul.append $faxs if $faxs.length
      $ul.append $dxs if $dxs.length

      moj.Modules.admin.reSort $ul
      false

    $(this).find('#sortContactNumbers').click sortList
