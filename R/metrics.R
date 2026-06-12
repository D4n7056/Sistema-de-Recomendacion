# =====================================
# METRICS — Métricas de calidad del dataset
# =====================================
library(cluster)

# Silhouette con k óptimo automático (2–5)
calcular_silhouette <- function(df) {

  datos <- df[sapply(df, is.numeric)]
  datos <- na.omit(datos)

  if (ncol(datos) < 2 || nrow(datos) < 10) return(NA_real_)

  datos_sc <- scale(datos)

  # Probar k = 2..5 y quedarse con el mayor silhouette
  resultados <- sapply(2:min(5, nrow(datos) - 1), function(k) {
    tryCatch({
      km  <- kmeans(datos_sc, centers = k, nstart = 10)
      sil <- silhouette(km$cluster, dist(datos_sc))
      mean(sil[, 3])
    }, error = function(e) NA_real_)
  })

  round(max(resultados, na.rm = TRUE), 4)
}


# Varianza explicada por los primeros 3 componentes PCA
calcular_pca <- function(df) {

  datos <- df[sapply(df, is.numeric)]
  datos <- na.omit(datos)

  if (ncol(datos) < 2) return(NA_real_)

  modelo  <- prcomp(datos, scale. = TRUE)
  n_comp  <- min(3, ncol(datos))
  varianza <- sum(summary(modelo)$importance[2, 1:n_comp])

  round(varianza, 4)
}


# Correlación media absoluta (señal de multicolinealidad)
calcular_correlacion_media <- function(df) {

  datos <- df[sapply(df, is.numeric)]
  datos <- na.omit(datos)

  if (ncol(datos) < 2) return(NA_real_)

  cm <- cor(datos)
  diag(cm) <- NA
  round(mean(abs(cm), na.rm = TRUE), 4)
}


# Ratio de valores faltantes global
calcular_pct_nulos <- function(df) {
  round(sum(is.na(df)) / (nrow(df) * ncol(df)) * 100, 2)
}
