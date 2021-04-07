program crearBinarioDetalles;
const
	dimF = 5;
type
	 productoDet=record
        cod:integer;
        cant_vendida:integer;
    end;
    detalle=file of productoDet;
    vecDetalle=array[1..dimF] of detalle;

procedure LeerProd(var p:productoDet);
begin
	writeln('cod:'); readln(p.cod);
	if(p.cod <> 9999) then begin
		write('Cantidad: '); readln(p.cant);
	end;
end;
