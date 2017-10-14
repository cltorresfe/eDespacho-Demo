function format_numero_separador_miles(numero){
	var num = 0;
	if(!isNaN(numero)){
		num = numero.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g,'$1.');
		num = num.split('').reverse().join('').replace(/^[\.]/,'');
	}
	return num;
}