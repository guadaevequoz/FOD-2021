{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}
program uno;
type
	empleado = record
		cod: integer;
		nom: string;
		monto: real;
	end;
	archivos = file of empleado;
	
{PROCESOS PARA CREAR EL ARCHIVO Y VER SI FUNCIONA EL PROGEAMA}

procedure crearArchivo(var arch: archivos);
var
	aux: empleado;
	carga: text;
begin
	assign(carga,'empleados.txt');
	assign(arch,'emp.data');
	rewrite(arch); reset(carga);
	while(not eof(carga)) do begin
		with aux do readln(carga,cod, monto, nom);
		write(arch, aux);
	end;
	close(arch); close(carga);
end;

procedure mostrarTodo(var arch: archivos);
var
	aux: empleado;
begin
     writeln(' ');
	writeln('-------------- Mostrar --------------');
	reset(arch);
	while(not eof(arch))do begin
		read(arch,aux);
		writeln('. Cod: ',aux.cod,'. Nombre: ',aux.nom,'. Monto: ',aux.monto:0:2);
		writeln('------------------------------');
	end;
	close(arch);
end;

{PROCESOS QUE SI NECSITO}
procedure leer(var arch:archivos; var emp: empleado);
begin
	if(not eof(arch))then read(arch,emp)
		else emp.cod:=9999;
end;
{ PP }
var
	regM, regD: empleado;
	mae, det: archivos;
	total: real;
	act:empleado;
begin
	crearArchivo(det);
	mostrarTodo(det);
	
	assign(mae,'maestro.data');
	rewrite(mae); reset(det);
	leer(det,regD);
	while(regD.cod <> 9999) do begin
		total:=0;
		act:= regD;
		while(regD.cod = act.cod)do begin
			total:= total + regD.monto;
			leer(det,regD);
		end;
		regM.cod:= act.cod; regM.nom:=act.nom; regM.monto:=total; 
		seek(mae,filesize(mae));
		write(mae,regM);
	end;
	mostrarTodo(mae);
end.
