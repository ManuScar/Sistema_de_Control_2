# Tarea N°1 : Sistema de Control II

## Tabla de contenidos
1. [Objetivo](#objetivo)
2. [A lazo abierto](#a-lazo-abierto)
3. [Análisis para el sistema discreto](#análisis-para-el-sistema-discreto)
4. [A lazo cerrado con realimentación unitaria](#a-lazo-cerrado-con-realimentación-unitaria)
   
---

## Objetivo

El objetivo de este trabajo es adquirir experiencia práctica sobre los conceptos teóricos abordados en las clases 1 y 2, en las cuales se trabajaron los siguientes objetivos específicos:

1. **Fundamentos de controles digitales**  
   - Comprender los procesos de muestreo y reconstrucción de señales.

2. **Transformada Pulso y Transformada Z**  
   - Analizar la relación entre la transformada Pulso y la transformada Z.

3. **Funciones de transferencia discretas**  
   - Determinar funciones de transferencia discretas para sistemas con muestreadores y retentores de orden cero.

4. **Equivalencia entre planos s y z**  
   - Relacionar los planos s y z con:
     - Tiempos de establecimiento.
     - Frecuencias naturales amortiguadas y no amortiguadas.
     - Coeficientes de amortiguamiento constantes.

5. **Respuesta transitoria de sistemas discretos**  
   - Analizar sistemas de primer y segundo orden, y estudiar la influencia de la ubicación de polos y ceros en la respuesta transitoria.

6. **Estabilidad y errores en régimen permanente**  
   - Evaluar la estabilidad y comportamiento de los errores en estado estacionario.

7. **Método de lugar de raíces para sistemas digitales**  
   - Aplicar la extensión del método de lugar de raíces en el análisis de sistemas digitales.

## Desarrollo

Datos indicados para la realización del trabajo:

| Polo1 | Polo2 | Cero | Ganancia | Sobrepaso | Tiempo 2% | Error | Tiempo Muestreo |
|-------|-------|------|----------|-----------|-----------|-------|-----------------|
| -2    | -1    | -10  | 5        | 5         | 4         | 0     | 0.30            |

---

## A lazo abierto

### Obtener la función de transferencia continua G(s)

Utilizando el comando 'zpk()' obtengo la función de transferencia en tiempo continuo del sistema.

- Código del Matlab

```
%%Lazo Abierto
clear all; close all; clc;
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
```

- Función de Transferencia para Tiempo Continuo

```
      5 (s+10)
G =  -----------
     (s+2) (s+1)
```

Podemos observar que es un sistema de segundo orden, ya que el denominador tiene dos factores lineales (s+2) y (s+1). En cuanto a la estabilidad, un sistema es estable si todos sus polos se encuentrasn en el semiplano izquierdo del plano complejo, y como se observa ambos polos poseén parte real negativa, por lo que podemos decir que el sistema es estable.

### Hallar la FT discreta de lazo abierto $G_D$(s) del sistema de la figura con ZOH a la entrada y el tiempo de muestreo asignado Tm.

![FT_Tiempo_Discreto](https://github.com/user-attachments/assets/68681016-9542-4f2a-9aa7-96eb03a68aff)

- Código del Matlab

```
%%Lazo Abierto
clear all; close all; clc;
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
```

- Función de Transferencia para Tiempo Discreto

```
       2.6394 (z+0.1076)
Gd = ---------------------
     (z-0.7408) (z-0.5488)
```

En este caso, la función de transferencia discreta mantiene la misma estructura que la continua, pero adaptada al dominio de 𝑧, con polos y ceros específicos que determinan el comportamiento del sistema. En el caso de los sistemas discretos, la estabilidad se determina por la ubicación de los polos en el círculo unitario del plano z, por lo que podemos decir que el sistema es estable, dado que los polos tienen valores <1.

- Dibujar el mapa de polos y ceros del sistema continuo el discreto

- Código del Matlab

```
%%Lazo Abierto
clear all; close all; clc;
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
%Graficas de las FT
figure('Name', 'Mapa de Polos-Zeros de FT tiempo Continuo'), pzmap(G);        
figure('Name', 'Mapa de Polos-Zeros de FT tiempo Discreto'), pzmap(Gd);
```

- Gráfica Tiempo Continuo

![G](https://github.com/user-attachments/assets/9d878ec6-e813-4a85-be98-c28379658c04)


- Gráfica Tiempo Discreto

![Gd](https://github.com/user-attachments/assets/d6322c66-42d9-45fe-a908-1b41d1019a82)

### ¿Qué ocurre con el mapa si se multiplica por 10 el periodo de muestreo?

En este caso, los polos y ceros de $G_(D1)$(z) se desplazan, lo que indica que al aumentar el tiempo de muestreo, el sistema pierde resolución en la representación discreta, y sus características dinámicas podrían volversa más lentas o con menor precisión en comparación con el caso de $G_D$(z). Este tipo de cambios refleja cómo el tiempo de muestreo influye directamente en la respuesta de un sistema discreto.

- Código del Matlab

```
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
```
``` 
        22.809 (z+0.0389)
Gd1 = ------------------------
      (z-0.04979) (z-0.002479)
```

- Gráfica Tiempo Discreto

![Gd_10xTm](https://github.com/user-attachments/assets/1c337014-0472-42e4-8bd2-f4fffc4fe608)

### Obtener la respuesta al escalon del sistema discreto y determinar si es estable

- Código del Matlab

```
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
```

- Respuesta al Escalon Tiempo Continuo

![Rta_Step_Tiempo_Continuo](https://github.com/user-attachments/assets/61c68cd0-148a-4ddb-843f-7b75b156954d)

- Respuesta al Escalon Tiempo Discreto

![Rta_Step_Tiempo_Discreto](https://github.com/user-attachments/assets/d41a3fa6-6673-4a61-b7f3-5157038cc125)

La respuesta al escalón muestra que el sistema es estable, alcanzando un valor de amplitud constante sin oscilaciones ni sobrepasos. Al comparar ambas respuestas, se observa una forma semejante, lo que indica que la discretización conserva las características dinámicas esenciales del sistema continuo. Por lo tanto, podemos decir que el sistema es estable.

---

## Análisis para el sistema discreto

### Determinar el tipo de sistema

La función discreta $G_D$ representa un sistema de tipo 0, ya que no posee integradores puros (no tiene polos en z=1). Este tipo de sistema puede seguir entradas escalón con un error en estado estacionario finito, pero no es capaz de rastrear adecuadamente señales de tipo rampa o parabólica. Además, su estabilidad queda garantizada por los polos dentro del círculo unitario, asegurando una respuesta transitoria convergente.

### Determinar la constante de error de posición $K_P$ y el error ante un escalon y verificar mediante respuesta al escalon de lazo cerrado del sistema discreto como se muestra

![LC_Tiempo_Discreto](https://github.com/user-attachments/assets/a9391a33-8818-474b-9f79-c3c1b2688d6a)

- Código del Matlab

```
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
Gd1=c2d(G,10*Tm,'zho')     %FT de tiempo discreto Gd1(s) - Aumento 10 veces el Tm
%%Sistema Discreto
Kp=dcgain(Gd), F=feedback(Gd,1), figure('Name', 'Respuesta al Escalon'), step(F) %Constante de error de posición
```
- La constante de error de posición $K_P$ representa la ganancia estática del sistema ante una entrada escalón en lazo cerrado. Para el sistema discreto analizado, se obtuvo:
```
Kp = 25.0000
```
Esto indica que el sistema posee una capacidad de seguimiento eficiente ante una entrada escalón. El error en estado estacionario se calcula como:
$ e_{ss} = \frac{1}{1 + K_P} = \frac{1}{1 + 25} = 0.04 $
Esto equivale a un error del 4% de la entrada deseada.
  
- La función de transferencia en lazo cerrado es: 
```
       2.6394 (z+0.1076)
F = ----------------------
     (z^2 + 1.35z + 0.6907)
```
Esta función evidencia un comportamiento de segundo orden, con un tiempo de asentamiento rápido y polos dentro del círculo unitario, lo cual asegura la estabilidad.

- La simulación de la respuesta al escalón en lazo cerrado muestra que el sistema alcanza un valor final estable, validando la estabilidad en lazo cerrado y corroborando un error finito, característico de un sistema tipo 0.

- Respuesta al Escalon

![Rta_Step_LC](https://github.com/user-attachments/assets/3e9c4b9e-ff00-453e-ae3c-e45a05f9ee5a)

## Verificar error ante una rampa de entrada, ¿ converge o diverge? Explique la causa

- Código del Matlab

```
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
Gd1=c2d(G,10*Tm,'zho')     %FT de tiempo discreto Gd1(s) - Aumento 10 veces el Tm
%%Sistema Discreto
Kp=dcgain(Gd), F=feedback(Gd,1), figure('Name', 'Respuesta al Escalon'), step(F) %Constante de error de posición
t=0:Tm:100*Tm; %Genera Rampa
figure('Name', 'Rampa de entrada'), lsim(F,t,t);
```

- Rampa de entrada

![Rampa_Entrada](https://github.com/user-attachments/assets/9565d383-7be5-4c1c-b976-0464c97cc496)  

El error ante una entrada rampa diverge. Esto ocurre porque el sistema discreto analizado es del tipo 0, lo cual implica que no puede rastrear entradas rampa sin error en régimen permanente.
En sistemas tipo 0, el error en estado estacionario para una entrada rampa es infinito. Esto se debe a que no tienen polos en el origen del plano z , lo que implica que no hay integradores en la dinámica del sistema para compensar la pendiente constante de la rampa.  
La constante de error de velocidad $K_V$ para este sistema es 0, lo que confirma que el sistema no puede reducir el error ante una rampa.
La divergencia del error ante una rampa es una característica inherente a los sistemas tipo 0. Para mejorar este comportamiento, sería necesario modificar la estructura del controlador, por ejemplo, agregando un integrador para convertir el sistema a tipo 1.

---
