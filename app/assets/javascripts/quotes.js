
function calcula_net_price(){
	var factor = ($("#quote_margin").val()/100)+1;
	var net_precio = parseInt($("#quote_cost_product").val()*factor);
	$("#quote_net_price").val(net_precio);
	calcula_price(net_precio);
}

function calcula_price(net_precio){
	var iva = parseInt(net_precio * 0.19);
	var precio_con_iva = parseInt(net_precio)+ iva;
	$("#quote_price").val(precio_con_iva);
	$("#tax_iva").val(iva);
	calcula_total(precio_con_iva);
}

function calcula_total(price){
	var total = $("#quote_quantity").val() * price;
	$("#quote_total_price").val(total);
}

function calcula_margin(){
	var margen = (($("#quote_net_price").val() * 100)/ $("#quote_cost_product").val()) - 100;
	$("#quote_margin").val(margen.toFixed(1));
	console.log($("#quote_net_price").val())
	calcula_price(parseInt($("#quote_net_price").val()));
}