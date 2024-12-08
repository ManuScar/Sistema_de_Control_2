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

- Obtener la función de transferencia continua G(s)

Utilizando el comando 'zpk()' obtengo la función de transferencia en tiempo continuo del sistema.

### Código del Matlab

```
%%Lazo Abierto
clear all; close all; clc;
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
```

### Función de Transferencia para Tiempo Continuo

```
      5 (s+10)
G =  -----------
     (s+2) (s+1)
```

- Hallar la FT discreta de lazo abierto $G_D$(s) del sistema de la figura con ZOH a la entrada y el tiempo de muestreo asignado Tm.

![FT_Tiempo_Discreto](https://github.com/user-attachments/assets/68681016-9542-4f2a-9aa7-96eb03a68aff)

### Código del Matlab

```
%%Lazo Abierto
clear all; close all; clc;
%Datos de la Tarea
z1=-10; p1=-2; p2=-1;K=5; Tm=0.30;
%Funciones de Transferencia
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
```

### Función de Transferencia para Tiempo Discreto

```
       2.6394 (z+0.1076)
Gd = ---------------------
     (z-0.7408) (z-0.5488)
```

### Dibujar el mapa de polos y ceros del sistema continuo el discreto 

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

### Gráfica Tiempo Continuo

![G](https://github.com/user-attachments/assets/eec8aa96-17cb-480d-9715-b2d27b63a384)

### Gráfica Tiempo Discreto

![Gd](https://github.com/user-attachments/assets/43873d23-a396-4f0c-ab20-c08b727c098d)

---

