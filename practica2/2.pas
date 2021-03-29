{Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
* Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Crear el archivo maestro a partir de un archivo de texto llamado “alumnos.txt”.
b. Crear el archivo detalle a partir de en un archivo de texto llamado “detalle.txt”.
c. Listar el contenido del archivo maestro en un archivo de texto llamado
“reporteAlumnos.txt”.
d. Listar el contenido del archivo detalle en un archivo de texto llamado
“reporteDetalle.txt”.
e. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
f. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso e) los archivos deben ser recorridos sólo una vez.}
program dos;
type
	alumno = record
		cod: integer;
		ape: string;
		nom: string;
		cantMA: integer;
		cantFA: integer;
	end;
	alu_det = record
		cod:integer;
		nombre: string;
		finalA: char;
		cursA: char;
	end;
	maestro = file of alumno;
	detalle = file of alu_det;

{PROCESOS}
{INCISO A}
procedure importarMaestro(var arch: maestro);
var 
	carga: text;
	aux: alumno;
begin
	assign(carga,'alumnos.txt');
	assign(arch,'maestro2.data');
	rewrite(arch); reset(carga);
	while(not eof(carga)) do begin
		with aux do readln(carga, cod, ape);
		with aux do readln(carga, nom);
		with aux do readln(carga, cantMA, cantFA);
		write(arch, aux);
	end;
	close(arch); close(carga);
end;

{INCISO B}
procedure importarDetalle(var arch: detalle);
var
	carga: text;
	aux: alu_det;
begin
	assign(carga,'detalle.txt');
	assign(arch,'detalle2.data');
	rewrite(arch); reset(carga);
	while(not eof(carga)) do begin
		with aux do readln(carga, cod, nombre);
		with aux do readln(carga, finalA);
		with aux do readln(carga, cursA);
		write(arch, aux);
	end;
	close(arch); close(carga);
end;

{INCISO C}
procedure listarMaestro(var arch:maestro);
var 
	carga: text;
	aux: alumno;
begin
	assign(carga,'reporteAlumnos.txt');
	assign(arch,'maestro2.data');
	reset(arch); rewrite(carga);
	while(not eof(arch)) do begin
		read(arch, aux);
		with aux do writeln(carga,' ',cod,' ',ape,' ',nom,' ',cantMA,' ',cantFA);
	end;
	close(arch); close(carga);
end;

{INCISO D}
procedure listarDetalle(var arch:detalle);
var 
	carga: text;
	aux: alu_det;
begin
	assign(carga,'reporteDetalle.txt');
	assign(arch,'detalle2.data');
	reset(arch); rewrite(carga);
	while(not eof(arch)) do begin
		read(arch, aux);
		with aux do writeln(carga,' ',cod,' ',nombre,' ', finalA,' ', cursA);
	end;
	close(arch); close(carga);
end;

{INCISO E}
procedure leer(var arch:detalle; var dato:alu_det);
begin
	if(not eof(arch))then read(arch,dato)
		else dato.cod:=9999;
end;

procedure mezclar(var mae: maestro; var det: detalle);
var
	regm: alumno;
	regd: alu_det;
	f,c:integer;
	aux: integer;
begin
	assign(mae, 'maestro2.data');
	assign(det, 'detalle2.data');
	reset(mae); reset(det);
	read(mae,regm);
	leer(det,regd);
	while(regd.cod <> 9999) do begin
		aux:=regd.cod;
		f:=0; c:=0;
		while(aux = regd.cod) do begin
			if regd.finalA = 'A' then f:=f+1;
			if regd.cursA = 'A' then c:=c+1;
			leer(det,regd);
		end;
		while(regm.cod <> aux) do read(mae,regm);
		regm.cantMA := regm.cantMA + c;
		regm.cantFA := regm.cantFA + f;
		seek(mae, filepos(mae)-1);
		write(mae,regm);
		if (not eof(mae)) then read(mae,regm);
	end;
	close(det);
	close(mae);
end;

{INCISO F}
procedure mas4(var mae: maestro);
var 
	carga: text;
	regm: alumno;
begin
	assign(mae, 'maestro2.data');
	assign(carga, 'mas4.txt');
	reset(carga);
	reset(mae); 
	while(not eof(mae)) do begin
		read(mae,regm);
		if((regm.cantMA - regm.cantFA) >= 4) then 
			with regm do writeln(carga,' ',cod,' ',nom,' ', ape,' ', cantMA,' ', cantFA);
	end;
	close(mae);
end;

{PP}
var
	mae: maestro;
	det: detalle;
	opcion: integer;
begin
	opcion:=0;
	while(opcion < 7) do begin
		writeln('1: INCISO A');
		writeln('2: INCISO B');
		writeln('3: INCISO C');
		writeln('4: INCISO D');
		writeln('5: INCISO E');
		writeln('6: INCISO F');
		readln(opcion);
		case opcion of 
			1:importarMaestro(mae);
			2:importarDetalle(det);
			3:listarMaestro(mae);
			4:listarDetalle(det);
			5:mezclar(mae,det);
			6:mas4(mae);
		end;
	end;	
end.
