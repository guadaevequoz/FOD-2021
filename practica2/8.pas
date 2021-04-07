program ocho;
const valoralto=9999;
type
	meses = 1..12;
	dias = 1..31;
	anios = 1999..2021;
	cliente = record
		cod: integer;
		nombre: string;
		apellido: string;
	end;
	maestroA = record
		cli: cliente;
		anio: anios;
		mes: meses;
		dia: dias;
		monto: real;
	end;
	maestro = file of maestroA;
	
{---------------------------------}
procedure importarMaestro(var mae: maestro);
var
	carga: text;
	v: maestroA;
begin
	assign(mae,'maestro8.data');
	assign(carga,'maestro8.txt');
	rewrite(mae); reset(carga);
	while (not eof(carga))do begin
		with v do readln(carga, cli.cod, anio, mes, dia, cli.nombre);
		with v do readln(carga, monto, cli.apellido);
		write(mae,v);
	end;
	close(mae); close(carga);
end;


{---------------------------------}
procedure leer(var arch:maestro; var aux:maestroA);
begin
    if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.cli.cod:=valorAlto;
end;
{---------------------------------}
procedure generarReporte(var mae:maestro);
var
	v,aux:maestroA;
	totalMes: real;
	total: real;
begin
	assign(mae,'maestro8.data');
	reset(mae);
	leer(mae,v);
	while (v.cli.cod <> valoralto) do begin
		aux:= v;
		writeln('----------------');
		writeln('Cliente numero: ', aux.cli.cod);
		writeln('DATOS PERSONALES'); 
		writeln('Nombre: ', aux.cli.nombre,'- Apellido: ', aux.cli.apellido);
		while(aux.cli.cod = v.cli.cod)do begin
			aux:=v;
			total:=0;
			while(aux.anio = v.anio)and(aux.cli.cod = v.cli.cod) do begin
				aux:=v;
				totalMes:=0;
				while(aux.mes = v.mes)and (aux.anio = v.anio)and(aux.cli.cod = v.cli.cod)do begin
					totalMes:= totalMes + v.monto;
					total:= total + v.monto;
					leer(mae,v);
				end;
				writeln('TOTAL DEL MES: ',aux.mes);
				writeln('$ ',totalMes:0:2);
			end;
			writeln('TOTAL DEL ANIO: ', aux.anio);
			writeln('$ ',total:0:2);
		end;
	end;
	close(mae);
end;

{---------------------------------}
var
	mae:maestro;
begin
	importarMaestro(mae);
	generarReporte(mae);
end.
