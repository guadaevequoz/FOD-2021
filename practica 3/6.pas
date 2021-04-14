program seis;
const valoralto=9999;
type
    prenda = record
        cod:integer;
        desc:string;
        colores: string;
        tipo:string;
        stock: integer;
        precio:real;
    end;
    maestro = file of prenda;
    detalle = file of integer;

{-------------------------}
procedure importarMaestro(var mae:maestro);
var 
    carga:text;
    p:prenda;
begin
    assign(carga,'punto6M.txt');
    reset(carga); rewrite(mae);
    while not eof(carga) do begin
        with p do begin
            readln(carga,cod,stock,desc);
            readln(carga,precio,colores);
            readln(carga,tipo);
        end; 
        write(mae,p);
    end;
    close(mae); close(carga);
end;
{-------------------------}
procedure importarDetalle(var det:detalle);
var 
    carga:text;
    p:integer;
begin
    assign(carga,'punto6D.txt');
    reset(carga); rewrite(det);
    while not eof(carga) do begin
        readln(carga,p);
        write(det,p);
    end;
    close(det); close(carga);
end;
{-------------------------}
procedure leer(var arch:detalle; var dato:integer);
begin
	if(not eof(arch))then read(arch,dato)
		else dato:=valoralto;
end;

procedure leerM(var arch:maestro; var dato:prenda);
begin
	if(not eof(arch))then read(arch,dato)
		else dato.cod:=valoralto;
end;

procedure mezclar(var mae: maestro; var det: detalle);
var
	regm: prenda;
	regd: integer;
begin
	reset(mae); reset(det);
	read(mae,regm);
	leer(det,regd);
	while(regd <> valoralto) do begin
		while(regm.cod <> regd) do read(mae,regm);
		writeln(regd,'- ',regm.cod);
		regm.stock:=0;
		seek(mae, filepos(mae)-1);
		write(mae,regm);
		leer(det,regd);
	end;
	close(det);
	close(mae);
end;
{-------------------------}
procedure compactar(var mae,arch:maestro);
var 
    p:prenda;
begin
    rewrite(arch); reset(mae);
    leerM(mae,p);
    while(p.cod <> valoralto)do begin
        if(p.stock <> 0) then write(arch,p);
        leerM(mae,p);
    end;
    
    close(mae);close(arch);
    Erase(mae);
    Rename(arch, 'punto6M.data');
end;

{-------------------------}

procedure listarCompactado(var arch:maestro);
var p:prenda;
begin
    reset(arch);
    leerM(arch,p);
    while p.cod <> valoralto do begin
        writeln('CODIGO: ',p.cod,'- Descripcion: ',p.desc);
        leerM(arch,p);
    end;    
    close(arch);
end;

{-------------------------}
var 
    mae,arch:maestro;
    det:detalle;
begin
	assign(mae, 'punto6M.data');
	assign(det, 'punto6D.data');
    assign(arch,'punto6.data'); 
    importarMaestro(mae);
    importarDetalle(det);
    mezclar(mae,det);
    compactar(mae,arch);
    listarCompactado(arch);
end.
