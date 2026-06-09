# ML Advisor - Sistema de recomendación de modelos ML

## Descripción
ML Advisor es una aplicación desarrollada en R utilizando Shiny,
que permite cargar datasets tabulares y analizar automáticamente
sus características para recomendar algoritmos de Machine Learning.

El sistema evalúa:

- Tamaño del dataset
- Tipos de variables
- Valores faltantes
- Dimensionalidad
- Correlaciones
- Separabilidad
- Complejidad del problema

Después genera un ranking de modelos:

- K-Means
- PCA
- Árbol de decisión
- Random Forest
- Regresión

## Arquitectura

app.R
    Punto de entrada de Shiny

R/

loader.R
    Lectura de archivos

profiler.R
    Estadísticas descriptivas

detector.R
    Clasificación del problema

recommender.R
    Sistema de puntuación

metrics.R
    Cálculo de métricas

plots.R
    Gráficos

www/

styles.css
    Interfaz visual

## Requisitos

R >= 4.2

Paquetes:

shiny
shinydashboard
readxl
readr
dplyr
ggplot2
plotly
cluster


## Instalación

Ejecutar:

install.packages(c(
"shiny",
"shinydashboard",
"readxl",
"readr",
"dplyr",
"ggplot2",
"cluster"
))

## Ejecución

Abrir RStudio

Abrir app.R

Ejecutar:

shiny::runApp()

## Flujo

1. Usuario carga CSV/XLSX
2. Sistema analiza estructura
3. Calcula métricas
4. Evalúa algoritmos
5. Genera recomendación

## Objetivo

Crear un asistente automático para apoyar
la selección inicial de técnicas de Machine Learning.
