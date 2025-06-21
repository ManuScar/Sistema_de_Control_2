close all, clear all, clc
%% Item [4]
L_AA = 366e-6;      % Inductancia de armadura (H)
R_A = 55.6;         % Resistencia de armadura (Ohm)
J = 5e-9;           % Momento de inercia (kgï¿½m^2)
B = 0;              % Coeficiente de fricciï¿½n (despreciable)
K_i = 6.49e-3;      % Constante de torque (Nï¿½m/A)
K_m = 6.53e-3;      % Constante de fuerza contraelectromotriz (Vï¿½s/rad)
%T_L = 0;
T_L = 1.4007e-3;    % Torque de carga (Nï¿½m)
v_a = 12;           % Voltaje de entrada (V)

% Condiciones iniciales
i_a = 0;            % Corriente de armadura inicial (A)
omega = 0;          % Velocidad angular inicial (rad/s)
theta = 0;          % Posiciï¿½n angular inicial (rad)

% Tiempo de simulaciï¿½n
T_total = 5;        % Tiempo total de simulaciï¿½n (s)
dt = 1e-7;          % Paso de tiempo (s)
N = T_total / dt;   % Nï¿½mero de pasos de simulaciï¿½n

% Prealocaciï¿½n de vectores para almacenar resultados
t = zeros(1, N);
i_a_vec = zeros(1, N);
omega_vec = zeros(1, N);
theta_vec = zeros(1, N);

% Simulaciï¿½n utilizando el mï¿½todo de Euler
for k = 1:N
    % Almacenar resultados actuales
    t(k) = (k-1) * dt;
    i_a_vec(k) = i_a;
    omega_vec(k) = omega;
    theta_vec(k) = theta;
    
    % Cï¿½lculo de derivadas
    di_a = (-R_A * i_a - K_m * omega + v_a) / L_AA;
    domega = (K_i * i_a - B * omega - T_L) / J;
    dtheta = omega;
    
    % Actualizaciï¿½n de variables utilizando el mï¿½todo de Euler
    i_a = i_a + dt * di_a;
    omega = omega + dt * domega;
    theta = theta + dt * dtheta;
end

% Grï¿½ficas de resultados
figure;
subplot(3,1,1);
plot(t, theta_vec, 'g');
title('Posiciï¿½n angular \theta(t)');
grid on;


subplot(3,1,2);
plot(t, omega_vec, 'b');
title('Velocidad angular w(t)');
grid on;

subplot(3,1,3);
plot(t, i_a_vec, 'r');
title('i_a(t)');
xlabel('Tiempo [s]');
grid on;

% Mostrar valores mï¿½ximos
fprintf('Valor mï¿½ximo de i_a(t): %.4f A\n', max(i_a_vec));
fprintf('Valor mï¿½ximo de w(t): %.4f rad/s\n', max(omega_vec));
fprintf('Valor mï¿½ximo de theta(t): %.4f rad\n', max(theta_vec));

%% Item [5]
% Lectura de los datos
archivo = 'Curvas_Medidas_Motor_2025_v.xls';
hoja = 'Hoja1';
% Rangos parciales
rango1 = 'A102:A700';
rango2 = 'B102:B700';
rango3 = 'C102:C700';
t_parcial = xlsread(archivo, hoja, rango1); 
w_parcial = xlsread(archivo, hoja, rango2);  
i_parcial = xlsread(archivo, hoja, rango3);

% Rangos totales
rango_tot1 = 'A1:A1500';
rango_tot2 = 'B1:B1500';
rango_tot3 = 'C1:C1500';
t_tot = xlsread(archivo, hoja, rango_tot1); 
w_tot = xlsread(archivo, hoja, rango_tot2);
i_tot = xlsread(archivo, hoja, rango_tot3);

% Escalon de amplitud 2V
opt = stepDataOptions;
opt.StepAmplitude = 2;
K = w_parcial(end) / opt.StepAmplitude;

% Tiempos auxiliares
t_sim = xlsread(archivo, hoja, 'A700') - xlsread(archivo, hoja, 'A102'); % Tiempo de simulaciï¿½n
t_ret = 0.102; % Retardo
t_inic = 0.04; % Primera muestra

% Obtenciï¿½n de 3 puntos
[val, lugar] = min(abs(t_inic - t_parcial + t_ret));
t_t1 = t_parcial(lugar);
y_t1 = w_parcial(lugar);

[val, lugar] = min(abs(2 * t_inic - t_parcial + t_ret));
t_2t1 = t_parcial(lugar);
y_2t1 = w_parcial(lugar);

[val, lugar] = min(abs(3 * t_inic - t_parcial + t_ret));
t_3t1 = t_parcial(lugar);
y_3t1 = w_parcial(lugar);

ii = 0; 
ii = ii + 1;

