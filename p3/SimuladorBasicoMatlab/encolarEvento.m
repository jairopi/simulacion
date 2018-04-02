function [ lista_de_eventos ] = encolarEvento( lista_de_eventos, tiempo, tipo, tentrada)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    s = size(lista_de_eventos);
    if isempty(lista_de_eventos)
        % La lista es nueva
        lista_de_eventos = zeros(1,3);
        lista_de_eventos(1,1) = tiempo;
        lista_de_eventos(1,2) = tipo;
         lista_de_eventos(1,3) = tentrada;
        return
    end

    for i=1:s(1)
        if lista_de_eventos(i,1)>tiempo break;
        end
    end

    % Creamos una nueva lista
    newlista = zeros(s(1)+1,3);
    
    % Si el indice es el primer elemento 
    if i-1==0
        if lista_de_eventos(i,1)<tiempo
            % Solo 1 elemento, se inserta a continuacion
            newlista(2,1) = tiempo;
            newlista(2,2) = tipo;
            newlista(2,3) = tentrada;
            newlista(1,:) = lista_de_eventos(1,:);
        else
            % Se inserta antes
            newlista(1,1) = tiempo;
            newlista(1,2) = tipo;
            newlista(1,3) = tentrada;
            newlista(3:size(newlista),:) = lista_de_eventos(:,:);
        end    
    elseif lista_de_eventos(i,1)>tiempo
    % El nuevo evento se inserta por el medio
        newlista(1:i-1,:) = lista_de_eventos(1:i-1,:);
        newlista(i,1) = tiempo;
        newlista(i,2) = tipo;
        newlista(i,3) = tentrada;
        newlista(i+1:size(newlista),:) = lista_de_eventos(i:s(1),:);
    else
    % El nuevo evento se inserta al final
        newlista(1:s(1),:) = lista_de_eventos(1:s(1),:);
        newlista(i+1,1) = tiempo;
        newlista(i+1,2) = tipo;
        newlista(i+1,3) = tentrada;
    end
    
    lista_de_eventos = newlista;
end

