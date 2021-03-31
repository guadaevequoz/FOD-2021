program CrearBinarioDetalle;
const
    dimF=3;
type
    productoDet=record
        cod:integer;
        cant_vendida:integer;
    end;
    detalle=file of productoDet;
    vecDetalle=array[1..dimF] of detalle;
{----------------------------------------------------------------}

procedure LeerProductoDetalle(var p:productoDet);
begin
    WriteLn('---PRODUCTO DETALLE----');
    write('Codigo: ');
    readln(p.cod);
    if(p.cod <> 9999) then begin
        write('Cantidad vendida: ');
        readln(p.cant_vendida);
    end;
end;

{----------------------------------------------------------------}
var
    i:integer;
    iString:String;
    vectorArc:vecDetalle;
    p:productoDet;
begin
    for i:=1 to dimF do begin
        Str(i,iString);
        assign(vectorArc[i],'detalle'+iString);
        rewrite(vectorArc[i]); //creo mi detalle
        LeerProductoDetalle(p);
        while (p.cod <> 9999) do begin
            write(vectorArc[i],p);
            LeerProductoDetalle(p);
        end;
    end;
    for i:=1 to dimF do
        close(vectorArc[i]);
end.