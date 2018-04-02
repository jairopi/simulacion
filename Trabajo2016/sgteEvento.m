function [ lista_de_eventos, tiempoEvento, tipo, tiempoAux] = sgteEvento( lista_de_eventos )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    s = size(lista_de_eventos);
    if isempty(lista_de_eventos) 
        % La lista esta vacia
        tiempoEvento = 0;
        tipo = -1;
        tiempoAux = 0;
        return
    end

    tiempoEvento = lista_de_eventos(1,1);
    tipo = lista_de_eventos(1,2);
    tiempoAux = lista_de_eventos(1,3);
    
    if s(1)==1
    % La lista se va a quedar vacia

        lista_de_eventos = [];
        return
    end
    
    % Creamos una nueva lista
    newlista = zeros(s(1)-1,3);
    newlista(1:s(1)-1,:) = lista_de_eventos(2:s(1),:);
    
    lista_de_eventos = newlista;
end