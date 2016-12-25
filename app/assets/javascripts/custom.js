$(document).ready(function(){
	$("a[id^=d_]").bind({
		click: function(e, ui){
			//$("#document_ticket").val('B');
			if ($.trim($(this).text()) == 'Boleta'){
				$("#search_type_sale").val('B');
			  $('#search_q').attr("placeholder", "Buscar por Nº Boleta").val("").focus().blur();
			  $('#search_q').attr("readonly", false);

			}
			if ($.trim($(this).text()) == 'Factura'){
			  $("#search_type_sale").val('F');
			  $('#search_q').attr("placeholder", "Buscar por Nº Factura").val("").focus().blur();
			  $('#search_q').attr("readonly", false);
			}
			if ($.trim($(this).text()) == 'Salida'){
				$("#search_type_sale").val('S');
			  $('#search_q').attr("placeholder", "Buscar por Nº Guía de Salida").val("").focus().blur();
			  $('#search_q').attr("readonly", false);
			}
		}
  });
});

$(function(){
  $(".dropdown-menu li a").click(function(){
    $(".btn:first-child").text($(this).text());
    $(".btn:first-child").val($(this).text());
  });
});