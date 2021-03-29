{6. Agregar al menú del programa del ejercicio 5, opciones para:

a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}
program seis;
uses crt;
type
	celular = record
		cod: integer;
		nom: string;
		des: string;
		//marca: string;
		precio: real;
		stockMin: integer;
		stock: integer;
	end;
	archivo_c = file of celular;

{PROCESOS}
{INCISO A}
procedure crearArchivo(var arch: archivo_C);
var
	fisico: string;
	carga: text;
	c: celular;
begin
	writeln(' ');
	writeln('-------------- USTED ELIGIO LA OPCION DE CARGAR UN ARCHIVO BINARIO --------------');
	writeln('Nombre del archivo fisico: ');
	readln(fisico); 
	assign(arch,fisico);
	assign(carga,'C:\Users\guada\Desktop\FACULTAD\2021\PRIMERSEMESTRE\FOD\Practica 1\celulares.txt');
	rewrite(arch);
	reset(carga);
	while(not  eof(carga)) do begin
		with c do readln(carga, cod, precio, nom);
		with c do readln(carga, stock, stockMin, des);
		write(arch, c);
	end;
	writeln('Archivo cargado.');
	close(arch); close(carga);
end;

{INCISO B}
procedure listarStockMin(var arch:archivo_c);
var
	c:celular;
begin
	writeln(' ');
	writeln('-------------- USTED ELIGIO LA OPCION DE LISTAR STOCK MINIMO --------------');
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, c);
		if c.stock < c.stockMin then writeln('Nombre: ',c.nom,' - Codigo:', c.cod);
	end;
	close(arch);
end;

{INCISO C}
procedure listarDescUsuario(var arch:archivo_c);
var
	desc: string;
	c:celular;
begin
	writeln(' ');
	writeln('USTED ELIGIO LA OPCION DE LISTAR CELULARES CON SU DESCRIPCION');
	writeln('---------------');
	writeln('Ingrese una descripcion: '); readln(desc);
	desc:= ' ' + desc;
	reset(arch);
	while(not eof(arch)) do begin
		read(arch, c);
		if(c.des = desc) then writeln('Nombre: ',c.nom,' - Codigo:', c.cod);
	end;
	close(arch);
end;

{INCISO D}
procedure exportar(var arch:archivo_c);
var
	carga: text;
	c:celular;
begin
	writeln(' ');
	writeln('-------------- USTED ELIGIO LA OPCION DE EXPORTAR A celular.txt --------------');
	assign(carga, 'C:\Users\guada\Desktop\FACULTAD\2021\PRIMERSEMESTRE\FOD\Practica 1\celular.txt');
	reset(arch);
	rewrite(carga);
	while(not eof(arch)) do begin
		read(arch,c);
		with c do
			writeln(carga,' ',cod,' ',nom,' ', des,' ',precio,' ',stockMin,' ',stock);
		end;
	writeln('-------------- Exportado exitosamente --------------');
	close(arch); close(carga);
end;


{PUNTO 6, PROCESOS}
procedure leerCel(var c:celular);
begin
	writeln('Codigo: '); readln(c.cod);
	writeln('Nombre: '); readln(c.nom);
	writeln('Descripcion: '); readln(c.des);
	writeln('Precio: '); readln(c.precio);
	writeln('Stock minimo: '); readln(c.stockMin);
	writeln('Stock: '); readln(c.stock);
end;

{PUNTO 6, INCISO A}
procedure agregarCelular(var arch:archivo_c);
var opcion:string;
	aux:celular;
begin
	writeln(' ');
	writeln('-------------- Agregar otro celular al archivo --------------');
	opcion:='si';
	reset(arch);
	while(opcion = 'si')do begin
		while(not eof(arch))do read(arch,aux);
		leerCel(aux);
		write(arch,aux);
		writeln('¿Desea añadir otro celular?:'); readln(opcion);
	end;
	close(arch);
end;

{PUNTO 6, INCISO B}
procedure modificarStock(var arch:archivo_c);
var
	cod: integer;
	encontre: boolean;
	stock:  integer;
	c:celular;
begin
	encontre:= false;
	writeln(' ');
	writeln('-------------- Modificar  --------------');
	reset(arch);
	writeln('Ingrese nombre del celular: '); readln(cod);
	while(not eof(arch)) and  (not encontre) do begin
		read(arch,c);
		if (cod = c.cod) then encontre:= true;
	end;
	if encontre then begin
		writeln('Ingrese stock a actualizar: '); readln(stock);
		seek(arch, filepos(arch)-1);
		c.stock:= stock;
		write(arch,c);
	end;
	close(arch);
end;

{PUNTO 6, INCISO C}
procedure exportarSinStock(var arch:archivo_c);
var
	carga: text;
	c:celular;
begin
	writeln(' ');
	writeln('-------------- Exportando empleados sin stock --------------');
	assign(carga, 'C:\Users\guada\Desktop\FACULTAD\2021\PRIMERSEMESTRE\FOD\Practica 1\SinStock.txt');
	reset(arch);
	rewrite(carga);
	while(not eof(arch)) do begin
		read(arch,c);
		if(c.stock = 0) then begin
			with c do
				writeln(carga,' ',cod,' ',nom,' ', des,' ',precio,' ',stockMin,' ',stock);
			end;
	end;
	writeln('-------------- Exportado exitosamente --------------');
	close(arch); close(carga);
end;

{PP}
var
	arch: archivo_c;
	opcion: integer;
begin
	opcion:=0;
	while(opcion < 8)do begin
	writeln('Ingrese una opcion: ');
	writeln('1: Crear archivo');
	writeln('2: Listar clulares con stock menor al minimo.');
	writeln('3: Listar celulares con descripcion ingresada por usted.');
	writeln('4: Exportar a txt');
	writeln('5: Añadir uno o más celulares.');
	writeln('6: Modificar el stock de un celular dado..');
	writeln('7: Exportar a sinstock.txt');
	readln(opcion);
	clrscr();
	case opcion of
		1: crearArchivo(arch);
		2: listarStockMin(arch);
		3: listarDescUsuario(arch);
		4: exportar(arch);
		5: agregarCelular(arch);
		6: modificarStock(arch);
		7: exportarSinStock(arch);
	end;
	end;
end.
