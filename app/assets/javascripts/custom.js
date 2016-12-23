$(document).ready(function(){
	$("a[id^=d_]").bind({
		click: function(e, ui){
			//$("#document_ticket").val('B');
			if ($.trim($(this).text()) == 'Boleta'){
				$("#search_type_sale").val('B');
			  $('#search_q').attr("placeholder", "Buscar por Nº Boleta").val("").focus().blur();
			}
			if ($.trim($(this).text()) == 'Factura'){
			 $("#search_type_sale").val('F');
			  $('#search_q').attr("placeholder", "Buscar por Nº Factura").val("").focus().blur();
			}
			if ($.trim($(this).text()) == 'Guía de Despacho'){
				$("#search_type_sale").val('S');
			  $('#search_q').attr("placeholder", "Buscar por Nº Guía de Despacho").val("").focus().blur();
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