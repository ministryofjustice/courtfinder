$(document).ready(function(){
    var table = $('.areaOfLaw').DataTable(
        {
            fixedColumns: {
                leftColumns: 2
            },
            
            scrollY:        300,
            scrollX:        true,
            paging:         true,
            sorting:        false,
            orderClasses:   false,
            deferRender:    true,
            autoWidth:      false
        });
    $('ul.tabs-nav.clearfix > li > a').click( function() {
        var letter = $(this).text();
        if ( _alphabetSearch === letter)
        {
            _alphabetSearch = '';
            $('ul.tabs-nav.clearfix').find( 'a.active' ).removeClass( 'active' );
        }
        else
        {
            _alphabetSearch = letter;
            $('ul.tabs-nav.clearfix').find( 'a.active' ).removeClass( 'active' );
            $(this).addClass( 'active' );
        }
        table.draw();
    } );
   table.columns.adjust().draw();
});

var _alphabetSearch = '';
 
$.fn.dataTable.ext.search.push( function ( settings, searchData ) {
    if ( ! _alphabetSearch ) {
        return true;
    }
 
    if ( searchData[1].charAt(0) === _alphabetSearch ) {
        return true;
    }
 
    return false;
} );
 