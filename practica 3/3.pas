program tres;
const valoralto=9999;
type
    novelas = record
        cod:integer;
        genero: string;
        nombre: string;
        duracion: integer;
        director:string;
        precio:real;
    end;
    archivo = file of novelas;

{---------------------------}
{LEER DATOS DE LAS NOVELAS}
procedure leerDatos(var n:novelas);
begin
    writeln('--------------------------------');
    write('Codigo de novela:'); readln(n.cod);
    if(n.cod <> valoralto)then begin
        write('Codigo de novela:'); readln(n.genero);
        write('Genero de novela:'); readln(n.nombre);
        write('Nombre de novela:'); readln(n.duracion);
        write('Duracion de novela:'); readln(n.director);
        write('Precio de novela:'); readln(n.precio);
    end;
end;

{inciso A}
procedure crearArchivo(var arch:archivo);
var 
    n:novelas;
begin
    writeln('--------------------------------');
    writeln('-------INGRESO DE DATOS---------');
    rewrite(arch);
    leerDatos(n);
    while(n.cod <> valoralto) do begin
        write(arch,n);
        leerDatos(n);
    end;
    close(arch);
end;

{---------------------------}
{PROCESOS DEL INCISO B}
procedure leer(var arch:archivo; var aux:novelas);
begin
	if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.cod:=valorAlto;
end;

procedure alta(var arch:archivo);
var n,aux:novelas;
begin
    reset(arch);
    leerDatos(n);
    read(arch,aux); //leo lo q hay en la cabecera
    if aux.cod <> 0 then begin //si no esta en 0
		seek(arch,-aux.cod); //voy a la posicion que tiene guardada
		read(arch,aux); //leo lo que esta ahí
		seek(arch,filepos(arch)-1);
		write(arch,n);
		seek(arch,0);
		write(arch,aux);
    end
    else begin
		seek(arch,filesize(arch));
		write(arch,n);
	end;
end;

procedure modificar(var arch:archivo);
var
	n:novelas;
	cod:integer;
begin
    writeln('Ingrese el codigo de la novela a modificar:');
    readln(cod);
    reset(arch);
    leer(arch,n);
    if(n.cod <> valoralto)then begin
		while(n.cod <> cod)do leer(arch,n);
		n.cod:=cod;
		write('Genero de novela:'); readln(n.genero);
        write('Nombre de novela:'); readln(n.nombre);
        write('Duracion de novela:'); readln(n.duracion);
        write('Director de novela:'); readln(n.director);
        write('Precio de novela:'); readln(n.precio);
		seek(arch,filepos(arch)-1);
		write(arch,n);
    end;
    close(arch);
end;

procedure baja(var arch:archivo);
var n,aux:novelas;
    num,posi:integer;
begin
    reset(arch);
    read(arch,aux);
    writeln('Ingrese el codigo de la novela a eliminar:'); 
    readln(num);
    leer(arch,n);
    while (n.cod <> num) do	    //busco hasta encontrar el numero
		leer(arch,n);
    if n.cod = num then begin //si lo encuentro guardo la posicion
        posi:=filepos(arch)-1; //guardo la posicion de la baja
        n:=aux;
        seek(arch,posi); 
        write(arch,n); //sobreescribo la baja con los datos de cabecera
        aux.cod:=-posi;
        seek(arch,0); //me paro en el principio de la lista
        write(arch,aux);
    end
    else writeln('No se encuentra el codigo.');
    close(arch);
end;

{INCISO B}
procedure abrirArchivo(var arch:archivo);
var
    opcion: integer;
begin
    opcion:=-1;
    while(opcion <> 0) do begin
		writeln('----------------------------------');
		writeln('------- ELIJA UNA OPCION ---------');
		writeln('1) Dar alta a novela.');
		writeln('2) Modificar datos de novela.');
		writeln('3) Eliminar una novela.');
		writeln('0) Salir.');
		readln(opcion);
		case opcion of
			1: alta(arch);
			2: modificar(arch);
			3: baja(arch);
		end;
    end;
end;

{----------------------------}
procedure exportar(var arch:archivo);
var
	i:novelas;
	carga:text;
begin
	assign(carga,'novelas.txt');
	rewrite(carga);
	reset(arch);
	while not eof(arch) do begin
		read(arch,i);
		with i do writeln(carga,'COD: ',cod,' - Nombre: ',nombre,' - Genero: ',genero);
	end;
	close(arch); close(carga);
end;
{---------------------------}
var
    arch:archivo;
begin
    assign(arch,'punto3');
    crearArchivo(arch);
    abrirArchivo(arch);
    exportar(arch);
end.
