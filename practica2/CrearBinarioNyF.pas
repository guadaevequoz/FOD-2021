program CrearBinarioDetalle;
const
    dimF=5;
type
   direccion = record
		calle: integer;
		numero: integer;
		piso: integer;
		depto: integer;
		ciudad: string;
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
	detNaci = file of detalleNac;
	detFall = file of detalleFall;
	vecDetalleNaci = array [1..dimF] of detNaci;
	vecDetalleFall = array [1..dimF] of detFall;
{----------------------------------------------------------------}
procedure LeerDireccion(var d:direccion);
begin
	write('Calle: '); readln(d.calle);
	write('Numero: '); readln(d.numero);
	write('Piso: '); readln(d.piso);
	write('Depto: '); readln(d.depto);
	write('Ciudad: '); readln(d.ciudad);
end;

{--------- LEO DETALLE DE NACIMIENTO -----------}
procedure LeerProductoDetalleN(var n: detalleNaC);
begin
    WriteLn('---PRODUCTO DETALLE NACIMIENTO----');
    write('Partida de nacimiento: '); readln(n.nroParNac);
    if(n.nroParNac <> 9999) then begin
		write('Nomber: '); readln(n.nombre);
        write('Apellido: '); readln(n.apellido);
        LeerDireccion(n.dir);
		write('Matricula del doctor: '); readln(n.matriMedico);
		write('Nombre y apellido de la madre: '); readln(n.nomYApeMadre);
		write('DNI de la madre: '); readln(n.dniMadre);
		write('Nombre y apellido del padre: '); readln(n.nomYApePadre);
		write('DNI del padre: '); readln(n.dniPadre);
    end;
end;

{--------- LEO DETALLE DE FALLECIMIENTO -----------}
procedure LeerProductoDetalleF(var n: detalleFall);
begin
    WriteLn('---PRODUCTO DETALLE FALLECIMIENTO ----');
    write('Partida de nacimiento: '); readln(n.nroParNac);
    if(n.nroParNac <> 9999) then begin
		write('DNI: '); readln(n.dni);
        write('Apellido y nombre: '); readln(n.apeYnom);
		write('Matricula del doctor: '); readln(n.matriMedico);
		write('Fecha y hora de defunción: '); readln(n.fechaYhora);
		write('Lugar: '); readln(n.lugar);
    end;
end;

{----------------------------------------------------------------}
var
    i:integer;
    iString:String;
    vectorArcN:vecDetalleNaci;
    vectorArcF: vecDetalleFall;
    n:detalleNac; f: detalleFall;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArcN[i],'detalleN'+iString);
        rewrite(vectorArcN[i]); //creo mi detalle
        LeerProductoDetalleN(n);
        while (n.nroParNac <> 9999) do begin
            write(vectorArcN[i],n);
            LeerProductoDetalleN(n);
        end;
    end;
    for i:=1 to dimF do 
        close(vectorArcN[i]);
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArcF[i],'detalleF'+iString);
        rewrite(vectorArcF[i]); //creo mi detalle
        LeerProductoDetalleF(f);
        while (n.nroParNac <> 9999) do begin
            write(vectorArcF[i],f);
            LeerProductoDetalleF(f);
        end;
    end;
    for i:=1 to dimF do close(vectorArcF[i]);
end.
