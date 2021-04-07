program doce;
const valoralto = 9999;
type
	meses = 1..12;
	dias = 1..31;
	info = record
		anio: integer;
		mes: meses;
		dia: dias;
		idUsuario: string;
		tAcc: integer;
	end;
	arch = file of info;
	
{----------------------------}

procedure importarMaestro(var mae: arch);
var
	texto: text;
	i: info;
begin
	assign(mae, 'maestro12.data');
	assign(texto,'maestro12.txt');
	reset(texto); rewrite(mae);
	while not eof(texto) do begin
		with i do readln(texto,anio,mes,dia,tAcc,idUsuario);
		write(mae,i);
	end;
	close(mae);close(texto);
end;

{----------------------------}

procedure leer(var arch:arch; var aux:info);
begin
    if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.anio:=9999;
end;

{----------------------------}

procedure reporte(var mae:arch; anio: integer);
var
	aux,i: info;
	totalMes,totalDia,totalAnio: integer;
begin
	reset(mae);
	totalAnio:=0;
	while(not eof(mae))do begin
		leer(mae,i);
		while(i.anio <> anio)and(not eof(mae))do read(mae,i);
		if(i.anio = anio)then begin
		while(i.anio <> valoralto)and(i.anio = anio) do begin
			aux:=i;
			totalMes:=0;
			writeln('Mes: ',i.mes);
			while(aux.mes = i.mes)and(aux.anio = i.anio) do begin
				aux:=i;
				totalDia:=0;
				writeln('Dia: ',i.dia);
				while(aux.dia=i.dia)and(aux.mes = i.mes)and(aux.anio = i.anio) do begin
					writeln(i.idUsuario,' tiempo total de acceso en el día ', i.dia,' = ',i.tAcc);
					totalDia:=totalDia + i.tAcc;
					leer(mae,i);
				end;
				writeln('Tiempo total de acceso en el día ', aux.dia,' mes ',aux.mes,' = ',totalDia);
				writeln('---------------');
				totalMes:=totalMes + totalDia;
			end;
			writeln('Tiempo total acceso mes ', aux.mes,' = ',totalMes);
			writeln('---------------');
			totalAnio:=totalAnio + totalMes;
		end;
		writeln('Tiempo total acceso anio ', anio,' = ',totalAnio);
		end 
		else writeln('anio no encontrado.');
	end;
	
	{leer(mae,i);
	while(i.anio <> valoralto)do begin
		aux:=i;
		totalAnio:=0;
		writeln('---------------');
		writeln('Anio: ',i.anio);
		while(aux.anio = i.anio)do begin
			aux:=i;
			totalMes:=0;
			writeln('Mes: ',i.mes);
			while(aux.mes = i.mes)and(aux.anio = i.anio) do begin
				aux:=i;
				totalDia:=0;
				writeln('Dia: ',i.dia);
				while(aux.dia=i.dia)and(aux.mes = i.mes)and(aux.anio = i.anio) do begin
					writeln(i.idUsuario,' tiempo total de acceso en el día ', i.dia,' = ',i.tAcc);
					totalDia:=totalDia + i.tAcc;
					leer(mae,i);
				end;
				writeln('Tiempo total de acceso en el día ', aux.dia,' mes ',aux.mes,' = ',totalDia);
				writeln('---------------');
				totalMes:=totalMes + totalDia;
			end;
			writeln('Tiempo total acceso mes ', aux.mes,' = ',totalMes);
			writeln('---------------');
			totalAnio:=totalAnio + totalMes;
		end;
		writeln('Tiempo total acceso anio ', aux.anio,' = ',totalAnio);
	end;}
	close(mae);
end;

{----------------------------}
var mae:arch;
	anio:integer;
begin
	importarMaestro(mae);
	assign(mae,'maestro12.data');
	
	writeln('Escriba el anio para realizar el informe: ');
	readln(anio);
	reporte(mae,anio);
end.
