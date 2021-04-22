program siete;
const valoralto=9999;
type
	viaExtincion= record
		cod: integer;
		nombre: string;
		familia: string;
		desc: string;
		zona: string;
	end;
	archivo = file of viaExtincion;
	
{-------------------------}

procedure importar(var arch:archivo);
var
	carga: text;
	v:viaExtincion;
begin
	assign(carga,'punto7.txt');
	reset(carga); rewrite(arch);
	while not eof(carga) do begin
		with v do begin
			readln(carga, cod, nombre);
			readln(carga, familia);
			readln(carga, desc);
			readln(carga, zona);
		end;
		write(arch,v);
	end;
	close(arch); close(carga);
end;

{-------------------------}

procedure leer(var arch:archivo; var dato:viaExtincion);
begin
	if not eof(arch) then 
		read(arch,dato)
	else dato.cod:=valorAlto;
end;

{-------------------------}

procedure marcar(var arch:archivo);
var
	reg: viaExtincion;
	cod: integer;
begin
	reset(arch);
	cod:=0;
	leer(arch,reg);
	while (reg.cod <> valoralto) and (cod <> valoralto) do begin
		writeln('Ingrese el codigo de especie a eliminar: ');
		read(cod);
		if(cod <> valoralto)and(reg.cod <> valoralto)then begin
			while(cod <> reg.cod)and(valoralto <> reg.cod) do leer(arch,reg);
			if cod = reg.cod then begin
				reg.cod := -1;
				seek(arch,filepos(arch)-1);
				writeln(reg.cod);
				write(arch,reg);
			end;
		end;
		reset(arch);
	end;
	close(arch);
end;

{-------------------------}

procedure compactar(var arch:archivo);
var
	pos1,pos2: integer;
	reg,aux: viaExtincion;
begin
	reset(arch);
	leer(arch,reg);
	pos2:=filesize(arch)-1; //guardo la posicion del ultimo archivo
	pos1:=0;
	while reg.cod <> valoralto do begin //mientras no llegue al final del archivo (lea demás)
		while(reg.cod <> -1)and(pos1 < pos2) do begin //mientras no sea un codigo eliminado y la posicion inicial no supere al final
			leer(arch,reg); 
			pos1:= pos1 + 1; //aumento la posicion donde estoy parado
		end;
		if(pos1 = pos2) then begin 
			if reg.cod = -1 then seek(arch,pos1) //si es una baja voy a esa posicion
			else seek(arch,pos1+1); //sino voy a la que le sigue
			truncate(arch); //trunco 
			reg.cod:=valoralto; //corto el while
		end
		else begin
		if (reg.cod = -1) then begin //si es una baja
			seek(arch,pos2); //voy al ultimo disponible y lo leo
			leer(arch,aux);
				while(aux.cod = -1)and(pos2<>pos1)do begin //mientras sea ua baja
					pos2:=pos2-1; //subo 
					seek(arch,pos2);
					leer(arch,aux);
				end;
				if aux.cod <> -1 then begin //si no es una baja
					seek(arch,pos1); //voy a la posicion a reemplazar
					reg:=aux;
					write(arch,aux); //sobreescribo
					pos2:=pos2-1; //reduzco la ultima posicion
				end;
			end;
		end;
	end;
	
	close(arch);
end;

{-------------------------}

procedure mostrar(var arch:archivo);
var
	reg: viaExtincion;
begin
	writeln('---------------------------------');
	reset(arch);
	leer(arch,reg);
	while reg.cod <> valoralto do begin
		writeln('COD: ',reg.cod,'- NOMBRE: ',reg.nombre);
		leer(arch,reg);
	end;
	writeln('---------------------------------');
	close(arch);
end;

{-------------------------}
var
	arch: archivo;
begin
	assign(arch,'punto7');
	importar(arch);
	marcar(arch);
	mostrar(arch);
	compactar(arch);
	mostrar(arch);
end.
