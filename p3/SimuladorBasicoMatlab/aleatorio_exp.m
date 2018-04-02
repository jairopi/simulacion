function [ x ] = aleatorio_exp( lambda )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

    if lambda<=0
            stop('Lambda debe ser positivo')
    else
            x=-log(rand())/lambda;
    end
end

