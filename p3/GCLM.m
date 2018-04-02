function  [nuevoZ,m]  = GCLM( Z )
% Usando Z como muestra previa del generador, crea la nueva muestra.
%PARAMETROS FISHMAN & MOORE
a = 48271;
q = 44488;
r = 3399;
m = a*q+r;
if(Z<m)
    nuevoZ = rem(a*Z,m); %rem es el resto de una división
else
    display(strcat('Z debe ser menor que el parametro m: ',int2str(m)));
    nuevoZ = Z;
end
end