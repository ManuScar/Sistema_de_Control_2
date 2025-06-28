# Tarea N°2 : Sistema de Control II

## Tabla de contenidos
1. [Objetivo](#objetivo)
2. [Obtener los valores de ξ, ω₀, ω_d](#obtener-los-valores-de-ξ-ω₀-ω_d)
3. [Calcular la cantidad de muestras por ciclo](#calcular-la-cantidad-de-muestras-por-ciclo)
4. [Determinar la ubicación de los polos deseados](#determinar-la-ubicación-de-los-polos-deseados)
5. [Diseñar al menos dos controladores digitales](#diseñar-al-menos-dos-controladores-digitales)
6. [Verificar la condición de error](#verificar-la-condición-de-error)
7. [Implementar el sistema de lazo cerrado](#implementar-el-sistema-de-lazo-cerrado)

--- 

## Objetivo

- Diseñar y analizar un sistema de control discreto que cumpla con las especificaciones dadas:
  - Sobrespaso.
  - Tiempo de establecimiento (2%).
  - Error de régimen en un escalón igual a 0.

## Desarrollo

Datos indicados para la realización del trabajo:

| Polo1 | Polo2 | Cero | Ganancia | Sobrepaso | Tiempo 2% | Error | Tiempo Muestreo |
|-------|-------|------|----------|-----------|-----------|-------|-----------------|
| -3    | -1    | -10  | 10        | 5         | 2         | 0     | 0.15            |

---

## Obtener los valores de ξ, ω₀, ω_d

- Calculamos ξ, ω₀, $ω_d$ manualmente

$$\xi = \frac{-\ln(S/100)}{\sqrt{\pi^2 + \ln(S/100)^2}}=\frac{-\ln(5/100)}{\sqrt{(\pi^2+\ln(5/100)^2)}} = 0.6901$$

$$ω₀ = 4 / (ξ * tᵣ(2\%)) = 4 / (0.6901 * 2) = 2.8981$$

$$\omega_d = \omega_o*\sqrt{1-\xi^2} = 2.0974$$

- Código de Matlab

```
%% Datos de la Tarea
z1=-10; p1=-3; p2=-1; K=10; S=5; Tr=2; Tm=0.15;
%Obtener los valores de Z, Wo y Wd
Xi=(-log(S/100))/sqrt(pi^(2)+log(S/100)^(2))
Wo=4/(Xi*Tr)
Wd=Wo*sqrt(1-Xi^2)
```

- Resultados obtenidos con Matlab

```
Xi = 0.6901


Wo = 2.8981


Wd = 2.0974
```
---

## Calcular la cantidad de muestras por ciclo

- Calculamos manualmente las muestras por ciclo

    - Para ello, primero obtenemos $t_d$

      $$t_d = \frac{2\pi}{\omega_d} = \frac{2\pi}{2.0974} = 2.9957$$

    - Por lo tanto, las muestras por ciclo son:

      $$m = \frac{t_d}{T_m} = \frac{2.9957}{0.15} = 19.9713 $$

- Código de Matlab

```
%% Datos de la Tarea
z1=-10; p1=-3; p2=-1; K=10; S=5; Tr=2; Tm=0.15;
%Obtener los valores de Z, Wo y Wd
Xi=(-log(S/100))/sqrt(pi^(2)+log(S/100)^(2))
Wo=4/(Xi*Tr)
Wd=Wo*sqrt(1-Xi^2)
%% Cantidad de Muestras por ciclo de la frecuencia amortiguada Wd
Td=2*pi/Wd
m=Td/Tm
```

- Resultado obtenido

```
m = 19.9715
```
---
## Determinar la ubicación de los polos deseados

- Mediante la equivalencia de planos s y z determinar la ubicación de los polos deseados en el plano z

$$r = |z_{1,2}| = e^{-\xi*\omega_o*T_m} = 0.7408$$

$$\Omega = ∠z_{1,2} = \pm \omega_d*T_m = \pm 0.3146 = 18.0256 ° $$

- Código de Matlab

```
%% Datos de la Tarea
z1=-10; p1=-3; p2=-1; K=10; S=5; Tr=2; Tm=0.15;
%Obtener los valores de Z, Wo y Wd
Xi=(-log(S/100))/sqrt(pi^(2)+log(S/100)^(2))
Wo=4/(Xi*Tr)
Wd=Wo*sqrt(1-Xi^2)
%% Cantidad de Muestras por ciclo de la frecuencia amortiguada Wd
Td=2*pi/Wd
m=Td/Tm
%% Equivalencias de planos s y z
r=exp(-Xi*Wo*Tm)
Omega=(Wd*Tm)*(180/pi)
```
- Resultados obtenidos
```
r = 0.7408


Omega = 18.0256
```
Pasando a coordenadas rectangulares

$$polo_{deseado}= 0.5033 \pm j 0.5436$$

---

## Diseñar al menos dos controladores digitales

- Seleccionar y diseñar al menos 2 controladores digitales en serie (PI,PD, PID o Adelanto) que cumplan (para los polos dominantes) las especificaciones dadas mediante SISOTOOL , en caso de que no se cumplan analizar el porque

- Código de Matlab

```
%% Datos de la Tarea
z1=-10; p1=-3; p2=-1; K=10; S=5; Tr=2; Tm=0.15;
%Obtener los valores de Z, Wo y Wd
Xi=(-log(S/100))/sqrt(pi^(2)+log(S/100)^(2))
Wo=4/(Xi*Tr)
Wd=Wo*sqrt(1-Xi^2)
%% Cantidad de Muestras por ciclo de la frecuencia amortiguada Wd
Td=2*pi/Wd
m=Td/Tm
%% Equivalencias de planos s y z
r=exp(-Xi*Wo*Tm)
Omega=(Wd*Tm)*(180/pi)
%Coordenadas rectangulares
real_part=r*cos(Omega)
imag_part=r*sin(Omega)
R=real_part+j*imag_part
%% Funciones de Transferencias, Sisotool
G=zpk([z1],[p1 p2],[K])    %FT de tiempo continuo G(s)
Gd=c2d(G,Tm,'zho')         %FT de tiempo discreto Gd(s)
sisotool(Gd)
```

- Función de transferencia tiempo continuo G(s)

```  
      10 (s+10)
G =  -----------
     (s+3) (s+1)
```

- Función de transferencia tiempo discreto $G_D$(s)

``` 
        2.0405 (z-0.1754)
Gd =  ---------------------
      (z-0.8607) (z-0.6376)
```

- Respuesta al escalon del sistema discreto ($G_D$)

![Rta_al_Escalon](<Imagenes Tarea 2/Rta_al_Escalon.png>)


- Lugar de Raices del sistema discreto ($G_D$)

![Lugar_de_Raices](<Imagenes Tarea 2/Lugar_de_Raices.png>)

- Diagrama de Bode del sistema discreto ($G_D$)

![Diagrama_de_Bode](<Imagenes Tarea 2/Diagrama_de_Bode.png>)

En la respuesta al escalon podemos observar que el sistema es estable, pero se observa que el sobrepaso es del 110 % y el requerido es del 5 %. En cuanto al LR se puede observar que el sistema se encuentra dentro del circulo unitario. 

Por otro lado, el análisis del Lugar Geométrico de las Raíces (LR) muestra que todos los polos del sistema en lazo cerrado se encuentran dentro del círculo unitario, lo que confirma la estabilidad del sistema en tiempo discreto.

Con el fin de mejorar la respuesta transitoria, se diseña un controlador PD discreto. Este tipo de compensador permite modificar la ubicación de los polos dominantes mediante la introducción de un cero, sin alterar el tipo del sistema. El controlador se ajusta para que el LR atraviese la región deseada del plano-z, de acuerdo con las especificaciones de sobrepaso y tiempo de establecimiento.

Posteriormente, se analizará un segundo diseño que incluya acción integradora (como un PID o un controlador por adelanto con integración) para garantizar error nulo en régimen, y se compararán los resultados obtenidos con el controlador PD.

Entonces, siguiendo los requerimientos planteados en un comienzo:

$$ \xi = 0.6901 $$
$$ t_R(2 \%) = 2 $$

![Lugar_de_Raices_Xi_Tr](<Imagenes Tarea 2/Lugar_de_Raices_Xi_Tr.png>)

### Controlador PD

Con los parametros ya fijados, se agrega el polo en 0 y el cero ajustable, se ajusta el cero para que la ganacia pueda tomar el valor que pase a traves de la intersección. Luego se ajusta la ganancia al punto exacto de la intersección.

El controlador PD tiene la forma:

$$C(z)=K*\frac{z-c}{z}; K=K_p+K_d; c=\frac{K_d}{K_p+K_d}$$ 

![Compensador](<Imagenes Tarea 2/Compensador.png>)

![Lugar_de_Raices_PI](<Imagenes Tarea 2/Lugar_de_Raices_PI.png>)

![Respuesta_al_Escalon_PI](<Imagenes Tarea 2/Respuesta_al_Escalon_PI.png>)

Como se puede observar, se ha incorporado un controlador PD discreto con un cero ubicado en 𝑧 = − 0.396, lo que permite modificar la forma del lugar geométrico de las raíces. De esta manera, se logró aproximar los polos dominantes del sistema en lazo cerrado a la región deseada del plano-z, cumpliendo con las especificaciones dinámicas establecidas.

Posteriormente, se ajustó la ganancia del sistema hasta que los polos se ubicaron en la intersección con la curva de diseño. Como resultado, la respuesta al escalón mejora considerablemente, mostrando un sobrepaso y un tiempo de establecimiento acordes con los valores requeridos.

```
    0.037654 (z+0.396)
C = ------------------
            z
```

- Código de Matlab

```
C %muestra el compensador importado de sisotool
F=feedback(C*Gd,1) % sistema de lazo cerrado
pole(F)
zero(F)
pzmap(F)
step(F) % respuesta al escalon
```

- Función a Lazo Cerrado

``` 
      0.076831 (z+0.396) (z-0.1754)
F = ------------------------------------
    (z-0.009667) (z^2 - 1.412z + 0.5521)
```

- Respuesta al escalon - Sistema a Lazo Cerrado

![Respuesta_al_Escalon_PI_LC](<Imagenes Tarea 2/Respuesta_al_Escalon_PI_LC.png>)

Se observa que el sistema se asemeja al calculado.

```
pole(F)

ans =

   0.0097 + 0.0000i
   0.7059 + 0.2319i
   0.7059 - 0.2319i
```

```
zero(F)

ans =

    -0.3960
     0.1754
```

![Pole_Zero_Map_LC](<Imagenes Tarea 2/Pole_Zero_Map_LC.png>)

Recordando la función de transferencia del controlador PD:

$$C(z)=K*\frac{z-c}{z}; K=K_p+K_d; c=\frac{K_d}{K_p+K_d}$$

Tenemos que 

$$C(z)=K*\frac{z-c}{z}=0.037654*\frac{z+0.396}{z}$$

Desarrollando la expresión y aplicando las relaciones estándar del controlador PD:

$$
K_d = b_1 \cdot T, \quad K_p = b_0 + \frac{K_d}{T}
$$

se obtuvieron:

$$
K_p = 0.052565, \quad K_d = 0.005648
$$

Ambos valores son positivos y válidos para una implementación física del controlador PD.

- Simulación en Simulink

Una vez obtenidos los valores del controlador, pasamos a simular el sistema en Simulink, a partir del archivo 'PID_digital_tarea.slx'.

![Simulink_Diagrama](<Imagenes Tarea 2/Simulink_Diagrama.png>)

Una vez abierto el archivo, ponemos en cero el $K_d$ ya que no es un controlador derivativo, y cargamos los valores previamente calculados a $K_p$ y $K_i$:

![Parametros_K](<Imagenes Tarea 2/Parametros_K.png>)

Luego configuramos la funcion de transferencia:

![alt text](<Imagenes Tarea 2/Parametros_FT.png>)

Se configura el Step y los ZOH.

Al simular el sistema, obtenemos los siguientes resultados:

- Salida del Sistema con Controlador PD

![Simulink_Out_PD](<Imagenes Tarea 2/Simulink_Out_PD.png>)

- Gráfica del Error

![Simulink_Out_Error_PD](<Imagenes Tarea 2/Simulink_Out_Error_PD.png>)

- Gráfica de la acción derivativa

![Simulink_Out_Derivador_PD](<Imagenes Tarea 2/Simulink_Out_Derivador_PD.png>)

- Gráfica de la acción proporcional

![Simulink_Out_Prop_PD](<Imagenes Tarea 2/Simulink_Out_Prop_PD.png>)

### Conclusión del controlador PD

El controlador PD diseñado logró mejorar significativamente la respuesta del sistema, reduciendo el sobrepaso y acelerando el tiempo de establecimiento. La salida presenta un comportamiento estable con bajo sobrepaso, y el error se reduce rápidamente, manteniéndose cercano a cero en régimen permanente. Esto confirma que el controlador cumple con los requisitos dinámicos planteados.

---