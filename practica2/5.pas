program cinco;
const dimF = 5; //delegaciones
	valorAlto = 9999;
type
	direccion = record
		calle: integer;
		numero: integer;
		piso: integer;
		depto: integer;
		ciudad: integer;
	end;
	
	detalleNac = record
		nroParNac: integer;
		nombre: string;
		apellido: string;
		dir: direccion;
		matriMedico: integer;
		nomYApeMadre: string;
		dniMadre: integer;
		nomYApePadre: string;
		dniPadre: integer;
	end;
	detalleFall = record
		nroParNac: integer;
		dni: integer;
		apeYnom: string;
		matriMedico: integer;
		fechaYhora: string;
		lugar: string;
	end;
	
	maestro = record
		nroParNac: integer;
		nombre: string;
		apellido: string;
		dir: direccion;
		matriMedicoN: integer; //del medico del nacimiento
		nomYApeMadre: string;
		dniMadre: integer;
		nomYApePadre: string;
		dniPadre: integer;
		//todo esto si falleció
		matriMedicoD: integer; //del medico de defuncion
		fechaYhora: string;
		lugar: string;
	end;
	
	maestroA = file of maestro;
	detNaci = file of detalleNac;
	detFall = file of detalleFall;
	vecDetalleNaci = array [1..dimF] of detNaci;
	vecDetalleFall = array [1..dimF] of detFall;
	vecRegNaci = array [1..dimF] of detalleNac;
	vecRegFall = array [1..dimF] of detalleFall;
	
{----------------- PROCESOS LEER ---------------------}

procedure LeerN(var archivoDeta:detNaci; var datoD:detalleNac);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.nroParNac:=valoralto;
end;

procedure LeerF(var archivoDeta:detFall; var datoD:detalleFall);
begin
    if(not EOF(archivoDeta)) then
        read(archivoDeta,datoD)
    else
        datoD.nroParNac:=valoralto;
end;

{----------------- PROCESOS MINIMO -----------------}
procedure minimoN(var vectorArc:vecDetalleNaci; var vectorReg:vecRegNaci; var min:detalleNac);
var
    i,minPos:integer;
begin
    min.nroParNac:=9999;
    for i:=1 to dimF do begin
        if (vectorReg[i].nroParNac < min.nroParNac) then begin
            min:=vectorReg[i];
            minPos:=i;
        end;
    end;
    if (min.nroParNac <> valoralto) then
        LeerN(vectorArc[minPos],vectorReg[minPos]);
end;

procedure minimoF(var vectorArc:vecDetalleFall; var vectorReg:vecRegFall; var min:detalleFall);
var
    i,minPos:integer;
begin
    min.nroParNac:=9999;
    for i:=1 to dimF do begin
        if (vectorReg[i].nroParNac < min.nroParNac) then begin
            min:=vectorReg[i];
            minPos:=i;
        end;
    end;
    if (min.nroParNAC <> valoralto) then
        LeerF(vectorArc[minPos],vectorReg[minPos]);
end;


{------------------------------------------------------------}
procedure cargarRegMaestro(var reg: maestro; regN: detalleNac);
begin
	reg.nroParNac:= regN.nroParNac;
	reg.nombre:= regN.nombre;
	reg.apellido:= regN.apellido;
	reg.dir:= regN.dir;
	reg.matriMedicoN:= regN.matriMedico;
	reg.nomYApeMadre:= regN.nomYApeMadre;
	reg.dniMadre:= regN.dniMadre;
	reg.nomYApePadre:= regN.nomYApePadre;
	reg.dniPadre:= regN.dniPadre;
	reg.matriMedicoD:= -1;
	reg.fechaYhora:= ' ';
	reg.lugar:= ' ';
end;

{------------------------------------------------------------}

procedure crearMaestro(var vectorArcF:vecDetalleFall; var vectorRegF:vecRegFall; var mae:maestroA;
						    var vectorArcN:vecDetalleNaci; var vectorRegN:vecRegNaci);
var
    regM:maestro;
    i:integer;
    minF:detalleFall; minN: detalleNac;
    
begin
	assign(mae,'maestroSiniestro.data');
    rewrite(mae); //creo mi maestro
    minimoN(vectorArcN,vectorRegN,minN);//busco el codigo minimo entre los archivos detalles
    while (minN.nroParNac <> valoralto) do begin //mientras el archivo detalle no termine
		cargarRegMaestro(regM,minN);
		write(mae,regM);
		minimoN(vectorArcN,vectorRegN,minN);//busco el codigo minimo entre los archivos detalles
    end;
    for i:=1 to dimF do 
        close(vectorArcN[i]);
     minimoF(vectorArcF,vectorRegF,minF);
     
     reset(mae);
     while(minF.nroParNac <> valoralto) and(not eof(mae))do begin
		while(regm.nroParNac <> minF.nroParNac) do read(mae,regm);
		regm.matriMedicoD:= minF.matriMedico;
		regm.fechaYhora:= minF.fechaYhora;
		regm.lugar:= minF.lugar;
		seek(mae,filepos(mae)-1);
		write(mae,regm);
		minimoF(vectorArcF,vectorRegF,minF);
     end;
     for i:=1 to dimF do 
        close(vectorArcF[i]);
    close(mae);
end;
{------------------------------------------------------------}
procedure ExportarATxtMaestro(var archivoMae:maestroA);
var
    texto:Text;
    r:maestro;
begin
    assign(archivoMae,'maestroSiniestro.data');
    reset(archivoMae); //abro mi archivo binario
    assign(texto,'reporteSiniestros.txt');
    rewrite(texto); //creo mi archivo de texto
    while(not EOF(archivoMae)) do begin
        read(archivoMae,r);
        with r do begin
          writeln(texto,' ',nroParNac,' ',nombre,' ',apellido,' ',matriMedicoN);
        end;
    end;
    close(texto);
    close(archivoMae);
end;
{------------------------------------------------------------}
{ pp }
var
	i:integer;
    iString:String;
    vectorArcF:vecDetalleFall; vectorArcN:vecDetalleNaci; // vector de archivos
    vectorRegF:vecRegFall; vectorRegN:vecRegNaci; //vector de registros
    mae:maestroA;
begin
	for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArcN[i],'detalleN'+iString);
        reset(vectorArcN[i]); //habilito lectura todos los archivos
        LeerN(vectorArcN[i],vectorRegN[i]);
    end;
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArcF[i],'detalleF'+iString);
        reset(vectorArcF[i]); //habilito lectura todos los archivos
        LeerF(vectorArcF[i],vectorRegF[i]);
    end;
    crearMaestro(vectorArcF, vectorRegF, mae, vectorArcN, vectorRegn);
	ExportarATxtMaestro(mae);
end.
