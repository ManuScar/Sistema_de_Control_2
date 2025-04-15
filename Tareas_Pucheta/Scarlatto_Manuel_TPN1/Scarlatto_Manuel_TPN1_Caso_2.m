close all, clear all, clc
%% Item [4]
% Parámetros del motor
L_AA = 366e-6;
R_A = 55.6;
J = 5e-9;
B = 0;
K_i = 6.49e-3;
K_m = 6.53e-3;
v_a = 12;

% Condiciones iniciales
i_a = 0;
omega = 0;
theta = 0;

% Tiempo de simulación
T_total = 5;
dt = 1e-7;
N = T_total / dt;

% Barrido de TL
TL_vals = linspace(1.4e-3, 1.42e-3, 100);
ultima_omega_pos = 0;
ultimo_TL = TL_vals(1);

for TL = TL_vals
    i_a = 0; omega = 0; theta = 0;
    for k = 1:N
        di_a = (-R_A * i_a - K_m * omega + v_a) / L_AA;
        domega = (K_i * i_a - B * omega - TL) / J;
        dtheta = omega;
        i_a = i_a + dt * di_a;
        omega = omega + dt * domega;
        theta = theta + dt * dtheta;
    end
    if omega <= 0
        fprintf("Torque de carga máximo estimado: %.10f Nm\n", ultimo_TL);
        break
    else
        ultima_omega_pos = omega;
        ultimo_TL = TL;
    end
end

% Simulación final con TL óptimo
i_a = 0; omega = 0; theta = 0;
i_a_vec = zeros(1, N);
omega_vec = zeros(1, N);
theta_vec = zeros(1, N);
t = (0:N-1) * dt;

for k = 1:N
    i_a_vec(k) = i_a;
    omega_vec(k) = omega;
    theta_vec(k) = theta;
    di_a = (-R_A * i_a - K_m * omega + v_a) / L_AA;
    domega = (K_i * i_a - B * omega - ultimo_TL) / J;
    dtheta = omega;
    i_a = i_a + dt * di_a;
    omega = omega + dt * domega;
    theta = theta + dt * dtheta;
end

% Gráficas
figure;
subplot(3,1,1);
plot(t, i_a_vec, 'r');
title('Corriente de armadura i_a(t)');
xlabel('Tiempo [s]');
ylabel('Corriente [A]');
grid on;

subplot(3,1,2);
plot(t, omega_vec, 'b');
title('Velocidad angular \omega(t)');
xlabel('Tiempo [s]');
ylabel('Velocidad [rad/s]');
grid on;

subplot(3,1,3);
plot(t, theta_vec, 'g');
title('Posición angular \theta(t)');
xlabel('Tiempo [s]');
ylabel('Posición [rad]');
grid on;

% Mostrar resultados 
fprintf("Valor máximo de i_a(t): %.4f A\n", max(i_a_vec));
fprintf("Valor máximo de omega(t): %.4f rad/s\n", max(omega_vec));
fprintf("Valor máximo de theta(t): %.4f rad\n", max(theta_vec));
%% Item [5]
T=0.6; Kmax = 10000; At=T/Kmax ; t = 0:At:T-At;
u=zeros(1,10000);
for i=340:1:10000
        u(1,i)=12;
end
figure
plot(t,u);title('u')
%Importo los valores de la tabla para graficarlos
datos=xlsread('Curvas_Medidas_Motor_2025.xls')
figure
plot(datos(:,1),datos(:,2));title('wr');hold on;%grafico wr (1 colum es tiempo y la 2 es wr)
figure
plot(datos(:,1),datos(:,3));title('ia');hold on;%grafico corriente(3er columna de la tabla) y tiempo
