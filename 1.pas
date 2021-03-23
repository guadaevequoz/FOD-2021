{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}
program uno;
type
    archivo = file of integer;
{ PP }
var
    arch_logico: archivo;
    arch_fisico: string[20];
    num: integer;
begin
    writeln('Ingrese el nombre del archivo: '); //a.data
    readln(arch_fisico); //direccion del archivo fisico
    assign(arch_logico, arch_fisico);
    rewrite(arch_logico); 
    writeln('Ingrese un numero: ');
    read(num);
    while num <> 30000 do begin 
        write(arch_logico, num); //escribo en el archivo logico el numero leido
        writeln('Ingrese un numero: ');
        read(num);
    end;
    close(arch_logico); //cierro el archivo
end.
