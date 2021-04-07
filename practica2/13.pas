program trece;
const valoralto = 9999;
type
	maestro = record
		nroUsuario: integer;
		nomUsuario: string;
		nombre: string;
		apellido: string;
		cantMailsEnviados: integer;
	end;
	detalle = record
		nroUsuario: integer;
		cuentaDestino:string;
		cuerpoMensaje: string;
	end;
	archMae = file of maestro;
	archDet = file of detalle;

{-----------------------------}

procedure importarMaestro(var mae:archMae);
var
	texto: text;
	m: maestro;
begin
	assign(mae,'maestro13.data');
	assign(texto,'maestro13.txt');
	reset(texto); rewrite(mae);
	while not eof(texto)do begin
		with m do begin
			readln(texto,nroUsuario,nomUsuario);
			readln(texto,cantMailsEnviados,nombre);
			readln(texto,apellido);
		end;
		write(mae,m);
	end;
	close(mae); close(texto);
end;

{-----------------------------}

procedure importarDetalle(var det:archDet);
  procedure leerDatos(var d:detalle);
  begin
	write('Numero de usuario: '); readln(d.nroUsuario);
	if d.nroUsuario <> valoralto then begin
		write('Destinatario: '); readln(d.cuentaDestino);
		write('Mensaje: '); readln(d.cuerpoMensaje);
	end;
  end;
  
var
	d: detalle;
begin
	assign(det,'detalle13.data');
	rewrite(det);
	writeln('Escriba el nro 9999 para terminar la carga.');
	leerDatos(d);
	while(d.nroUsuario <> valoralto)do begin
		write(det,d);
		leerDatos(d);
	end;
	close(det);
end;

{-----------------------------}

procedure leer(var det:archDet; var dato:detalle);
begin
	if not eof(det)then 
		read(det,dato)
	else 
		dato.nroUsuario:=9999;
end;

{-----------------------------}

procedure actualizarMaestro(var mae:archMae; var det:archDet);
var
	d:detalle;
	m:maestro;
	aux,acu: integer;
begin
	reset(mae); reset(det);
	leer(det,d);
	while(d.nroUsuario <> valoralto)do begin
		aux:= d.nroUsuario;
		acu:=0;
		while(aux = d.nroUsuario)do begin //como pueden haber mas de 1 reg con el mismo cod acumulo todas las ventas
			acu:=acu+1;
			leer(det,d);
		end;
		//cuando termino de acumular busco el codigo en el maestro
		while(m.nroUsuario <> aux) do read(mae,m);
		m.cantMailsEnviados:= m.cantMailsEnviados + acu;
		seek(mae, filepos(mae)-1);
		write(mae,m);
	end;
	close(mae); close(det);
end;

{-----------------------------}

procedure exportarTxt(var mae: archMae);
var
	carga:text;
	m: maestro;
begin
	assign(carga,'archivoDetDia.txt');
	rewrite(carga);
	reset(mae);
	while not eof(mae)do begin
		read(mae,m);
		with m do writeln(carga,nroUsuario,' ',cantMailsEnviados);
	end;
	close(mae); close(carga);
end;

{-----------------------------}
{ PP }
var
	det:archDet;
	mae:archMae;
begin
	importarMaestro(mae);
	importarDetalle(det);
	assign(mae,'maestro13.data');
	assign(det,'detalle13.data');
	actualizarMaestro(mae,det);
	exportarTxt(mae);
end.
