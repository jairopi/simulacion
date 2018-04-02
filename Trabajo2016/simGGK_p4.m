%% SIMULADOR COLAS G/G/K

listaEV = [];           % Lista vacia al comienzo
                                           
t_simulacion = 0.0;     % Reloj de simulación

k = 1;                  % Numero de recursos del sistema 

t_muestreoN = 0.5;      % Segundos entre cada muestra de N

delta = 100;             % Numero de muestras por bloque

H = 10000;                % Numero de muestras iniciales descartadas

t_relativa = 0.05;      % Tolerancia relativa. Suele estar entre el 1% y el 10%

calidad_buscada = 0.99; % Suele estar entre el 90% y el 99%

pasos = 0;              % Numero de iteraciones del simulador


%VARIABLES ALEATORIAS
%PARAMETROS DE SIMULACION
Z=1;
        
tipoX=2;
param1X=10;         % lambda (tasa de llegada), si tipoX=2
param2X=0;

tipoS=2;
param1S=15;         % mu (tasa de servicio), si tipoS=2
param2S=0;

% TIPOS DE EVENTOS, CADA UNO UN NUMERO DIFERENTE
SALE = 0;
LLEGA = 1;
SUMAN = 2;

% ESTADO
N = 0;              %N:número de tareas en el sistema (Se inicializa a 0)   
fifoTiempos = [];   %Cola FIFO del sistema

% VARIABLES PARA EL CALCULO DE LOS PROMEDIOS DE INTERES
summuestrasT = 0;
nummuestrasT = 0;
sumcuadradoT = 0;
summuestrasT_b = 0;
nummuestrasT_b = 0;
descartadas = 0;

summuestrasN = 0;   % Suma de todos los valores de N muestreados
nummuestrasN = 0;   % Numero de muestras de N tomadas
numLLegadas = 0;

% PRIMEROS EVENTOS
[Z,taux] = aleatorio(Z,tipoX,param1X,param2X);
listaEV = encolarEvento(listaEV, taux, LLEGA, 0); %Programación de evento de llegada
if H==0 % Si no hay que descartar tareas, se programa el primer evento de muestreo de n
    listaEV = encolarEvento(listaEV, t_muestreoN, SUMAN, -1, -1, -1); %Programación de evento de muestreo de N
end

while true
    
    pasos = pasos + 1;
    
    % Salto al siguiente evento programado en la lista de eventos
    [listaEV, tiempoEvento, tipo, tiempoLLegada] = sgteEvento(listaEV);
    
    % Actualizacion del tiempo de simulación.
    t_simulacion = tiempoEvento;
    
    switch tipo 
        case LLEGA % EL EVENTO ACTUAL ES UNA LLEGADA
            N = N+1; % Hay una tarea más en el sistema
            numLLegadas = numLLegadas +1;
            [Z,taux] = aleatorio(Z,tipoX,param1X,param2X);
            listaEV = encolarEvento(listaEV, t_simulacion + taux, LLEGA, 0);
            if numLLegadas == H % Se programa el primer evento de muestreo de N al programar la tarea H+1.
                listaEV = encolarEvento(listaEV, t_muestreoN, SUMAN, 0); %Programación de evento de muestreo de N
            end                
            if N<=k % Se programa una salida si la tarea pasa a uno de los K recursos directamente
                [Z,taux] = aleatorio(Z,tipoS,param1S,param2S);
                listaEV = encolarEvento(listaEV, t_simulacion + taux, SALE, t_simulacion);
            else % En caso contrario, la tarea entra en la cola
                fifoTiempos = pushFIFO(fifoTiempos, t_simulacion);
            end     
        case SALE % EL EVENTO ACTUAL ES UNA SALIDA
            N = N-1; % Hay una tarea menos en el sistema
            if N>=k % Hay tareas en cola. Se programa la salida de la tarea que entra al recurso
                [fifoTiempos, tentrada] = popFIFO(fifoTiempos); % La tarea sale de la cola FIFO y entra al recurso
                [Z,taux] = aleatorio(Z,tipoS,param1S,param2S);
                listaEV = encolarEvento(listaEV, t_simulacion + taux, SALE, tentrada);
            end 
            if descartadas==H
                summuestrasT_b = summuestrasT_b + (t_simulacion - tiempoLLegada);
                nummuestrasT_b = nummuestrasT_b+1;
                if nummuestrasT_b==delta  
                    Tmedio_b = summuestrasT_b/nummuestrasT_b;
                    summuestrasT = summuestrasT + Tmedio_b;
                    nummuestrasT = nummuestrasT + 1;
                    sumcuadradoT = sumcuadradoT + Tmedio_b^2;
                    summuestrasT_b = 0;
                    nummuestrasT_b = 0;
                end
            else
                descartadas=descartadas+1;
            end
        case SUMAN % EL EVENTO ACTUAL ES DE MEDICIÓN DE N. Cada "t_muestreoN" u.t. se produce este evento.
            nummuestrasN=nummuestrasN+1;
            summuestrasN=summuestrasN+N;
            listaEV = encolarEvento(listaEV, t_simulacion + t_muestreoN, SUMAN, 0);  
    end
    [unomenosalfa, intizqda, intderecha] = calidad( t_relativa, nummuestrasT, summuestrasT, sumcuadradoT);
    if (unomenosalfa >= calidad_buscada) 
        break; % FIN SIMULACION
    end
    % SI MEDIMOS VARIOS PROCESOS DEBEMOS OBTENER LA CALIDAD DE CADA UNO Y EL 
    % IF DEBE COMPROBAR SI LA CALIDAD ES MAYOR A LA DESEADA PARA CADA PROCESO
    
end


Tmedio = summuestrasT / nummuestrasT;   % Tiempo medio de respuesta del sistema
Nmedio = summuestrasN / nummuestrasN;   % Numero medio de usuarios en el sistema

% Mostramos los promedios calculador
display('########FIN DE LA SIMULACION########');
display(strcat('>Iteraciones=',num2str(pasos)));
display(strcat('>summuestrasT=',num2str(summuestrasT)));
display(strcat('>nummuestrasT=',num2str(nummuestrasT)));
display(strcat('>T=',num2str(Tmedio)));
display(strcat('>summuestrasN=',num2str(summuestrasN)));
display(strcat('>nummuestrasN=',num2str(nummuestrasN)));
display(strcat('>N=',num2str(Nmedio)));
display(strcat('P(',num2str(intizqda),'<=T<=',num2str(intderecha),')=',num2str(unomenosalfa)));

