program nueve;
const valoralto = 9999;
type
	mesas = record
		codP: integer;
		codL: integer;
		num: integer;
		cantV: integer;
	end;
	maestro = file of mesas;
	
{--------------------------}

procedure importarMaestro(var mae:maestro);
var 
	carga:text;
	m:mesas;
begin
	assign(mae,'maestro9.data');
	assign(carga,'maestro9.txt');
	reset(carga); rewrite(mae);
	while(not eof(carga))do begin
		with m do readln(carga, codP, codL, num, cantV);
		write(mae,m);
	end;
	close(carga); close(mae);
end;

{---------------------------------}
procedure leer(var arch:maestro; var aux:mesas);
begin
    if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.codP:=valorAlto;
end;

{--------------------------}

procedure listar(var mae:maestro);
var 
	m,aux: mesas;
	totalLoc,totalProv, total: integer;
begin
	assign(mae,'maestro9.data');
	reset(mae);
	total:=0;
	leer(mae,m);
	while (m.codP <> valoralto) do begin
		aux:=m;
		totalProv:=0;
		writeln('------------------------------');
		writeln('Codigo de provincia: ',m.codP);
		while(aux.codP = m.codP)do begin
			aux:=m;
			totalLoc:=0;
			writeln('------------------------------');
			writeln('Codigo de localidad: ',m.codL);
			while(aux.codL = m.codL)and(aux.codP = m.codP)do begin
				totalLoc:= totalLoc + m.cantV;
				totalProv:=totalProv + m.cantV;
				leer(mae,m);
			end;
			writeln('Total de votos localidad: ',totalLoc);
		end;
		writeln('Total de votos provincia: ',totalProv);
		total:=total+totalProv;
	end;
	writeln('Total general de votos: ', total);
	close(mae);
end;

{--------------------------}
var
	mae:maestro;
begin
	importarMaestro(mae);
	listar(mae);
end.
