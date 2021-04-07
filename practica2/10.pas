program diez;
const valoralto = 9999;
type
	cate = 1..15;
	empleado = record
		depa: integer;
		divi: integer;
		num: integer;
		cat: cate;
		cantHorasExtras: integer;
	end;
	
	
	maestro = file of empleado;
	vecCat = array[cate] of integer;

{------------------------------------}
procedure importarMaestro(var mae: maestro);
var
	texto: text;
	e: empleado;
begin
	assign(texto,'maestro10.txt');
	reset(texto);
	assign(mae,'maestro10.data');
	rewrite(mae);
	while not eof(texto) do begin
		with e do readln(texto,depa,divi,num,cat,cantHorasExtras);
		write(mae, e);
	end;
	close(mae); close(texto);
end;

{---------------------------------}
procedure leer(var arch:maestro; var aux:empleado);
begin
    if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.depa:=valorAlto;
end;
{------------------------------------}

procedure crearVector(var v:vecCat);
var i: cate;
begin
	for i:=1 to 15 do v[i]:=random(1000);
end;

{------------------------------------}
procedure reporte(var mae: maestro; v:vecCat);
var
	e,aux: empleado;
	monto,totalHD,montoTotalD,totalHDi,montoTotalDi: integer;

begin
	assign(mae,'maestro10.data');
	reset(mae);
	
	//recorro mientras no llegue al final del archivo
	leer(mae,e);
	while(e.depa <> valoralto)do begin
		aux:=e;
		writeln('------------------------------');
		writeln('Departamento: ', aux.depa); 
		totalHD:= 0;
		montoTotalD:= 0;
		while(e.depa = aux.depa)do begin
			aux:=e;
			writeln('------------------------------');
			writeln('Division: ', aux.divi); 
			totalHDI:= 0;
			montoTotalDi:= 0;
			while(e.divi = aux.divi)and(e.depa = aux.depa)do begin
				aux:=e;
				writeln('- Numero de empleado: ', e.num);
				writeln('Total de hs: ', e.cantHorasExtras);
				monto:= v[e.cat] * e.cantHorasExtras;
				writeln('Importe a cobrar: ', monto);
				totalHDI:= totalHDi + e.cantHorasExtras;
				montoTotalDi:= montoTotalDi + monto;
				leer(mae,e);
				
			end;
			writeln('------------------------------');
			writeln('Total de horas division: ', totalHDi);
			writeln('Monto total por division: ', montoTotalDi);
			totalHD:= totalHD + totalHDi;
			montoTotalD:= montoTotalD + montoTotalDi;
		end;
		writeln('------------------------------');
		writeln('Total de horas departamento: ', totalHD);
		writeln('Monto total por departamento: ', montoTotalD);
	end;
end;

{------------------------------------}
var 
	v:vecCat;
	mae: maestro;
begin
	randomize;
	importarMaestro(mae);
	crearVector(v);
	reporte(mae,v);
end.
