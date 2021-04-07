program siete;
const valoralto = 9999;
type
	maestroP = record
		cod: integer;
		nom: string;
		precio: real;
		stockA: integer;
		stockM: integer;
	end;
	detalleP = record
		cod: integer;
		cantV: integer;
	end;
	maestro = file of maestroP;
	detalle = file of detalleP;

{-------------------------------------------}
{inciso A}
procedure importarMaestro(var mae: maestro);
var
	carga: text;
	p: maestroP;
begin
	writeln('ELIGIÓ IMPORTAR MAESTRO');
	assign(mae,'maestro7.data'); 
	assign(carga,'productos.txt');
	reset(carga); rewrite(mae);
	while(not eof(carga))do begin
		with p do readln(carga, cod, precio, stockA, stockM,nom);
		write(mae,p);
	end;
	close(mae); close(carga);
	writeln('---- OPERACION TERMINADA ----');
end;

{-------------------------------------------}
{INCISO B}
procedure exportarMaestro(var mae: maestro);
var
	carga: text;
	p: maestroP;
begin
	writeln('ELIGIÓ EXPORTAR MAESTRO');
	assign(mae,'maestro7.data');
	assign(carga,'reporte.txt');
	reset(mae); rewrite(carga);
	while(not eof(mae))do begin
		read(mae,p);
		with p do writeln(carga,' ',cod,' ',nom,' ',precio,' ',stockA,' ',stockM);
	end;
	close(mae); close(carga);
	writeln('---- OPERACION TERMINADA ----');
end;
{-------------------------------------------}
{INCISO C}
procedure importarDetalle(var det:detalle);
var
	carga:text;
	p: detalleP;
begin
	writeln('ELIGIÓ IMPORTAR DETALLE');
	assign(det, 'detalle7.data');
	assign(carga, 'ventas.txt');
	rewrite(det); reset(carga);
	while(not eof(carga))do begin
		with p do readln(carga,cod,cantV);
		write(det,p);
	end;
	close(det); close(carga);
	writeln('---- OPERACION TERMINADA ----');
end;

{-------------------------------------------}
{INCISO D}
procedure listarDetalle(var det: detalle);
var
	p: detalleP;
begin
	writeln('ELIGIÓ LISTAR DETALLE');
	assign(det,'detalle7.data');
	reset(det);
	while(not eof(det))do begin
		read(det,p);
		writeln('- Cod: ',p.cod,' / Cantidad de ventas: ', p.cantV); 
	end;
	close(det);
	writeln('---- OPERACION TERMINADA ----');
end;

{-------------------------------------------}
procedure leer(var arch:detalle; var dato:detalleP);
begin
	if(not eof(arch))then read(arch,dato)
		else dato.cod:=valoralto;
end;
{INCISO E}
procedure actualizarMaestro(var mae: maestro; var det:detalle);
var
	regd: detalleP;
	regm: maestroP;
	aux,acu: integer;
begin
	writeln('ELIGIÓ ACTUALIZAR MAESTRO');
	assign(mae,'maestro7.data'); assign(det,'detalle7.data');
	reset(mae); reset(det);
	leer(det, regd);
	read(mae,regm);
	while(regd.cod <> valoralto)do begin
		aux:= regd.cod;
		acu:=0;
		while(aux = regd.cod)do begin //como pueden haber mas de 1 reg con el mismo cod acumulo todas las ventas
			acu:=acu + regd.cantV;
			leer(det,regd);
		end;
		//cuando termino de acumular busco el codigo en el maestro
		while(regm.cod <> aux) do read(mae,regm);
		regm.stockA:= regm.stockA - acu;
		seek(mae, filepos(mae)-1);
		write(mae,regm);
	end;
	writeln('---- OPERACION TERMINADA ----');
	close(det);close(mae);
end;

{-------------------------------------------}
{INCISO F}
procedure listarStockMinimo(var mae: maestro);
var
	p: maestroP;
	carga:text;
begin
	writeln('ELIGIÓ EXPORTAR LOS STOCK MINIMOS');
	assign(mae,'maestro7.data');
	assign(carga,'stock_minimo.txt');
	reset(mae); rewrite(carga);
	while(not eof(mae))do begin
		read(mae,p);
		if p.stockA < p.stockM then writeln(carga,' ',p.cod,' ',p.nom,' ',p.stockA,' ',p.stockM);
	end;
	close(mae); close(carga);
	writeln('---- OPERACION TERMINADA ----');
end;

{-------------------------------------------}
var
	mae: maestro;
	det: detalle;
	opcion: char;
begin
	opcion:= 'a';
	while(opcion < 'g')do begin
		writeln('ELIJA UNA OPCION: ');
		writeln('a) importar maestro.');
		writeln('b) exportar maestro.');
		writeln('c) importar detalle.');
		writeln('d) listar detalle.');
		writeln('e) mezclar detalle y maestro.');
		writeln('f) exportar stock minimo.');
		readln(opcion);
		case opcion of
			'a': importarMaestro(mae);
			'b': exportarMaestro(mae);
			'c': importarDetalle(det);
			'd': listarDetalle(det);
			'e': actualizarMaestro(mae,det);
			'f': listarStockMinimo(mae);
		end;
	end;
end.
