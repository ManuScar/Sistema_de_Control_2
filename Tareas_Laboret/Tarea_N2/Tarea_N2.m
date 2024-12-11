%Tarea N-2
%Profesor: Laboret, Sergio
%Alumno: Scarlatto, Manuel
%Materia: Sistema de Control 2
%%
clear all; close all; clc;
%Datos de la Tarea
z1=-10; p1=-2; p2=-1; K=5; S=5; Tr=4; Tm=0.30;
%Obtener los valores de Z, Wo y Wd
Xi=(-log(S/100))/sqrt(pi^(2)+log(S/100)^(2))
Wo=4/(Xi*Tr)
Wd=Wo*sqrt(1-Xi^2)
Td=2*pi/Wd
%Cantidad de Muestras por ciclo de la frecuencia amortiguada Wd
m=Td/Tm
%Equivalencias de planos s y z
r=exp(-Xi*Wo*Tm)
Omega=(Wd*Tm)*(180/pi)
%Coordenadas rectangulares
real_part=r*cos(Omega)
imag_part=r*sin(Omega)
R=real_part+j*imag_part
%Funciones de Transferencias, Sisotool
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
sisotool(Gd)
% %Una vez obtenido el compensador, en el comando debo ejecutar este codigo
% C %muestra el compensador importado de sisotool
% F=feedback(C*Gd,1) % sistema de lazo cerrado
% pole(F)
% zero(F)
% pzmap(F)
% step(F) % respuesta al escalon
