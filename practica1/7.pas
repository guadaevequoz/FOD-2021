{7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.

NOTA: La información en el archivo de texto consiste en: código de novela,
nombre,género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}
program siete;
type
	novela = record
		cod: integer;
		nombre: string;
		genero: string;
		precio: integer;
	end;
	archivo_n = file of novela;

{PROCESOS}
procedure crearArchivo(var arch: archivo_n);
var
    fisico: string;
    carga: text;
    n: novela;
begin
    writeln(' ');
    writeln('USTED ELIGIO LA OPCION DE CARGAR UN ARCHIVO BINARIO');
    writeln('Nombre del archivo fisico: ');
    
    readln(fisico); 
    assign(arch,fisico);
    assign(carga,'C:\Users\guada\Desktop\FACULTAD\2021\PRIMERSEMESTRE\FOD\Practica 1\novelas.txt');
    rewrite(arch);
    reset(carga);
    while(not  eof(carga)) do begin
        with n do readln(carga, cod, precio, genero);
        with n do readln(carga, nombre);
        write(arch, n);
    end;
    writeln('Archivo cargado.');
    close(arch); close(carga);
end;

{inciso b}
procedure actualizarArchivo(var arch:archivo_n);
	{leer datos de novela}
	procedure leerNovela(var n:novela);
	begin
		writeln('Ingrese datos de nueva novela:');
		writeln('Codigo:'); readln(n.cod);
		writeln('Nombre:'); readln(n.nombre);
		writeln('Genero:'); readln(n.genero);
		writeln('Precio:'); readln(n.precio);
	end;
	
	procedure agregar(var arch: archivo_n);
	var 
		n:novela;
	begin
			reset(arch);
		seek(arch, filesize(arch));
		leerNovela(n);
		write(arch,n);
		close(arch);
	end;
	
	procedure modificar(var arch:archivo_n);
	var cod: integer;
		n: novela;
		encontre: boolean;
	begin
		{modifico}
		reset(arch);
		encontre:=false;
		writeln('Ingrese el codigo de un libro a actualizar:'); readln(cod);
		while (not eof(arch)) and (not encontre) do begin
			read(arch,n);
			if n.cod = cod then encontre:=true;
		end;
		if encontre then begin
			leerNovela(n);
			seek(arch, filepos(arch)-1);
			write(arch,n);
		end;
		close(arch);
	end;
	procedure imprimir(var arch: archivo_n);
	var
		n:novela;
	begin
		reset(arch);
		while(not eof(arch))do begin
			read(arch,n);
			writeln('Cod: ', n.cod,' - Nombre: ', n.nombre);
		end;
		close(arch);
	end;
var
	opcion: integer;
begin
	opcion:=0;
	while(opcion < 4) do begin
		writeln('1: añadir.');
		writeln('2: modificar.');
		writeln('3: enlistar.');
		writeln('Opcion: '); readln(opcion);
		case opcion of
			1:agregar(arch);
			2:modificar(arch);
			3:imprimir(arch);
		end;
	end;
	close(arch);
end;

{ PP }
var
	arch: archivo_n;
	opcion: integer;
begin
	opcion:=0;
	while(opcion < 3) do begin
		writeln('1: exportar de txt a binario.');
		writeln('2: Abrir archivo.');
		writeln('Opcion: '); readln(opcion);
		case opcion of
		1:crearArchivo(arch);
		2:actualizarArchivo(arch);
		end;
	end;
end.
