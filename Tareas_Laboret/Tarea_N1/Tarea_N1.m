%Tarea N-1
%Profesor: Laboret, Sergio
%Alumno: Scarlatto, Manuel
%Materia: Sistema de Control 2
%%Lazo Abierto
clear all; close all; clc;
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
Gd1=c2d(G,10*Tm,'zho')     %FT de tiempo discreto Gd1(s) - Aumento 10 veces el Tm
%Graficas de las FT
figure('Name', 'Mapa de Polos-Zeros de FT tiempo Continuo'), pzmap(G);        
figure('Name', 'Mapa de Polos-Zeros de FT tiempo Discreto'), pzmap(Gd);
figure('Name', 'Mapa de Polos-Zeros de FT tiempo Discreto (10xTm)'), pzmap(Gd1);
%Graficas de los escalones
figure('Name', 'Respuesta al Escalon Tiempo Continuo'), step(G);
figure('Name', 'Respuesta al Escalon Tiempo Discreto'), step(Gd);
%%Sistema Discreto
Kp=dcgain(Gd), F=feedback(Gd,1), figure('Name', 'Respuesta al Escalon'), step(F) %Constante de error de posición
t=0:Tm:100*Tm; %Genera Rampa
figure('Name', 'Rampa de entrada'), lsim(F,t,t);
%%Lazo cerrado con realimentación unitaria
figure('Name', 'Lugar de Raices - FT Tiempo Continuo'),rlocus(G);
figure('Name', 'Lugar de Raices - FT Tiempo Discreto'),rlocus(Gd);
figure('Name', 'Lugar de Raices - FT Tiempo Discreto (10xTm)'),rlocus(Gd1);