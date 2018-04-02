%% ESQUELETO DE SIMULACION

listaEV = [];         % Lista vacia al comienzo
                      
                      
t_simulacion = 0.0;   % Reloj de simulación


pasos = 1000         % Numero de iteraciones del simulador


% ACCIONES DE INCIO: p.ej. definir estado, generar primeros eventos

% Se proporciona ejemplo del
% Caso cola de trabajos

% TIPOS DE EVENTOS, CADA UNO UN NUMERO DIFERENTE
SALE = 0;
LLEGA = 1;

% ESTADO
N = 0;                
fifoTiempos = [];

% PARAMETROS DE SIMULACION
lambda = 10;
mu = 15;

% VARIABLES PARA EL CALCULO DE LOS PROMEDIOS DE INTERES
summuestrasT = 0;
nummuestrasT = 0;

% PRIMEROS EVENTOS
listaEV = encolarEvento(listaEV, aleatorio_exp(lambda), LLEGA);


for i=1:pasos
    
    [listaEV, tiempo, tipo] = sgteEvento(listaEV);
    
    % Actualizamos el tiempo 
    t_simulacion = tiempo;
    
    switch tipo 
        case LLEGA
            N = N+1;
            taux = aleatorio_exp(lambda);
            listaEV = encolarEvento(listaEV, t_simulacion + taux, LLEGA);
            if N==1 
                taux = aleatorio_exp(mu); % Tiempo en el recurso
                listaEV = encolarEvento(listaEV, t_simulacion + taux, SALE);
            end
            
      %      DESCOMENTAR PARA EJECUCIÓN PASO A PASO     
      %      display('LLEGADA');
      %      [t_simulacion]
      %      pause
            
            fifoTiempos = pushFIFO(fifoTiempos, t_simulacion); % Momento de entrada de la tarea en el sistema
        
        case SALE
            N = N-1;
            if N>0 % Otro trabajo pasa a ocupar el "procesador"
                taux = aleatorio_exp(mu); % Tiempo en el recurso
                listaEV = encolarEvento(listaEV, t_simulacion + taux, SALE);
            end
            [fifoTiempos, tentrada] = popFIFO(fifoTiempos);
        
       %     DESCOMENTAR PARA EJECUCIÓN PASO A PASO     
       %     display('SALE');
       %     [t_simulacion, tentrada, t_simulacion-tentrada]
       %     pause
            
            summuestrasT = summuestrasT + (t_simulacion - tentrada);
            nummuestrasT = nummuestrasT + 1;
    end
end

% Mostramos los promedios calculador
display('FIN DE LA SIMULACION');
[i, summuestrasT, nummuestrasT]
T = summuestrasT / nummuestrasT
    