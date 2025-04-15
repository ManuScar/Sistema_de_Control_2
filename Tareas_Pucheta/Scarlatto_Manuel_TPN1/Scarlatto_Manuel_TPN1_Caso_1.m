close all, clear all, clc
%% Item [1]
% Datos de constantes
R = 220;       % 220 ohm
L = 500e-3;    % 500 mH
C = 2.2e-6;    % 2.2 uF

T = 0.01; Kmax = 1000; At = T/Kmax; t = 0:At:(T-At);

% Señal de entrada: escalón que cambia de signo cada 10ms
u = zeros(1, Kmax);
signo = true;
for i = 100:1:Kmax
    if mod(i, Kmax/2) == 0
        signo = not(signo);
    end
    if signo
        u(1, i) = 12;
    else
        u(1, i) = -12;
    end
end

% Matrices para Vc como salida
A = [-R/L  -1/L; 1/C 0];
B = [1/L; 0];
c = [0 1];  % Vc salida
D = 0;

sys1 = ss(A, B, c, D);  % Modelo en espacio de estados
figure(1)
y = lsim(sys1, u, t);
plot(t, y);
title('Vc');
grid on;
hold on;

figure(2)
plot(t, u);
title('Entrada, u');
hold on;

% Matrices para corriente como salida
c2 = [1 0];  % Corriente salida
sys2 = ss(A, B, c2, D);
figure
[yout, x] = lsim(sys2, u, t);
plot(x, yout, 'r');
title('Corriente');
hold on;

%% Item [2]
T=0.0001; Kmax = 1000; At=T/Kmax ; t = 0:At:T-At;
%creo el escalon que cambie de signo cada 1ms 
u=zeros(1,1000);
signo=true;
for i=100:1:1000
    if mod(i,500)==0
        signo = not(signo);
    end
    if signo==1
        u(1,i)=12;
    end
    if signo==0
        u(1,i)=-12;
    end
end
plot(t,u);

%Importo los valores de la tabla para graficarlos
datos=xlsread('Curvas_Medidas_RLC_2025.xls')
figure
plot(datos(:,1),datos(:,2));%grafico corriente (1 colum es tiempo y la 2 es corriente)
figure
plot(datos(:,1),datos(:,3));%grafico tension(3er columna de la tabla) y tiempo 

%Codigo de Chen
ii=0; % for t_inic=10:15
ii=ii+1;

t1=0.001; %Es el punto 0.012 pero le resto 0.01 que es el tiempo muerto		
y_t1=2.20329864283873;  %valor para el tiempo 0.011
t2=0.002; 	
y_2t2=4.03996654178157;%valor para el tiempo 0.0102
t3=0.003; 
y_3t3=5.53229925605113;%valor para el tiempo 0.0103

StepAmplitude = 1;
y_end=12;
K=y_end/StepAmplitude;  %calculo los coeficientes
k1=((1/StepAmplitude)*y_t1/K)-1; 
k2=((1/StepAmplitude)*y_2t2/K)-1;
k3=((1/StepAmplitude)*y_3t3/K)-1;
be=4*k1^3*k3-3*k1^2*k2^2-4*k2^3+k3^2+6*k1*k2*k3;
alfa1=(k1*k2+k3-sqrt(be))/(2*(k1^2+k2));
alfa2=(k1*k2+k3+sqrt(be))/(2*(k1^2+k2));
beta=(2*k1^3+3*k1*k2+k3-sqrt(be))/(sqrt(be));

T1_ang=-t1/log(alfa1);
T2_ang=-t1/log(alfa2);
T3_ang=beta*(T1_ang-T2_ang)+T1_ang;
T1(ii)=T1_ang;
T2(ii)=T2_ang;
T3(ii)=T3_ang;
T3_ang=sum(T3/length(T3));
T2_ang=sum(T2/length(T2));
T1_ang=sum(T1/length(T1));

sys_G_ang=tf(K,conv([T1_ang 1],[T2_ang 1]))

figure
[yaprox,taprox]=lsim(sys_G_ang,u/12,t);
plot(datos(:,1),datos(:,3),'b');title('Vc');hold on
plot(0.0101,y_t1,'x')
hold on
plot(0.0102,y_2t2,'x')
plot(0.0103,y_3t3,'x')
plot(taprox,yaprox);
%% Item [3]
% Parámetros del circuito
R = 220;           
L = 0.0851364 ;           
C = 2.2e-06; 

% Tiempo de simulación
T = 0.2;             % Tiempo total: 200 ms
Kmax = 20000;        % Cantidad de muestras
At = T / Kmax;       % Paso temporal
t = 0:At:(T-At);     % Vector de tiempo

% Entrada escalón alternante ±12 V cada 10 ms
u = zeros(1, Kmax);
signo = true;
for i = 1:Kmax
    if mod(i, 1000) == 1   % Cada 10 ms ? 1000 pasos
        signo = ~signo;
    end
    u(i) = 12 * (2*signo - 1);  % 12 o -12
end

% Matrices del sistema (modelo en espacio de estados)
A = [-R/L  -1/L; 1/C   0 ];
B = [1/L; 0];
C_i = [1 0];       % Observamos la corriente
C_vc = [0 1];      % Observamos tensión en el capacitor
D = 0;

% Sistema para i(t)
sys_i = ss(A, B, C_i, D);
i_out = lsim(sys_i, u, t);

% Sistema para v_C(t)
sys_vc = ss(A, B, C_vc, D);
v_c_out = lsim(sys_vc, u, t);

% Graficar resultados
figure;
subplot(3,1,1);
plot(t, u); title('Entrada: v_e(t)'); ylabel('[V]'); grid on;

subplot(3,1,2);
plot(t, i_out, 'r'); title('Corriente i(t)'); ylabel('[A]'); grid on;

subplot(3,1,3);
plot(t, v_c_out, 'b'); title('Tensión en el capacitor v_C(t)'); ylabel('[V]'); xlabel('Tiempo [s]');grid on;
