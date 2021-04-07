program catorce;
const valoralto='ZZZ';
type
	maestro = record
		destino: string;
		fecha: string;
		horaSalida: string;
		cantAsientosD: integer;
	end;
	detalle = record
		destino: string;
		fecha: string;
		horaSalida: string;
		cantAsientosC: integer;
	end;
	archMae = file of maestro;
	archDet = file of detalle;

{----------------------------}
procedure importarDetalles(var det1,det2:archDet);
var
	deta1,deta2:text;
	i:detalle;
begin
	rewrite(det1); rewrite(det2);
	assign(deta1,'detalle14P1.txt');
	assign(deta2,'detalle14P2.txt');
	reset(deta1); reset(deta2);
	while not eof(deta1)do begin
		with i do begin
			readln(deta1,destino);
			readln(deta1,fecha);
			readln(deta1,cantAsientosC,horaSalida);
		end;
		write(det1,i);
	end;
	while not eof(deta2)do begin
		with i do begin
			readln(deta2,destino);
			readln(deta2,fecha);
			readln(deta2,cantAsientosC,horaSalida);
		end;
		write(det2,i);
	end;
	close(deta2); close(deta1);
end;
{--------------------------}

procedure importarMaestro(var mae: archMae);
var
	texto: text;
	e: maestro;
begin
	assign(texto,'maestro14.txt');
	reset(texto);
	rewrite(mae);
	while not eof(texto) do begin
		with e do begin
			readln(texto,destino);
			readln(texto,fecha);
			readln(texto,cantAsientosD,horaSalida);
		end;
		write(mae, e);
	end;
	close(mae); close(texto);
end;
{----------------------------}	
procedure leer(var arch:archDet; var aux:detalle);
begin
    if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.destino:=valorAlto;
end;
{------------------------------------}
procedure minimo(var d1,d2: detalle; var det1,det2: archDet; var min: detalle);
begin
    if(d1.destino <= d2.destino)then begin
		min:=d1;
		leer(det1,d1);
    end
    else begin
		min:=d2;
		leer(det2,d2);
    end;
end;
{------------------------------------}
procedure actualizarMaestro(var mae:archMae; var det1,det2: archDet);
var
	regM: maestro;
	d1,d2,min: detalle;
begin
	reset(det1); reset(det2); reset(mae);
	leer(det1,d1); leer(det2,d2);
	minimo(d1,d2,det1,det2,min);
	while(min.destino <> valoralto)do begin
		read(mae,regm);
		while(regm.destino <> min.destino)do read(mae,regm);
		while(regm.destino = min.destino)do begin
			while(regm.fecha <> min.fecha)do read(mae,regm);
			while(regm.destino = min.destino) and (regm.fecha <> min.fecha) do begin
				while(regm.horaSalida <> min.horaSalida)do read(mae,regm);
				while(regm.destino = min.destino) and (regm.fecha = min.fecha)and(regm.horaSalida <> min.horaSalida) do begin
					regm.cantAsientosD:= regm.cantAsientosD + min.cantAsientosC;
					minimo(d1,d2,det1,det2,min);
				end;
			end;
		end;
		seek(mae, filepos(mae)-1);
		write(mae,regm);
	end;
	close(det1); close(det2); close(mae);
end;
{-----------------------------}

procedure exportarTxt(var mae:archMae);
var
	carga:text;
	m: maestro;
begin
	assign(carga,'reporte14.txt');
	rewrite(carga);
	reset(mae);
	while not eof(mae)do begin
		read(mae,m);
		with m do writeln(carga,destino,' ',fecha,' ',horaSalida);
	end;
	close(mae); close(carga);
end;

{--------------------------}
{ PP }
var
	mae:archMae;
	det1,det2:archDet;
begin
	assign(mae,'maestro14.data'); 
	assign(det1,'detalle14P1.data');
	assign(det2,'detalle14P2.data');
	importarMaestro(mae);
	importarDetalles(det1,det2);
	actualizarMaestro(mae,det1,det2);
	exportarTxt(mae);
end.
