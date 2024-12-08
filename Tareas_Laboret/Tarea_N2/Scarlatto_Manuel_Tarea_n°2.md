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

$\xi = \frac{-\ln(S/100)}{\sqrt{\pi^2 + \ln(S/100)^2}}=\frac{-\ln(5/100)}{\sqrt{(\pi^2+\ln(5/100)^2)}} = 0.6901$

$\omega_o = \frac{4}{\xi*t_R(2\%)} = \frac{4}{0.6901*4} = 1.4491$

$\omega_d = \omega_o*\sqrt{1-\xi^2} = 1.0487$

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

      $t_d = \frac{2\pi}{\omega_d} = \frac{2\pi}{1.0487} = 5.9914$ 

    - Por lo tanto, las muestras por ciclo son:

      $m = \frac{t_d}{T_m} = \frac{5.9914}{0.30} = 19.97 $

---

## Determinar la ubicación de los polos deseados

- Mediante la equivalencia de planos s y z determinar la ubicación de los polos deseados en el plano z

$r = |z_{1,2}| = e^{-\xi*\omega_o*T_m} = 0.7408$

$\Omega = ∠z_{1,2} = \pm \omega_d*T_m = \pm 0.3146 = 18.0258 ° $

Pasando a coordenadas rectangulares

$polo_{deseado}= 0.7045 \pm j 0.2289$

---