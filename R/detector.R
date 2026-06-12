# =====================================
# DETECTOR — Clasificación del problema ML
# =====================================

detectar_tipo <- function(df) {

  target <- df[[ncol(df)]]
  n      <- nrow(df)
  unicos <- length(unique(target[!is.na(target)]))

  # Sin variable target clara → no supervisado
  if (unicos / n > 0.95) return("No supervisado")

  # Target numérica continua
  if (is.numeric(target) && unicos > 20) {
    return("Regresión")
  }

  # Target con pocas clases → clasificación
  if (unicos <= 20) {

    if (unicos == 2) return("Clasificación binaria")

    return("Clasificación multiclase")
  }

  "No supervisado"
}


# Características adicionales del problema
caracteristicas_problema <- function(df) {

  nums   <- df[sapply(df, is.numeric)]
  target <- df[[ncol(df)]]
  n      <- nrow(df)
  p      <- ncol(df)

  # Balance de clases (si es clasificación)
  balance <- if (!is.numeric(target) || length(unique(target)) <= 20) {
    tbl   <- table(target)
    ratio <- min(tbl) / max(tbl)
    if (ratio < 0.2) "Desbalanceado" else "Balanceado"
  } else NA

  # Alta dimensionalidad
  alta_dim <- p > 30 || (n > 0 && p / n > 0.5)

  # Multicolinealidad
  multicol <- if (ncol(nums) >= 2) {
    cm  <- cor(nums, use = "complete.obs")
    diag(cm) <- 0
    max(abs(cm), na.rm = TRUE) > 0.85
  } else FALSE

  # Outliers (IQR)
  outliers <- if (ncol(nums) > 0) {
    mean(sapply(nums, function(x) {
      q  <- quantile(x, c(0.25, 0.75), na.rm = TRUE)
      iq <- q[2] - q[1]
      sum(x < q[1] - 1.5 * iq | x > q[2] + 1.5 * iq, na.rm = TRUE) / length(x)
    })) > 0.05
  } else FALSE

  list(
    tipo       = detectar_tipo(df),
    balance    = balance,
    alta_dim   = alta_dim,
    multicol   = multicol,
    outliers   = outliers,
    n          = n,
    p          = p
  )
}
