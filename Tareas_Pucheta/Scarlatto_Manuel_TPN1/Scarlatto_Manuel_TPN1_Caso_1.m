close all, clear all, clc
%% Item [1]
% Datos de constantes
R = 220;       % 220 ohm
L = 500e-3;    % 500 mH
C = 2.2e-6;    % 2.2 uF

T=0.2; Kmax = 20000; At=T/Kmax; t= 0:At:(T-At);
%hago que el escalon que cambie de signo
u = zeros(1, Kmax);
signo = true;
for i = 1:Kmax
    if mod(i, 1000) == 1   % Cada 10 ms ? 1000 pasos
        signo = ~signo;
    end
    u(i) = 12 * (2*signo - 1);  % 12 o -12
end


% Para ver la tension en el capacitor
% %Matrices
A = [-R/L  -1/L ; 1/C 0];
B =[1/L ; 0];
c =[0 1];%Vc como salida
D=0;

sys1=ss(A,B,c,D) %modelo de variables de estado
figure(1)
y=lsim(sys1,u,t);
plot(t,y);title('Vc');grid on;hold on

figure(2)
plot(t,u);title('Entrada,u');hold on;

%Para ver la corriente
%Matrices
A2 = [-R/L  -1/L ; 1/C 0];
B2 =[1/L ; 0];
c2 =[1  0];%corriente como salida
D2=0;

sys2=ss(A2,B2,c2,D2) %modelo de variables de estado
figure(3)
[yout,x]=lsim(sys2,u,t);
plot(x,yout,'r');title('Corriente');hold on;

%% Item [2]
% Cargar datos desde Excel
archivo = 'Curvas_Medidas_RLC_2025.xls';
datos = xlsread(archivo);

t = datos(:,1);          % Tiempo [s]
vc = datos(:,3);         % Tensi�n en el capacitor [V]
vin = datos(:,4);        % Entrada [V]

% Detectar inicio del escal�n
idx_escalon = find(abs(diff(vin)) > 5, 1);
t_rel = t(idx_escalon:end) - t(idx_escalon);
vc_rel = vc(idx_escalon:end);

% Normalizar salida
vc_final = 12;
y_norm = vc_rel / vc_final;

%% Buscar 3 puntos v�lidos para aplicar Chen
validado = false;
for i = 5:60
    for j = i+5:i+15
        for k = j+5:j+15
            if k < length(y_norm)
                y1 = y_norm(i); y2 = y_norm(j); y3 = y_norm(k);
                k1 = y1 - 1; k2 = y2 - 1; k3 = y3 - 1;
                be = 4*k1^3*k3 - 3*k1^2*k2^2 - 4*k2^3 + k3^2 + 6*k1*k2*k3;
                if be > 0
                    a1 = (k1*k2 + k3 - sqrt(be)) / (2 * (k1^2 + k2));
                    a2 = (k1*k2 + k3 + sqrt(be)) / (2 * (k1^2 + k2));
                    if 0 < a1 && a1 < 1 && 0 < a2 && a2 < 1
                        i1 = i; i2 = j; i3 = k;
                        validado = true;
                        break;
                    end
                end
            end
        end
        if validado, break; end
    end
    if validado, break; end
end

% Aplicar m�todo de Chen
t1 = t_rel(i1); t2 = t_rel(i2); t3 = t_rel(i3);
y1 = y_norm(i1); y2 = y_norm(i2); y3 = y_norm(i3);
k1 = y1 - 1; k2 = y2 - 1; k3 = y3 - 1;
be = 4*k1^3*k3 - 3*k1^2*k2^2 - 4*k2^3 + k3^2 + 6*k1*k2*k3;

alpha1 = (k1*k2 + k3 - sqrt(be)) / (2 * (k1^2 + k2));
alpha2 = (k1*k2 + k3 + sqrt(be)) / (2 * (k1^2 + k2));
beta = (2*k1^3 + 3*k1*k2 + k3 - sqrt(be)) / sqrt(be);

