function [unomenosalfa, intizqda, intderecha] = calidad( tolrelativa, num, sum, sumcuadrado)
% Calcula el intervalo de confianza asociado a las muestras y
% Devuelve la probabilidad asociada al intervalo de confianza 

%CALCULO DE X(n) y S(n)
mediaMuestral=(1/num)*sum;
cuasivarianzaMuestral=(1/(num-1))*(sumcuadrado-sum^2/num)
%CALCULO DE LA TOLERANCIA t
t=tolrelativa*mediaMuestral;
%CALCULO DE z_alpha
z_alpha=t/sqrt(cuasivarianzaMuestral/num);
%CALCULO DE 1-alpha
unomenosalfa = 1 - (1 - normcdf(z_alpha))*2;
%CALCULO DEL INTERVALO
intizqda=mediaMuestral-t;
intderecha=mediaMuestral+t;
end
