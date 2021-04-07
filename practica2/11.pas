program once;
const valoralto = 'ZZZ';
type
	info = record
		nom: string;
		cant: integer;
		total: integer;
	end;
	
	maestro = file of info;
{----------------------------}
procedure importarDetalles(var det1,det2:maestro);
var
	deta1,deta2:text;
	i:info;
begin
	assign(det1,'detalle11P1.data');
	assign(det2,'detalle11P2.data');
	assign(deta1,'detalle11P1.txt');
	assign(deta2,'detalle11P2.txt');
	reset(det1); reset(det2);
	reset(deta1); rewrite(det1);
	while not eof(deta1)do begin
		with i do readln(deta1,cant,total,nom);
		write(det1,i);
	end;
	close(deta1); close(det1);
	reset(deta2); rewrite(det2);
	while not eof(deta2)do begin
		with i do readln(deta2,cant,total,nom);
		write(det2,i);
	end;
	close(deta2); close(det2);
end;

{----------------------------}	
procedure importarMaestro(var mae: maestro);
var
	texto: text;
	e: info;
begin
	assign(texto,'maestro11.txt');
	assign(mae,'maestro11.data'); 
	reset(texto);
	rewrite(mae);
	while not eof(texto) do begin
		with e do readln(texto,cant,total,nom);
		write(mae, e);
	end;
	close(mae); close(texto);
end;
{----------------------------}	
procedure leer(var arch:maestro; var aux:info);
begin
    if(not eof(arch))then 
		read(arch,aux)
    else 
		aux.nom:=valorAlto;
end;
{------------------------------------}
procedure minimo(var d1,d2: info; var det1,det2: maestro; var min: info);
begin
    if(d1.nom <= d2.nom)then begin
		min:=d1;
		leer(det1,d1);
    end
    else begin
		min:=d2;
		leer(det2,d2);
    end;
end;
{------------------------------------}
procedure actualizarMaestro(var mae,det1,det2: maestro);
var
	regM,d1,d2,min: info;
begin
	assign(mae,'maestro11.data'); 
	assign(det1,'detalle11P1.data');
	assign(det2,'detalle11P2.data');
	reset(det1); reset(det2); reset(mae);
	leer(det1,d1); leer(det2,d2);
	minimo(d1,d2,det1,det2,min);
	while(min.nom <> valoralto)do begin
		read(mae,regm);
		while(regm.nom <> min.nom)do read(mae,regm);
		while(regm.nom = min.nom)do begin
			regm.cant:= regm.cant + min.cant;
			regm.total := regm.total + min.total;
			minimo(d1,d2,det1,det2,min);
		end;
		seek(mae, filepos(mae)-1);
		write(mae,regm);
	end;
	
	close(det1); close(det2); close(mae);
end;

{----------------------------}	

procedure ExportarATxtMaestro(var archivoMae:maestro);
var
    texto:Text;
    r:info;
begin
    assign(archivoMae,'maestro11.data');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'reporteMaestro11.txt');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
			writeln(texto,' ',nom,' ',cant,' ',total);
		end;

    end;
    close(texto);
    close(archivoMae);
end;

{----------------------------}	
var
	mae,det1,det2:maestro;
begin

	importarDetalles(det1,det2);
	importarMaestro(mae);
	
	actualizarMaestro(mae,det1,det2);
	exportaratxtmaestro(mae);
end.
