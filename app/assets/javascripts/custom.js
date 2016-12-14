$(document).ready(function(){

	$('#search_type_sale').click(function(){
		var checkbox = $( "#search_type_sale" );
		checkbox.val( checkbox[0].checked ? "F" : "B" );
		if(checkbox.val()== "F"){
			$('#search_q').attr("placeholder", "Buscar folio Factura").val("").focus().blur();
		}
		else{
			$('#search_q').attr("placeholder", "Buscar folio BOLETA").val("").focus().blur();
		}
	});
});