% Calculo de parametros (Chen)
k1 = (1 / opt.StepAmplitude) * y_t1 / K - 1; 
k2 = (1 / opt.StepAmplitude) * y_2t1 / K - 1;
k3 = (1 / opt.StepAmplitude) * y_3t1 / K - 1;
be = 4 * k1^3 * k3 - 3 * k1^2 * k2^2 - 4 * k2^3 + k3^2 + 6 * k1 * k2 * k3;
alfa1 = (k1 * k2 + k3 - sqrt(be)) / (2 * (k1^2 + k2));
alfa2 = (k1 * k2 + k3 + sqrt(be)) / (2 * (k1^2 + k2));
beta = (k1 + alfa2) / (alfa1 - alfa2);

T1_ang = -(t_t1 - t_ret) / log(alfa1);
T2_ang = -(t_t1 - t_ret) / log(alfa2);
T3_ang = beta * (T1_ang - T2_ang) + T1_ang;
T1(ii) = T1_ang;
T2(ii) = T2_ang;
T3(ii) = T3_ang;
T3_ang = sum(T3 / length(T3));
T2_ang = sum(T2 / length(T2));
T1_ang = sum(T1 / length(T1));

% Funcion de transferencia identificada
num = [T3_ang 1];
den = conv([T1_ang 1], [T2_ang 1]);
disp('Funcion de transferencia identificada')
sys_G_ang = tf(K * num, den);
[y_ang, t_ang] = step(sys_G_ang, opt, t_sim);

% Grafica de ia
figure(1);
hold on;
plot(t_tot, i_tot, 'b'); grid on;
title('Corriente de armadura');

% FT calculada (no se grafica)
disp('Funcion de transferencia calculada')
num_calc = 0.2656; 
den_calc = [6.5615e-4 17.1985e-3 0.0705];
Gcalc = tf(num_calc, den_calc);
[y_calc, t_calc] = step(Gcalc, opt, t_sim);

% Grafica de velocidad angular (sin la curva calculada)
figure(2);
plot(t_parcial, w_parcial, 'b'); grid on; hold on;
plot(t_ang + t_ret, y_ang, 'g'); hold on;
title('Velocidad angular, w[rad/s]');
plot(t_t1, y_t1, 'xb');
plot(t_2t1, y_2t1, 'xb');
plot(t_3t1, y_3t1, 'xb');
legend('Velocidad angular original', 'Velocidad angular identificada', 'Puntos de muestreo');

%% Item [6]
% close all; clear; clc;
% Planta identificada (Chen)
num = 0.2656;
den = [6.5615e-4, 17.1985e-3, 0.0705];
G = tf(num, den);

% Cargar datos reales desde Excel
filename = 'Curvas_Medidas_Motor_2025_v.xls';
TL_data = xlsread(filename, 'Hoja1', 'E1:E1500');   % torque medido
t_real = xlsread(filename, 'Hoja1', 'A1:A1500');    % tiempo real
Ts = t_real(2) - t_real(1);                         % paso de muestreo real
t = t_real;                                         % usamos exactamente ese tiempo

% Discretización de la planta (Tustin)
Gd = c2d(G, Ts, 'tustin');

% Valores iniciales sugeridos en el enunciado (sin perturbación):
% Kp = 0.1;
% Ki = 0.01;
% Kd = 5;
% Estos valores funcionaban correctamente cuando el sistema
% no estaba afectado por el torque de carga T_L(t).

% Controlador PID ajustado para referencia de 1 rad
Kp = 2;
Ki = 5;
Kd = 0.1;
N = 10;

C = pidstd(Kp, Ki, Kd, N, Ts, 'IFormula', 'Trapezoidal', 'DFormula', 'BackwardEuler');

% Entrada de referencia: escalón unitario
r = ones(size(t));

% Inicialización de variables
y = zeros(size(t));
e = zeros(size(t));
u = zeros(size(t));
e_prev = 0; I = 0; D = 0;

% Estado de la planta discreta
[A,B,Cd,Dd] = ssdata(Gd);
x = zeros(size(A,1),1);

% Simulación discreta con torque real
for k = 2:length(t)
    e(k) = r(k) - y(k-1);

    % PID
    I = I + (e(k) + e_prev)/2 * Ts;
    D = (e(k) - e_prev)/Ts;
    u(k) = Kp*e(k) + Ki*I + Kd*D;
    e_prev = e(k);

    % Saturación
    u(k) = max(min(u(k), 24), -24);

    % Torque real como perturbación negativa
    u_total = u(k) - TL_data(k);

    % Dinámica
    x = A*x + B*u_total;
    y(k) = Cd*x + Dd*u_total;
end

% Gráficas
figure;

subplot(2,1,1);
plot(t, y, 'b', 'LineWidth', 1.2); hold on;
plot(t, r, '--k');
ylabel('\theta [rad]');
title('Respuesta angular con PID discreto (tiempo real de Excel)');
legend('Salida del sistema', 'Referencia');
grid on;

subplot(2,1,2);
plot(t, TL_data, 'k', 'LineWidth', 1.2);
ylabel('T_L [Nm]');
xlabel('Tiempo [s]');
title('Torque de carga real aplicado');
grid on;
