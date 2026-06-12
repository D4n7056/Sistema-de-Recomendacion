# =====================================
# PROFILER — Perfil estadístico del dataset
# =====================================
library(dplyr)

perfil_dataset <- function(df) {

  nums  <- df[sapply(df, is.numeric)]
  cats  <- df[sapply(df, function(x) is.factor(x) || is.character(x))]

  # Ratio de valores faltantes por columna
  nulos_por_col <- sort(colSums(is.na(df)) / nrow(df) * 100, decreasing = TRUE)

  # Skewness promedio de numéricas
  skew_vals <- if (ncol(nums) > 0) {
    sapply(nums, function(x) {
      x <- x[!is.na(x)]
      if (length(x) < 3) return(NA)
      n <- length(x)
      m <- mean(x)
      s <- sd(x)
      if (s == 0) return(NA)
      (sum((x - m)^3) / n) / s^3
    })
  } else numeric(0)

  # Cardinalidad de categóricas
  card_cats <- if (ncol(cats) > 0) sapply(cats, function(x) length(unique(x))) else integer(0)

  list(
    filas         = nrow(df),
    columnas      = ncol(df),
    nulos         = sum(is.na(df)),
    pct_nulos     = round(sum(is.na(df)) / (nrow(df) * ncol(df)) * 100, 2),
    duplicados    = sum(duplicated(df)),
    numericas     = ncol(nums),
    categoricas   = ncol(cats),
    nulos_por_col = nulos_por_col,
    skewness      = skew_vals,
    card_cats     = card_cats,
    memoria_kb    = round(object.size(df) / 1024, 1)
  )
}
