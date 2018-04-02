function [unomenosalfa, intizqda, intderecha] = calidad( tolrelativa, num, sum, sumcuadrado)
% Calcula el intervalo de confianza asociado a las muestras y
% Devuelve la probabilidad asociada al intervalo de confianza 

%Media muestral
x_n=(1/num)*sum;

%Cuasi-varianza muestral
s_n=(1/(num-1))*(sumcuadrado-sum^2/num);

%Tolerancia absoluta
t=tolrelativa*x_n;

%z_alfa
z_alfa=t/sqrt(s_n/num);

%1-alpha
unomenosalfa = 1 - (1 - normcdf(z_alfa))*2;

%intervalo
intizqda=x_n-t;
intderecha=x_n+t;
end
