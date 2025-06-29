% %Tarea N-3
% %Profesor: Laboret, Sergio
% %Alumno: Scarlatto, Manuel
% %Materia: Sistema de Control 2
% %%
% clear all; close all; clc;
% %%
% m = 3
% % mnom = m % masa nominal
% % m = 0.9*mnom % correr de nuevo el código de simulación, dibujo y analisis
% % m=1.1*mnom % ídem
% b = 0.2
% delta= 180%en grados
% l=1,G=10
% [A,B,C,D]=linmod('pendulo_mod_tarea',delta*pi/180)
% eig(A)
% rank(ctrb(A,B))
% %%Matriz ampliada
% Aa=[[A;C] zeros(3,1)]
% Ba=[B;0]
% eig(Aa)
% rank(ctrb(Aa,Ba))
% %%Controlador con la orden acker()
% p= -3%dato
% K=acker(Aa,Ba,[p p p])
% k1=K(1)
% k2=K(2)
% k3=K(3)
% eig(Aa-Ba*K) % polos lazo cerrado
% tscalc=7.5/(-p) % tiempo de respuesta calculado
% %% Control PID
% sim('pendulo_PID_tarea')
% figure(1), plot(tout,yout)
% grid on, title('Salida')
% figure(2), plot(yout,velocidad) %plano de fase
% grid on, title('Plano de fases')
% figure(3), plot(tout,torque) % torque total
% grid on, title('Torque')
% figure(4), plot(tout,-accint) % acción integral
% grid on, title('Accion integral')
% ymax=max(yout) % máximo valor de salida
% S=(ymax-delta)/delta*100 % sobrepaso en %
% erel=(delta-yout)/delta; %error relativo
% efinal=erel(end) % error final, debe ser cero
% ind=find(abs(erel)>.02); % índice elementos con error relativo absoluto menor a 2%
% tss=tout(ind(end)) % tiempo de establecimiento (ultimo valor del vector)
% yte=yout(ind(end)) % salida al tiempo ts
% uf=torque(end) % torque final
% Intf=-accint(end) % acción integral final
%%--------------------------------------
% Tarea N-3
% Profesor: Laboret, Sergio
% Alumno: Scarlatto, Manuel
% Materia: Sistema de Control 2

clear all; close all; clc;

%% Parámetros fijos
delta = 180;     % grados
l = 1;
G = 10;
b = 0.2;
p = -3;          % Polo triple para acker()

% Masa nominal
m_nom = 3;
m_values = [0.9, 1.0, 1.1] * m_nom;
colores = {'r', 'g', 'b'};
etiquetas = {'m = 0.9m', 'm = m', 'm = 1.1m'};

% Inicializar figuras
figure(1); hold on; title('Salida'); grid on;
figure(2); hold on; title('Plano de fases'); grid on;
figure(3); hold on; title('Torque total'); grid on;
figure(4); hold on; title('Acción integral'); grid on;

% Inicializar tabla de resultados
resultados = [];

for i = 1:length(m_values)
    m = m_values(i);

    %% Linealización
    [A,B,C,D] = linmod('pendulo_mod_tarea', delta*pi/180);

    %% Matriz ampliada
    Aa = [[A;C], zeros(3,1)];
    Ba = [B;0];

    %% Controlador con acker
    K = acker(Aa,Ba,[p p p]);
    k1 = K(1); k2 = K(2); k3 = K(3);

    %% Simulación
    sim('pendulo_PID_tarea');

    % Gráficos
    figure(1); plot(tout, yout, colores{i}, 'LineWidth', 2);
    figure(2); plot(yout, velocidad, colores{i}, 'LineWidth', 2);
    figure(3); plot(tout, torque, colores{i}, 'LineWidth', 2);
    figure(4); plot(tout, -accint, colores{i}, 'LineWidth', 2);

    %% Cálculos de desempeño
    ymax = max(yout);
    S = (ymax - delta)/delta * 100;      % sobrepaso en %
    erel = (delta - yout)/delta;         % error relativo
    efinal = erel(end);                  % error final
    ind = find(abs(erel) > 0.02);        
    tss = tout(ind(end));                % tiempo de establecimiento
    yte = yout(ind(end));                % salida al tiempo ts
    uf = torque(end);                    % torque final
    Intf = -accint(end);                 % acción integral final

    % Guardar resultados
    resultados = [resultados; m, S, tss, efinal, uf, Intf];
end

% Agregar leyendas
figure(1); legend(etiquetas); legend boxoff;
figure(2); legend(etiquetas); legend boxoff;
figure(3); legend(etiquetas); legend boxoff;
figure(4); legend(etiquetas); legend boxoff;

%% Mostrar tabla de resultados
disp('Tabla de Resultados [m, Sobrepaso %, tss (s), Error Final, Torque Final, Acción Integral Final]');
disp(resultados);