T1 = -t1 / log(alpha1);
T2 = -t1 / log(alpha2);
T3 = beta * (T1 - T2) + T1;

% Coeficientes estimados
a2 = T1 * T2;
a1 = T1 + T2;

% Suposici�n de C
C = 2.2e-6;
R = a1 / C;
L = a2 / C;

fprintf('>> Par�metros estimados:\n');
fprintf('T1 = %.4e s, T2 = %.4e s\n', T1, T2);
fprintf('R = %.2f Ohm, L = %.4f H, C = %.1e F\n', R, L, C);

% Funci�n de transferencia estimada
num = [1];
den = [L*C R*C 1];
G = tf(num, den);

% Simulaci�n extendida y comparaci�n (hasta 20 ms)
%t_sim = t_rel(1:20000);  % Extender simulaci�n a 20 ms
N = min(20000, length(t_rel));   % asegurarse de no pasarse del largo real
t_sim = t_rel(1:N);
u = vin(idx_escalon : idx_escalon + N - 1);
vc_trunc = vc(idx_escalon : idx_escalon + N - 1);

u = vin(idx_escalon : idx_escalon + length(t_sim) - 1);
u = u(:); % asegurar vector columna
[ysim, ~] = lsim(G, u, t_sim);

% Curva medida para comparar
vc_trunc = vc(idx_escalon : idx_escalon + length(t_sim) - 1);

% Gr�fico final
figure;
plot(t_sim, vc_trunc, 'b', 'LineWidth', 1.5); hold on;
plot(t_sim, ysim, 'r--', 'LineWidth', 1.5);
legend('Medido: v_C(t)', 'Simulado: G(s)', 'Location', 'Southeast');
%title('Comparaci�n extendida: curva medida vs modelo estimado');
xlabel('Tiempo [s]');
ylabel('Tensi�n en el capacitor [V]');
grid on;
xlim([0 max(t_sim)]);
%% Item [3]
t = datos(:,1);         % Tiempo [s]
i_meas = datos(:,2);    % Corriente [A]
vc = datos(:,3);        % Tensi�n en el capacitor [V]
vin = datos(:,4);       % Tensi�n de entrada [V]

% Par�metros obtenidos con Chen (�tem 2)
R = 220.31; %para que coincida la grafica aumento levemente la resistencia
L = 0.0004;
C = 2.2e-06; 

% Calcular ganancia real desde la respuesta al escal�n
% Detectar inicio del escal�n
idx_escalon = find(abs(diff(vin)) > 5, 1);
vc_rel = vc(idx_escalon:end);

K_real = max(vc_rel);  % salida final real del sistema (aprox 12?V)

% Funci�n de transferencia con ganancia corregida
num = [K_real];
den = [L*C R*C 1];
G = tf(num, den);

% Modelo en espacio de estados con salida la corriente i(t)
A = [-R/L -1/L;
      1/C   0 ];
B = [1/L; 0];
C_i = [1 0];   % salida: corriente
D = 0;

sys_i = ss(A, B, C_i, D);

% Simular corriente con entrada real
t_sim = t;
u = vin(:);                   
i_sim = lsim(sys_i, u, t_sim); 

% Recorte desde t = 0.05 s en adelante
idx_inicio = find(t >= 0.05, 1);
t_crop = t(idx_inicio:end);
i_sim_crop = i_sim(idx_inicio:end);
i_meas_crop = i_meas(idx_inicio:end);

% Graficar comparaci�n
figure;
plot(t_crop, i_meas_crop, 'b', 'LineWidth', 1.4); hold on;
plot(t_crop, i_sim_crop, 'r--', 'LineWidth', 1.4);
xlabel('Tiempo [s]');
ylabel('Corriente i(t) [A]');
legend('Corriente medida (Excel)', 'Corriente simulada (modelo RLC)');
title('Comparaci�n: Corriente simulada vs medida desde t = 0.05 s');
grid on;