program cuatro;
const valoralto='ZZZ';
type
	tTitulo = String[50];
	tArchRevistas = file of tTitulo ;

{-----------------------------------}
procedure importar(var arch:tArchRevistas);
var
    carga: text;
    c: tTitulo;
begin
    writeln(' ');
    assign(carga,'punto4.txt');
    rewrite(arch);
    reset(carga);
    while(not  eof(carga)) do begin
        readln(carga, c);
        write(arch, c);
    end;
    writeln('Archivo cargado.');
    close(arch); close(carga);
end;
{-----------------------------------}

procedure agregar(var arch: tArchRevistas ; titulo: string);
var aux: tTitulo;
	num,cod:integer;
begin
	reset(arch);
    read(arch,aux); //leo lo q hay en la cabecera
    Val(aux,num,cod);
    if num <> 0 then begin //si no esta en 0
		seek(arch,-num); //voy a la posicion que tiene guardada
		read(arch,aux); //leo lo que esta ahí
		seek(arch,filepos(arch)-1);
		write(arch,titulo);
		seek(arch,0);
		write(arch,aux);
    end
    else writeln('No hay espacio.');
    
	close(arch);
end;

{-----------------------------------}
procedure leer(var arch:tArchRevistas; var aux:tTitulo);
begin
	if(not eof(arch))then 
		read(arch,aux)
    else 
		aux:=valoralto;
end;

procedure listar(var arch:tArchRevistas);
var t:tTitulo;
begin
	reset(arch);
	leer(arch,t);
	while t <> valoralto do begin
		if (t[1] <> '-')and(t[1] <> '0') then writeln('Titulo: ', t);
		leer(arch,t);
	end;
	close(arch);
end;
{-----------------------------------}
procedure eliminar(var arch:tArchRevistas);
var n,aux,t,pos:tTitulo;
    posi:integer;
begin
    reset(arch);
    read(arch,aux);
    writeln('Ingrese el titulo a eliminar:'); 
    readln(t);
    leer(arch,n);
    while (t <> n) do	    //busco hasta encontrar el numero
		leer(arch,n);
    if n = t then begin //si lo encuentro guardo la posicion
        posi:=filepos(arch)-1; //guardo la posicion de la baja
        n:=aux;
        seek(arch,posi); 
        write(arch,n); //sobreescribo la baja con los datos de cabecera
        Str(posi,pos);
        aux:='-'+pos;
        seek(arch,0); //me paro en el principio de la lista
        write(arch,aux);
    end
    else writeln('No se encuentra el codigo.');
    close(arch);
end;

{-----------------------------------}
var
	arch:tArchRevistas;
	opcion:integer;
	t:tTitulo;
begin
	assign(arch,'punto4');
	opcion:=-1;
    while(opcion <> 0) do begin
		writeln('----------------------------------');
		writeln('------- ELIJA UNA OPCION ---------');
		writeln('1) Cargar datos.');
		writeln('2) ALTA.');
		writeln('3) BAJA.');
		writeln('4) LISTAR.');
		writeln('0) Salir.');
		readln(opcion);
		case opcion of
			1: importar(arch);
			2: begin 
				writeln('Ingrese un titulo:');
			    readln(t);
			    agregar(arch,t);
			   end;
			3: eliminar(arch);
			4: listar(arch);
		end;
    end;
end. 
