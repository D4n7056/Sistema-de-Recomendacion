# ML Advisor v2

Aplicación web interactiva construida con **R Shiny** que analiza cualquier dataset CSV o Excel y recomienda los algoritmos de Machine Learning más adecuados según sus características estadísticas.

---

## ¿Qué hace?

Al cargar un dataset, ML Advisor:

1. **Detecta automáticamente** el tipo de problema (clasificación binaria, multiclase, regresión o no supervisado) a partir de la variable objetivo.
2. **Genera un perfil estadístico** completo: dimensiones, nulos, duplicados, skewness, cardinalidad de categóricas, etc.
3. **Puntúa 11 algoritmos ML** de 0 a 100 con un sistema de scoring basado en las características reales del dataset (tamaño, dimensionalidad, balance de clases, outliers, multicolinealidad).
4. **Visualiza** el análisis en 8 gráficos interactivos.

### Algoritmos evaluados

| Algoritmo | Casos de uso típicos |
|---|---|
| K-Means | Clustering, segmentación |
| DBSCAN | Clusters de forma arbitraria, detección de outliers |
| PCA | Reducción de dimensionalidad |
| Árbol de Decisión | Clasificación interpretable |
| Random Forest | Clasificación/regresión robusta |
| Gradient Boosting | Alto rendimiento predictivo |
| SVM | Clasificación con margen máximo |
| KNN | Datasets pequeños, baseline rápido |
| Regresión Lineal / Logística | Relaciones lineales, interpretabilidad |
| Lasso / Ridge | Regularización, alta dimensionalidad |
| Naive Bayes | Datasets pequeños, texto |

---

## Estructura del proyecto

```
ml-advisor/
├── app.R               # Aplicación principal (UI + Server)
├── R/
│   ├── loader.R        # Carga y validación de CSV/XLSX
│   ├── detector.R      # Detección del tipo de problema ML
│   ├── profiler.R      # Perfil estadístico del dataset
│   ├── recommender.R   # Sistema de scoring de modelos
│   ├── metrics.R       # Silhouette, PCA, correlación media
│   └── plots.R         # 8 gráficos analíticos (ggplot2)
└── www/
    └── styles.css      # Tema oscuro personalizado
```

> **Nota:** los archivos `.R` deben estar en una carpeta `R/` dentro del proyecto para que los `source()` en `app.R` los encuentren correctamente.

---

## Requisitos

### R (≥ 4.1)

Instalar R desde [https://cran.r-project.org](https://cran.r-project.org).

### Paquetes necesarios

Ejecutar en la consola de R:

```r
install.packages(c(
  "shiny",
  "shinydashboard",
  "plotly",
  "ggplot2",
  "cluster",
  "readr",
  "readxl",
  "dplyr"
))
```

---

## Cómo ejecutar

### Opción A — Desde RStudio

1. Abrir el archivo `app.R` en RStudio.
2. Hacer clic en el botón **"Run App"** (esquina superior derecha del editor).

### Opción B — Desde la consola de R

```r
setwd("ruta/al/proyecto")   # ajustar a la ruta real
shiny::runApp()
```

### Opción C — Desde la terminal

```bash
Rscript -e "shiny::runApp('ruta/al/proyecto')"
```

La aplicación abrirá en el navegador en `http://127.0.0.1:PUERTO`.

---

## Uso

### 1. Cargar datos
- Ir a la pestaña **"Cargar datos"**.
- Seleccionar un archivo `.csv` o `.xlsx`.
- Revisar la vista previa de las primeras 10 filas.

### 2. Explorar el perfil
- Ir a **"Perfil"** para ver:
  - Tarjetas con dimensiones, porcentaje de nulos y duplicados.
  - Tipo de problema detectado y características clave.
  - Mapa de valores faltantes por columna.
  - Boxplots de distribución de variables (estandarizadas).
  - Métricas de calidad: Silhouette, varianza PCA, correlación media.

### 3. Ver recomendaciones
- Ir a **"Recomendaciones"** para ver:
  - Ranking de los 11 algoritmos con su score.
  - Proyección PCA 2D.
  - Scree Plot de varianza acumulada.
  - Dendrograma jerárquico.
  - Mapa de calor de correlaciones.
  - Variabilidad relativa de variables (coeficiente de variación).

---

## Formato del dataset

| Requisito | Detalle |
|---|---|
| Formatos aceptados | `.csv`, `.xlsx`, `.xls` |
| Codificación CSV | UTF-8 o Latin-1 (detección automática) |
| Variable objetivo | Debe ser la **última columna** del archivo |
| Mínimo recomendado | 10 filas y 2 columnas numéricas para métricas completas |
| Columnas con 100% NA | Se eliminan automáticamente |
| Texto con ≤ 50 valores únicos | Se convierte a factor automáticamente |

---

## Lógica de scoring

El sistema asigna puntos a cada algoritmo según reglas heurísticas:

- **Dimensionalidad** (`p > 10`, `p > 30`): favorece PCA, Lasso/Ridge.
- **Tamaño** (`n < 200`, `n > 500`, `n > 5000`): ajusta viabilidad de KNN, RF, GB.
- **Tipo de problema**: aplica bonificaciones específicas por categoría.
- **Multicolinealidad** (correlación máxima > 0.85): favorece Lasso/Ridge y PCA.
- **Desbalance de clases** (ratio min/max < 0.2): favorece RF y GB.
- **Outliers** (> 5% de observaciones fuera de 1.5×IQR): favorece DBSCAN, penaliza KNN.
- **Variables categóricas**: favorece Árbol, RF y Naive Bayes.

Los scores se normalizan al rango 0–100.

---

## Capturas de pantalla

> *Agregar imágenes de las tres pestañas aquí una vez desplegada la aplicación.*

---

## Licencia

MIT — libre para uso personal y comercial.
