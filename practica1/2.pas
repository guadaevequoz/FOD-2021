{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program dos;
type 
	archivo = file of integer;

{ PP }
var 
	arch_logico: archivo;
	arch_fisico: string;
    num, cant, cantM,suma: integer;
begin
	writeln('Ingrese el nombre del archivo: '); //a.data
    readln(arch_fisico); //direccion del archivo fisico
	assign(arch_logico, arch_fisico);
    reset(arch_logico); 
    cantM:=0; cant:=0; suma:= 0;
    writeln('Elementos del archivo: ');
    while(not eof(arch_logico)) do begin
		read(arch_logico, num);
		
		if num < 1500 then cantM:= cantM + 1; //suma la cantidad de numeros menores a 1500	
		suma:= suma + num; //acumulador de los numeros
		cant:= cant +  1; //sumador de cantidad de numeros
		writeln(cant,' ) ', num); //enlisto los registros
    end;
    close(arch_logico);
    writeln(cantM,' es la cantidad de números menores a 1500.');
    writeln(suma div cant,' es el promedio de los numeros ingresados.');
end.
