program ej4;
const valorAlto = 9999;
	  dimF = 5;
type 
	regDetalle = record //detalle
		cod: integer;
		fecha: integer;
		tiempoSesion: integer;
	end;
	
	regMaestro = record //maestro
		cod: integer;
		fecha: integer;
		totalSesiones: integer;
	end;
	
	maestro = file of regMaestro;
	detalle = file of regDetalle;
	vectorArchivoDetalle = array[1..dimF] of detalle;
	vectorRegistroDetalle = array[1..dimF] of regDetalle;

procedure Leer(var archivoDeta:detalle; var datoD:regDetalle);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.cod:=valoralto;
end;
procedure minimo(var vectorArc:vectorArchivoDetalle; var vectorReg:vectorRegistroDetalle; var min:regDetalle);
var
    i,minPos:integer;
begin
    min.cod:=9999;
    min.fecha:=9999;
    for i:=1 to dimF do begin
        if (vectorReg[i].cod < min.cod) then begin
            min:=vectorReg[i];
            minPos:=i;
        end;
    end;
    for i:=1 to dimF do begin
		if(vectorReg[i].cod = min.cod)then begin
			if (vectorReg[i].fecha < min.fecha) then begin
				min:=vectorReg[i];
				minPos:=i;
			end;
        end;
    end;
    if (min.cod <> 9999) then
        leer(vectorArc[minPos],vectorReg[minPos]);
end;
{------------------------------------------------------------}
procedure ExportarATxtMaestro(var archivoMae:maestro);
var
    texto:Text;
    r:regMaestro;
begin
    assign(archivoMae,'maestroS.data');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'reporteServidores.txt');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' ',cod,' ',fecha,' ',totalSesiones);
        end;
    end;
    close(texto);
    close(archivoMae);
end;

procedure CrearMaestro(var vecArch:vectorArchivoDetalle;var vecReg:vectorRegistroDetalle; var mae:maestro);
var
    min:regDetalle;
    regM:regMaestro;
    i:integer;
begin
    assign(mae,'maestroS.data');
    rewrite(mae); //creo mi maestro
    minimo(vecArch,vecReg,min); //busco el de codminimo y fecha minima
    while(min.cod <> 9999)do begin
        regM.cod:=min.cod;
        while(regM.cod = min.cod)do begin
			regM.fecha:=min.fecha;
			regM.totalSesiones:=0;
			while (min.cod <> 9999) and ((min.cod=regM.cod) and (min.fecha=regM.fecha)) do begin
				regM.totalSesiones:= regM.totalSesiones + min.tiempoSesion;        
				minimo(vecArch,vecReg,min);
			end;
			writeln(regM.cod,' ',regM.fecha,' ',regM.totalSesiones);
			write(mae,regM);
        end;
    end;
    close(mae);
    for i:=1 to dimF do
      close(vecArch[i]);

end;

var
	i:integer;
    iString:String;
    vectorArc:vectorArchivoDetalle; // vector de archivos
    vectorReg:vectorRegistroDetalle; //vector de registros
    mae:maestro;
begin
	for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalle'+iString);
        reset(vectorArc[i]); //habilito lectura todos los archivos
        Leer(vectorArc[i],vectorReg[i]);
    end;
    crearMaestro(vectorArc,vectorReg,mae);
        ExportarATxtMaestro(mae);
end.
