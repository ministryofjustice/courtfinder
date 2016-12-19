$(document).ready(function(){
    var table = $('.areaOfLaw');

    table.DataTable(
    	{
    		fixedColumns: {
        		leftColumns: 2
    		},
    		
        	scrollY:        300,
        	scrollX:        true,
        	paging: 		true,
        	sorting:        false,
        	bSmart: false,
            columnDefs: [{ targets: '_all', "searchable": false }, 
                        { targets: [2], "searchable": true}]
       	}); //.fnFilter( '^'+this.value, 2, true, false );


    // table.columns().eq( 0 ).each( function ( colIdx ) {
    //     if (colIdx != 2 || rowIdx < 1)
    //         return; //Do not add event handlers for these columns

    //     $( 'td', table.column( colIdx ).footer() ).on( 'keyup change', function () {
    //         table
    //             .column( colIdx )
    //             .search( this.value )
    //             .draw();
    //     } );
    // } );
});
