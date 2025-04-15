# Trabajo Práctico N°1 : Representación de sistemas y controladores

**Materia:** Sistemas de Control II  
**Carrera:** Ingeniería Electrónica   
**Profesor:** Dr. Ing. J. A. Pucheta  
**Alumno:** Apellido, Nombre  
**Año:** 2025  

---

## Tabla de contenidos
1. [Caso de estudio 1. Sistema de dos variables de estado](#caso_de_estudio_1)
2. [Caso de estudio 2. Sistema de tres variables de estado](#caso_de_estudio_2)

---
## Caso de estudio 1. Sistema de dos variables de estado

<figure>
  <img src="Imagenes/Esquematico_RLC.png" alt="Esquemático del circuito RLC" width="300"/>
  <figcaption><em>Figura 1-1. Esquemático del circuito RLC.</em></figcaption>
</figure>

Sea el sistema eléctrico de la figura 1-1, con las representaciones en variables de estado

$$
\dot{x}(t) = A x(t) + b u(t) \tag{1-1}
$$

$$
y = c^T x(t) \tag{1-2}
$$

donde las matrices contienen a los coeficientes del circuito:

$$
A = 
\begin{bmatrix}
-\frac{R}{L} & -\frac{1}{L} \\
\frac{1}{C} & 0
\end{bmatrix}, \quad
b = 
\begin{bmatrix}
\frac{1}{L} \\
0
\end{bmatrix} \tag{1-3}
$$

$$
c^T = [R \quad 0] \tag{1-4}
$$

<figure>
  <img src="Imagenes/Curvas.png" alt="Curvas del circuito RLC para una entrada de 12V." width="600"/>
  <figcaption><em>Figura 1-2. Curvas del circuito RLC para una entrada de 12V.</em></figcaption>
</figure>

### Ítem [1] 
Asignar valores a **R = 220 Ω**, **L = 500 mH**, y **C = 2,2 μF**. Obtener simulaciones que permitan estudiar la dinámica del sistema, con una entrada de tensión escalón de **12 V**, que cambia de signo cada **10 ms**.

### Ítem [2]
En el archivo **Curvas_Medidas_RLC_2025.xls** (datos en la **hoja 1** y etiquetas en la **hoja 2**) están las series de datos que sirven para deducir los valores de **R**, **L** y **C** del circuito. Emplear el **método de la respuesta al escalón**, tomando como salida la **tensión en el capacitor**.

### Ítem [3]
Una vez determinados los parámetros **R**, **L** y **C**, emplear la **serie de corriente desde 0.05 seg en adelante** para validar el resultado **superponiendo las gráficas**.

## Desarrollo



---
## Caso de estudio 2. Sistema de tres variable de estado

---