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
| -2    | -1    | -10  | 5        | 5         | 4         | 0     | 0.30            |

---

## Obtener los valores de ξ, ω₀, ω_d

- Calculamos ξ, ω₀, $ω_d$ manualmente

$$\xi = \frac{-\ln(S/100)}{\sqrt{\pi^2 + \ln(S/100)^2}}=\frac{-\ln(5/100)}{\sqrt{(\pi^2+\ln(5/100)^2)}} = 0.6901$$

$$ω₀ = 4 / (ξ × tᵣ(2\%)) = 4 / (0.6901 × 4) = 1.4491$$

$$\omega_d = \omega_o*\sqrt{1-\xi^2} = 1.0487$$

- Código de Matlab

```
%Datos de la Tarea
z1=-10; p1=-2; p2=-1; K=5; S=5; Tr=4; Tm=0.30;
%Obtener los valores de Z, Wo y Wd
Z=(-log(S/100))/sqrt(pi^(2)+log(S/100)^(2))
Wo=4/(Z*Tr)
Wd=Wo*sqrt(1-Z^2)
```

- Resultados obtenidos con Matlab

```
Xi = 0.6901

Wo = 1.4491

Wd = 1.0487
```
---

## Calcular la cantidad de muestras por ciclo

- Calculamos manualmente las muestras por ciclo

    - Para ello, primero obtenemos $t_d$

      $$t_d = \frac{2\pi}{\omega_d} = \frac{2\pi}{1.0487} = 5.9914$$

    - Por lo tanto, las muestras por ciclo son:

      $$m = \frac{t_d}{T_m} = \frac{5.9914}{0.30} = 19.97 $$

- Código de Matlab

```
%Datos de la Tarea
z1=-10; p1=-2; p2=-1; K=5; S=5; Tr=4; Tm=0.30;
%Obtener los valores de Z, Wo y Wd
Xi=(-log(S/100))/sqrt(pi^(2)+log(S/100)^(2))
Wo=4/(Xi*Tr)
Wd=Wo*sqrt(1-Xi^2)
Td=2*pi/Wd
%Cantidad de Muestras por ciclo de la frecuencia amortiguada Wd
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

$$\Omega = ∠z_{1,2} = \pm \omega_d*T_m = \pm 0.3146 = 18.0258 ° $$

Pasando a coordenadas rectangulares

$$polo_{deseado}= 0.7045 \pm j 0.2289$$

- Código de Matlab

```
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
```
- Resultados obtenidos
```

r = 0.7408

Omega = 18.0256

real_part = 0.5033

imag_part = -0.5436

R = 0.5033 - 0.5436i
```

---

## Diseñar al menos dos controladores digitales

- Seleccionar y diseñar al menos 2 controladores digitales en serie (PI,PD, PID o Adelanto) que cumplan (para los polos dominantes) las especificaciones dadas mediante SISOTOOL , en caso de que no se cumplan analizar el porque

- Código de Matlab

```
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
```

- Función de transferencia tiempo continuo G(s)

``` 
     5 (s+10)
G = -----------
    (s+2) (s+1)
```

- Función de transferencia tiempo discreto $G_D$(s)

``` 
       2.6394 (z+0.1076)
Gd = ---------------------
     (z-0.7408) (z-0.5488)
```

- Respuesta al escalon del sistema discreto ($G_D$)

![alt text](<Imagenes Tarea 2/Respuesta_al_Escalon.jpg>)

- Lugar de Raices del sistema discreto ($G_D$)

![alt text](<Imagenes Tarea 2/Lugar_de_Raices.jpg>)

- Diagrama de Bode del sistema discreto ($G_D$)

![alt text](<Imagenes Tarea 2/Diagrama_de_Bode.jpg>)

En la respuesta al escalon podemos observar que el sistema es estable, pero se observa que el sobrepaso es del 174 % y el requerido es del 4 %. En cuanto al LR se puede observar que el sistema se encuentra dentro del circulo unitario. 

Se diseña entonces un controlador PI, dado que el sistema no poseé un polo en 1, por lo tanto se fija un polo en 1 y se agrega un cero ajustable. Luego se genera un controlador en adelanto y se compararan los resultados.

Entonces, siguiendo los requerimientos planteados en un comienzo:

$$\xi = 0.6901$$
$$t_R(2\%) = 4$$

![alt text](<Imagenes Tarea 2/Lugar_de_Raices_Xi_Tr.jpg>)

### Controlador PI

Con los parametros ya fijados, se agrega el polo en 1 y el cero ajustable, se ajusta el cero para que la ganacia pueda tomar el valor que pase a traves de la intersección. Luego se ajusta la ganancia al punto exacto de la intersección.

El controlador PI tiene la forma:

$$C(z)=K*\frac{z-c}{z-1}$$ 

![alt text](<Imagenes Tarea 2/Compensador.jpg>)

![alt text](<Imagenes Tarea 2/Lugar_de_Raices_PI.jpg>)

![alt text](<Imagenes Tarea 2/Respuesta_al_Escalon_PI.jpg>)

Como podemos observar, con el cero ajustable se cancelo el polo en 0.74 y luego se ajusto la ganancia a la altura de las intersecciones. Podemos ver a su vez, como la respuesta al escalon mejor y se amolda a los parametros solicitados.

Ahora se exporta el compensador C y se contruye el sistema a lazo cerrado.

```
    0.042987 (z-0.744)
C = ------------------
         (z-1)
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
      0.11346 (z-0.744) (z+0.1076)
F = ----------------------------------
    (z-0.7474) (z^2 - 1.429z + 0.5561)
```

- Respuesta al escalon - Sistema a Lazo Cerrado

![alt text](<Imagenes Tarea 2/Respuesta_al_Escalon_PI_LC.jpg>)

Se observa que el sistema se asemeja al calculado.

```
pole(F)

ans =

   0.7144 + 0.2140i
   0.7144 - 0.2140i
   0.7474 + 0.0000i
```

```
zero(F)

ans =

    0.7440
   -0.1076
```

![alt text](<Imagenes Tarea 2/Pole_Zero_Map_LC.jpg>)

---