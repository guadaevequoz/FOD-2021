program seis;
const 
	valorAlto = 9999;
	dimF = 5;
type
	articulos = record
		cod:integer;
		nom: string;
		desc: string;
		talle: integer;
		color: string;
		stockD: integer;
		stockM: integer;
		precio: integer;
	end;
	articulosD = record
		cod:integer;
		cantV:integer;
	end;
	
	maestro = file of articulos;
	detalle = file of articulosD;
	vecDetalle = array [1..dimF] of detalle;
	vecRegDetalle = array[1..dimF] of articulosD;

{----------------------------------------}
procedure importarMaestro(var mae: maestro);
var
	carga: text;
	a: articulos;
begin
	assign(mae,'maestroArt.data');
	assign(carga,'textoArticulos.txt');
	rewrite(mae); reset(carga);
	while(not eof(carga))do begin
		with a do readln(carga, cod, talle, nom);
		with a do readln(carga, stockD, stockM, color);
		with a do readln(carga, precio, desc);
		write(mae,a);
	end;
	close(mae); close(carga);
end;

{----------------------------------------}

procedure Leer(var archivoDeta:detalle; var datoD:articulosD);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.cod:=valoralto;
end;

{----------------------------------------}

procedure minimo(var vectorArc:vecDetalle; var vectorReg:vecRegDetalle; var min:articulosD);
var
    i,minPos:integer;
begin
    min.cod:=9999;
    for i:=1 to dimF do begin
        if (vectorReg[i].cod < min.cod) then begin
            min:=vectorReg[i];
            minPos:=i;
        end;
    end;
    if (min.cod <> valoralto) then
        Leer(vectorArc[minPos],vectorReg[minPos]);
end;

{----------------------------------------}
procedure actualizarMaestro(var vectorArc:vecDetalle; var vectorReg:vecRegDetalle; var mae:maestro);
var
    regM:articulos;
    i:integer;
    min:articulosD;
begin
	reset(mae);
    minimo(vectorArc,vectorReg,min);//busco el codigo minimo entre los archivos detalles
    while (min.cod <> valoralto) do begin //mientras el archivo detalle no termine
        read(mae,regM);
        while(regM.cod <> min.cod) do
            read(mae,regM);
        while(regM.cod = min.cod) do begin
            regM.stockD:=regM.stockD-min.cantV;
            minimo(vectorArc,vectorReg,min);
        end;
        seek(mae,filepos(mae)-1);
        write(mae,regM);
    end;
    close(mae);
    for i:=1 to dimF do begin
        close(vectorArc[i]);
    end;
end;

{--------------------------------------}
procedure ExportarATxtMaestro(var archivoMae:maestro);
var
    texto:Text;
    r:articulos;
begin
    assign(archivoMae,'maestroArt.data');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'articulosStockDispMin.txt');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        if r.stockD < r.stockM then 
			with r do begin
				writeln(texto,' ',nom,' ',desc,' ',stockD,' ',precio);
			end;

    end;
    close(texto);
    close(archivoMae);
end;

{ PP }
var
    i:integer;
    iString:String;
    vectorArc:vecDetalle; // vector de archivos
    vectorReg:vecRegDetalle; //vector de registros
    mae:maestro;
begin
	for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalleArt'+iString);
        reset(vectorArc[i]); //habilito lectura todos los archivos
        Leer(vectorArc[i],vectorReg[i]);
    end;
    importarMaestro(mae);
    actualizarMaestro(vectorArc,vectorReg,mae);
    ExportarATxtMaestro(mae);

end.
