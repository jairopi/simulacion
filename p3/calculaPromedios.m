function [retardo, usuarios] = calculaPromedios( tipoCola, lambda, mu, k )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    switch tipoCola
        case 0 %Sistema M/M/1
            rho = lambda/mu;
            retardo = 1/(mu*(1-rho));
            usuarios = rho/(1-rho);
            
        case 1 %Sistema M/M/k
            i = lambda/mu;
            rho = i/k;
            sum = 0;
            for n = 0:k-1
                sum = sum+i^n/factorial(n)
            end
            p0 = (i^k/factorial(k)*(1-rho)+sum)^(-1)
            retardo = (k*rho)^(k+1)*p0/(lambda*k*factorial(k)*(1-rho)^2)+1/mu;
            usuarios = k*rho+(k*rho)^(k+1)*p0/(k*factorial(k)*(1-rho)^2);
            
        case 2 %Sistema M/D/1
            rho = lambda/mu;
            retardo = rho/(2*mu*(1-rho))+1/mu;
            usuarios = rho+rho^2/(2*(1-rho));
            
    end
    display(strcat('Tiempo de respuesta medio teórico-->',num2str(retardo)));
    display(strcat('Número medio de tareas teórico-->', num2str(usuarios)));
end

