program dos;
const valorAlto=9999;
type
    empleado = record
        cod:integer;
        apenom:string;
        dir: string;
        telefono:integer;
        dni:longint;
    end;
    archivo = file of empleado;

{-----------------------}

procedure crearArchivo(var arch:archivo);
var 
    carga: text;
    emp: empleado;
begin
    rewrite(arch);
    assign(carga,'info2.txt');
    reset(carga);
    while not eof(carga) do begin
        with emp do begin
            read(carga,cod,telefono,apenom);
            read(carga,dni,dir);
        end;
        write(arch,emp);
    end;
end;

{-----------------------}

procedure leer(var arch:archivo; var aux:empleado);
begin
	if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.cod:=valorAlto;
end;

{-----------------------}

procedure eliminarDNI(var archivo:archivo);
var 
    reg: empleado;
begin
	reset(archivo);
	leer(archivo, reg);
	while (reg.cod <> valorAlto) do begin
        {elimino solo si el DNI es menor a 8.000.000}
        if(reg.dni <= 8000000)then begin
	        reg.apenom := '*'+ reg.apenom;	//marca de borrado
	        seek(archivo, filepos(archivo)-1 );
	        write(archivo, reg);
        end;
        leer(archivo, reg);
    end;
	close(archivo);
end;

{-----------------------}

procedure exportar(var arch:archivo);
var 
    carga: text;
    emp: empleado;
begin
    assign(carga,'reporte2.txt');
    rewrite(carga); reset(arch);
    while not eof(arch) do begin
		read(arch,emp);
        with emp do write(carga,' ',dni,' ',apenom);
    end;
    close(carga); close(arch);
end;
procedure mostrarTodo(var archNum: archivo);
var
	aux: empleado;
begin
    writeln(' ');
	writeln('-------------- Mostrar Todo --------------');
	reset(archNum);
	while(not eof(archNum))do begin
		read(archNum,aux);
		if(aux.apenom[1] <> '*') then writeln(aux.cod,'. DNI: ',aux.dni);
		writeln('------------------------------');
	end;
	close(archNum);
end;

{-----------------------}
var 
    arch:archivo;
begin
    assign(arch,'arch2');
    crearArchivo(arch);
    mostrarTodo(arch);
    eliminarDNI(arch);
    mostrarTodo(arch);
    exportar(arch);
end.
