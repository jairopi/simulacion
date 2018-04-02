function [Z, muestra] = aleatorio(Z, tipo, param1, param2)
[Z,m]=GCLM(Z);
switch tipo
    case 0
    % TIPO = 0 -> VA uniforme [0,1]
        muestra=Z/m;
    case 1
    % TIPO = 1 -> VA uniforme [param1, param2]
        muestra=Z*(param2-param1)/m + param1;
    case 2
    % TIPO = 2 -> VA exponencial lambda=param1
        if param1<=0
            stop('Lambda debe ser positivo')
        else
            muestra=-log(Z/m)/param1;
        end
    case 3
    % TIPO = 3 -> Devuelve siempre param1 (VA â€œdegeneradaâ€?)
        muestra=param1;    
end
end