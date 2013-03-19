CKEDITOR.editorConfig = (config) ->
  config.forcePasteAsPlainText = true
  config.removeDialogTabs = 'link:advanced'
  config.toolbar = [
    { name: 'clipboard',   items: [ 'Cut','Copy','Paste','-','Undo','Redo' ] },
    { name: 'basicstyles', items: [ 'NumberedList','BulletedList','Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
    { name: 'links',       items: [ 'Link','Unlink' ] }
  ]
  true