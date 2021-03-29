program punto3;
type
	empleados = record
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
	writeln('Ingrese nombre: '); read(nom);
	writeln('Ingrese apellido: '); read(ape);
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
		writeln('. Nombre: ',aux.nombre,'. Apellido: ',aux.apellido,'. DNI: ',aux.dni,'. Edad: ',aux.edad);
		writeln('------------------------------');
	end;
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
end;
var
	archNum: archivo;
	archNomb: String;
	categoria: integer;
begin
	categoria:= 0;
	while (categoria <> 5)do begin
		writeln('------------------------------');
		writeln('Ingrese un numero para generar: ');
		writeln('Crear un Archivo con empleados(Siempre lo primero): 1');
		writeln('Buscar un empleado especifico: 2');
		writeln('Mostrar todos los empleados: 3');
		writeln('Mostrar los empleados mayores a 70: 4');
		write('Numero: ');
		readln(categoria);
		writeln('------------------------------');
		case categoria of
			1: crearArchivo(archNum,archNomb);
			2: buscarEmpleado(archNum);
			3: mostrarTodo(archNum);
			4: mostrarMayores(archNum);
			else writeln('Numero invalido'); 
		end;
	end;
end.
