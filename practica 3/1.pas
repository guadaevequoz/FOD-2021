{4. Agregar al menú del programa del ejercicio 3, opciones para:
a. Añadir una o más empleados al final del archivo con sus datos ingresados por
teclado.
b. Modificar edad a una o más empleados.
c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.
d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).
NOTA: Las búsquedas deben realizarse por número de empleado.}
program punto4;
const  valorAlto=9999;
type
	empleados = record
		num: integer;
		apellido: String;
		nombre: String;
		edad: integer;
		dni: integer;
	end;
	archivo = file of empleados;

procedure leer(var aux: empleados);
begin
	write('Ingrese el Apellido: ');
	readln(aux.apellido);
	if(aux.apellido <> 'fin')then begin
		write('Nombre: ');
		readln(aux.nombre);
		write('DNI: ');
		readln(aux.dni);
		write('Edad: ');
		readln(aux.edad);
		write('Numero: ');
		readln(aux.num);
	end;
	writeln('------------------------------');
end;

procedure cargar(var archNum: archivo);
var
	aux: empleados;
begin
	leer(aux);
	while(aux.apellido <> 'fin')do begin 
		write(archNum,aux);
		leer(aux);
	end;
	
end;
procedure crearArchivo(var archNum: archivo; var archNomb: String);
begin
	write('Nombre del Archivo: ');
	readln(archNomb);
	Assign(archNum,archNomb);
	rewrite(archNum);
	// ------------------------------
	cargar(archNum);
	close(archNum);
end;
procedure buscarEmpleado(var archNum:archivo);
var
	aux: empleados;
	nom,ape: String;
begin
     writeln(' ');
	writeln('-------------- Buscar Empleados --------------');
	writeln('Ingrese nombre: '); readln(nom);
	writeln('Ingrese apellido: '); readln(ape);
	reset(archNum);
	while(not eof(archNum))do begin
		read(archNum,aux);
		if((aux.nombre = nom) OR (aux.apellido = ape))then begin
			writeln('. Nombre: ',aux.nombre,'. Apellido: ',aux.apellido,'. DNI: ',aux.dni,'. Edad: ',aux.edad);
			writeln('------------------------------');
		end;
	end;
	close(archNum);
end;

procedure mostrarTodo(var archNum: archivo);
var
	aux: empleados;
begin
    writeln(' ');
	writeln('-------------- Mostrar Todo --------------');
	reset(archNum);
	while(not eof(archNum))do begin
		read(archNum,aux);
		{if aux.num <> -1 then} writeln(aux.num,'. Nombre: ',aux.nombre,'. Apellido: ',aux.apellido,'. DNI: ',aux.dni,'. Edad: ',aux.edad);
		writeln('------------------------------');
	end;
	close(archNum);
end;

procedure mostrarMayores(var archNum: archivo);
var
	aux: empleados;
begin
     writeln(' ');
	writeln('-------------- Mostrar Mayores a 70 --------------');
		reset(archNum);
	while(not eof(archNum))do begin
		read(archNum,aux);
		if(aux.edad > 70)then begin
			writeln('. Nombre: ',aux.nombre,'. Apellido: ',aux.apellido,'. DNI: ',aux.dni,'. Edad: ',aux.edad);
			writeln('------------------------------');
		end;
	end;
	close(archNum);
end;

{PUNTO 4, inciso A}
{agregar un nuevo empleado}
procedure AgregarMas(var arch: archivo);
var
	aux: empleados;
begin
	writeln(' ');
	writeln('-------------- Agregar otro empleado al archivo --------------');
	reset(arch);
	while(not eof(arch)) do read(arch, aux);
	leer(aux);
	write(arch, aux);
	close(arch);
end;

{PUNTO 4, inciso B}
{actualizar edad de los empleados}
procedure actualizarEdad(var arch: archivo);
var
	aux: empleados;
	edad, num_e: integer;
	opcion: string;
	encontre: boolean;
