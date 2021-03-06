%% ESQUELETO DE SIMULACION

listaEV = [];           % Lista vacia al comienzo
                      
                      
t_simulacion = 0.0;     % Reloj de simulación


pasos = 100000;          % Numero de iteraciones del simulador


k = 5;                 % Numero de recursos del sistema 



%VARIABLES ALEATORIAS
%PARAMETROS DE SIMULACION
X=2452;        %V.A.: tiempo entre llegadas    (lambda)        
tipoX=3;
param1X=40;     % lambda
param2X=5;

S=9876;       %V.A.: tiempo en procesarse      (mu)
tipoS=2;
param1Saux=10:100;     % mu
param2S=0;



% ACCIONES DE INCIO: p.ej. definir estado, generar primeros eventos

% Se proporciona ejemplo del
% Caso cola de trabajos

% TIPOS DE EVENTOS, CADA UNO UN NUMERO DIFERENTE
SALE = 0;
LLEGA = 1;

Tvector=zeros(1,length(param1Saux));
indice=0;

for param1S=param1Saux;
    indice=indice+1;
    
    % ESTADO
    N = 0;                
    fifoTiempos = [];


    % VARIABLES PARA EL CALCULO DE LOS PROMEDIOS DE INTERES
    summuestrasT = 0;
    nummuestrasT = 0;

    summuestrasN = 0;
    nummuestrasN = 1;

    % PRIMEROS EVENTOS
    [X,taux] = aleatorio(X,tipoX,param1X,param2X);
    listaEV = encolarEventoGGK(listaEV, taux, LLEGA, 0);



    for i=1:pasos
    
        [listaEV, tiempoEvento, tipo, tiempoAux] = sgteEventoGGK(listaEV);
    
        % Actualizamos el tiempo 
        t_simulacion = tiempoEvento;
    
        switch tipo 
            case LLEGA
                N = N+1;
                fifoTiempos = pushFIFO(fifoTiempos, t_simulacion); % Momento de entrada de la tarea en el sistema
                %tiempoSalida = fifoTiempos(length(fifoTiempos));
                [X,taux] = aleatorio(X,tipoX,param1X,param2X);
                listaEV = encolarEventoGGK(listaEV, t_simulacion + taux, LLEGA, 0);
                if N<=k %Programo la salida si la petición pasa al recurso directamente (si no, va a la cola)
                    [S,taux] = aleatorio(S,tipoS,param1S,param2S); % Tiempo en el recurso
                    [fifoTiempos, tentrada] = popFIFO(fifoTiempos);
                    listaEV = encolarEventoGGK(listaEV, t_simulacion + taux, SALE, tentrada);  
                end
               
        
            case SALE
                N = N-1;
             %[fifoTiempos, tentrada] = popFIFO(fifoTiempos,tiempoAux);
                if N>=k % Hay peticiones que cursar. Se programa la salida que ocupara el recurso libre
                    [S,taux] = aleatorio(S,tipoS,param1S,param2S); % Tiempo en el recurso
                    [fifoTiempos, tentrada] = popFIFO(fifoTiempos);
                    listaEV = encolarEventoGGK(listaEV, t_simulacion + taux, SALE, tentrada);
                end 
                summuestrasT = summuestrasT + (t_simulacion - tiempoAux);
                nummuestrasT = nummuestrasT + 1;
         
            
        end
    end
    Tvector(indice) = summuestrasT / nummuestrasT;
 
end
figure;
stem(param1Saux,Tvector);
title(' Tiempo medio de respuesta en función de mu (tasa de servicio)')
xlabel('Valores de mu');
ylabel('Tiempo medio de respuesta del sistema');


    