begin
	writeln(' ');
	writeln('-------------- Actualizar edades --------------');
	opcion:= 'si';
	while(opcion = 'si')or(opcion = 'Si')or(opcion='SI') do begin
		writeln('Ingrese numero de empleado:');
		readln(num_e);
		reset(arch);
		encontre:=false;
		while(not eof(arch))and(not encontre) do begin
			read(arch, aux);
			if(num_e = aux.num) then encontre:=true;
		end;
		if encontre then begin
			writeln('Edad: '); readln(edad);
			seek(arch, filepos(arch)-1);
			aux.edad:= edad;
			write(arch, aux);
		end
		else writeln('No existe el empleado.');
		writeln('¿Desea modificar otra edad?:'); readln(opcion);
	end;
	close(arch);
end;

{PUNTO 4, inciso C}
{c. Exportar el contenido del archivo a un archivo de texto llamado
“todos_empleados.txt”.}
procedure exportar(var arch:archivo);
var
	carga: text;
	e: empleados;
begin
	writeln(' ');
	writeln('-------------- Exportando contenido de archivo --------------');
	assign(carga, 'C:\Users\guada\Desktop\FACULTAD\2021\PRIMERSEMESTRE\FOD\Practica 3\todos_empleados.txt');
	reset(arch);
	rewrite(carga);
	while(not eof(arch)) do begin
		read(arch,e);
		with e do
			writeln(carga,' ',apellido,' ',nombre,' ', edad,' ', dni);
		end;
	writeln('-------------- Exportado exitosamente --------------');
	close(arch); close(carga);
end;

{PUNTO 4, inciso D}
{d. Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados
que no tengan cargado el DNI (DNI en 00).}
procedure exportarDNI(var arch:archivo);
var
	carga: text;
	e: empleados;
begin
	writeln(' ');
	writeln('-------------- Exportando empleados sin DNI --------------');
	assign(carga, 'C:\Users\guada\Desktop\FACULTAD\2021\PRIMERSEMESTRE\FOD\Practica 3\faltaDNIEmpleado.txt');
	reset(arch);
	rewrite(carga);
	while(not eof(arch)) do begin
		read(arch,e);
		if(e.dni = 00) then begin
			with e do
				writeln(carga,' ',apellido,' ',nombre,' ', edad,' ', dni);
			end;
	end;
	writeln('-------------- Exportado exitosamente --------------');
	close(arch); close(carga);
end;

{PRACTICA 3, PUNTO 1}
{Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados.}
procedure leer(var arch:archivo; var aux:empleados);
begin
	if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.num:=valorAlto;
end;

procedure eliminar(var archivo:archivo);
var 
    num:integer;
	reg,aux:empleados;
begin
	assign(archivo, 'arch_empleados');
	reset(archivo);
	{Guardo ultimo registro}
	seek(archivo,filesize(archivo)-1);
	leer(archivo,aux);
	{abro de nuevo el archivo}
	reset(archivo);
	leer(archivo, reg);
	{Pregunto numero de empleado}
	writeln('Ingrese un numero:'); readln(num);
	while (reg.num <> num) do	    
		leer(archivo, reg);
	{Se borra lógicamente}
	seek(archivo, filepos(archivo)-1 );
	write(archivo, aux);
	seek(archivo,filesize(archivo)-1);
	truncate(archivo);
	close(archivo);
end;

{PP}
var
	arch: archivo;
	archNomb: String;
	categoria: integer;
begin
	categoria:= 0;
	while (categoria <> 10)do begin
		writeln('------------------------------');
		writeln('Ingrese un numero para generar: ');
		writeln('Crear un Archivo con empleados(Siempre lo primero): 1');
		writeln('Buscar un empleado especifico: 2');
		writeln('Mostrar todos los empleados: 3');
		writeln('Mostrar los empleados mayores a 70: 4');
		writeln('Agregar otro empleado: 5');
		writeln('Actualizar edades: 6');
		writeln('Exportar todo: 7');
		writeln('Exportar solo los q tienen dni 00: 8');
        writeln('Eliminar un registro: 9');
		write('Numero: ');
		readln(categoria);
		writeln('------------------------------');
		case categoria of
			1: crearArchivo(arch,archNomb);
			2: buscarEmpleado(arch);
			3: mostrarTodo(arch);
			4: mostrarMayores(arch);
			5: agregarMas(arch);
			6: actualizarEdad(arch);
			7: exportar(arch);
			8: exportarDNI(arch);
            9: eliminar(arch);
			else writeln('Numero invalido'); 
		end;
	end;
end.
