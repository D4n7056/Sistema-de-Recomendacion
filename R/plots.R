# =====================================
# PLOTS — 8 gráficos analíticos
# =====================================
library(ggplot2)
library(cluster)

# Paleta corporativa
COL_AZUL   <- "#38bdf8"
COL_VERDE  <- "#22c55e"
COL_NARANJA<- "#f97316"
COL_ROJO   <- "#f43f5e"
COL_MORADO <- "#a78bfa"
FONDO      <- "#111827"
PANEL      <- "#1f2937"
TEXTO      <- "white"

tema_ml <- function() {
  theme_dark(base_size = 12) +
    theme(
      plot.background  = element_rect(fill = FONDO, color = NA),
      panel.background = element_rect(fill = PANEL, color = NA),
      panel.grid.major = element_line(color = "#374151"),
      panel.grid.minor = element_blank(),
      text             = element_text(color = TEXTO),
      axis.text        = element_text(color = TEXTO),
      plot.title       = element_text(color = TEXTO, size = 13, face = "bold"),
      legend.background= element_rect(fill = PANEL),
      legend.text      = element_text(color = TEXTO)
    )
}

# ── 1. Ranking de modelos ─────────────────────────
grafico_scores <- function(scores) {

  df <- data.frame(
    Modelo = names(scores),
    Score  = as.numeric(scores)
  )
  df$Color <- ifelse(df$Score == max(df$Score), COL_VERDE, COL_AZUL)

  ggplot(df, aes(x = reorder(Modelo, Score), y = Score, fill = Color)) +
    geom_col(show.legend = FALSE) +
    geom_text(aes(label = Score), hjust = -0.2, color = TEXTO, size = 3.5) +
    scale_fill_identity() +
    coord_flip(clip = "off") +
    ylim(0, 115) +
    tema_ml() +
    labs(title = "Ranking de modelos (score 0–100)", x = NULL, y = "Score")
}

# ── 2. PCA — Proyección 2D ────────────────────────
grafico_pca <- function(df) {

  datos <- na.omit(df[sapply(df, is.numeric)])
  if (ncol(datos) < 2) return(ggplot() + labs(title = "Insuficientes variables numéricas") + tema_ml())

  pca <- prcomp(datos, scale. = TRUE)
  var_exp <- round(summary(pca)$importance[2, 1:2] * 100, 1)

  resultado <- data.frame(PC1 = pca$x[, 1], PC2 = pca$x[, 2])

  ggplot(resultado, aes(PC1, PC2)) +
    geom_point(color = COL_AZUL, alpha = 0.7, size = 2) +
    stat_ellipse(color = COL_NARANJA, linewidth = 0.8, level = 0.95) +
    tema_ml() +
    labs(
      title = "Proyección PCA (PC1 vs PC2)",
      x = paste0("PC1 (", var_exp[1], "% varianza)"),
      y = paste0("PC2 (", var_exp[2], "% varianza)")
    )
}

# ── 3. Scree plot PCA ────────────────────────────
grafico_scree <- function(df) {

  datos <- na.omit(df[sapply(df, is.numeric)])
  if (ncol(datos) < 2) return(ggplot() + labs(title = "Insuficientes variables numéricas") + tema_ml())

  pca    <- prcomp(datos, scale. = TRUE)
  imp    <- summary(pca)$importance
  n_comp <- min(10, ncol(datos))

  df_scree <- data.frame(
    Componente    = paste0("PC", 1:n_comp),
    Varianza      = imp[2, 1:n_comp] * 100,
    Acumulada     = imp[3, 1:n_comp] * 100
  )
  df_scree$Componente <- factor(df_scree$Componente, levels = df_scree$Componente)

  ggplot(df_scree, aes(x = Componente)) +
    geom_col(aes(y = Varianza), fill = COL_AZUL, alpha = 0.85) +
    geom_line(aes(y = Acumulada, group = 1), color = COL_NARANJA, linewidth = 1.2) +
    geom_point(aes(y = Acumulada), color = COL_NARANJA, size = 2.5) +
    geom_hline(yintercept = 80, linetype = "dashed", color = COL_ROJO, alpha = 0.7) +
    tema_ml() +
    labs(title = "Scree Plot — Varianza por componente", x = NULL, y = "Varianza (%)")
}

# ── 4. Dendrograma ───────────────────────────────
grafico_dendrograma <- function(df) {

  datos <- na.omit(df[sapply(df, is.numeric)])
  if (nrow(datos) < 4) return(NULL)

  # Muestra para datasets grandes
  if (nrow(datos) > 300) datos <- datos[sample(nrow(datos), 300), ]

  hc <- hclust(dist(scale(datos)), method = "ward.D2")

  par(
    bg  = FONDO,
    col.main = TEXTO, col.lab = TEXTO, col.axis = TEXTO,
    fg  = "#374151"
  )
  plot(
    hc,
    main   = "Dendrograma (Ward D2)",
    labels = FALSE,
    hang   = -1,
    xlab   = "",
    ylab   = "Distancia",
    sub    = ""
  )
  rect.hclust(hc, k = 3, border = COL_NARANJA)
}

# ── 5. Mapa de calor de correlaciones ────────────
grafico_correlacion <- function(df) {

  datos <- na.omit(df[sapply(df, is.numeric)])
  if (ncol(datos) < 2) return(ggplot() + labs(title = "Sin variables numéricas") + tema_ml())

  # Limitar a 20 variables para legibilidad
  if (ncol(datos) > 20) datos <- datos[, 1:20]

  corr <- cor(datos)
  df_corr <- as.data.frame(as.table(corr))
  names(df_corr) <- c("Var1", "Var2", "Correlacion")

  ggplot(df_corr, aes(Var1, Var2, fill = Correlacion)) +
    geom_tile(color = FONDO) +
    geom_text(aes(label = round(Correlacion, 2)), size = 2.5, color = TEXTO) +
    scale_fill_gradient2(
      low     = COL_ROJO,
      mid     = PANEL,
      high    = COL_AZUL,
      midpoint = 0,
      limits  = c(-1, 1)
    ) +
    coord_fixed() +
    tema_ml() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
          axis.text.y = element_text(size = 8)) +
    labs(title = "Matriz de correlación", x = NULL, y = NULL, fill = "r")
}

# ── 6. Importancia de variables (proxy varianza) ─
grafico_importancia <- function(df) {

  datos <- df[sapply(df, is.numeric)]
  if (ncol(datos) == 0) return(ggplot() + labs(title = "Sin variables numéricas") + tema_ml())

  # Usar coeficiente de variación como proxy de importancia informativa
  imp <- sapply(datos, function(x) {
    x <- x[!is.na(x)]
    if (length(x) < 2 || mean(x) == 0) return(0)
    abs(sd(x) / mean(x))
  })

  df_imp <- data.frame(
    Variable    = names(imp),
    Importancia = round(imp, 4)
  )

  ggplot(df_imp, aes(x = reorder(Variable, Importancia), y = Importancia, fill = Importancia)) +
    geom_col(show.legend = FALSE) +
    scale_fill_gradient(low = COL_AZUL, high = COL_VERDE) +
    coord_flip() +
    tema_ml() +
    labs(title = "Variabilidad relativa de variables (CV)", x = NULL, y = "Coef. Variación")
}

# ── 7. Distribuciones (boxplots) ─────────────────
grafico_distribuciones <- function(df) {

  datos <- df[sapply(df, is.numeric)]
  if (ncol(datos) == 0) return(ggplot() + labs(title = "Sin variables numéricas") + tema_ml())
  if (ncol(datos) > 15) datos <- datos[, 1:15]

  # Escalar para comparar en el mismo eje
  df_long <- stack(as.data.frame(scale(datos)))
  names(df_long) <- c("Valor", "Variable")

  ggplot(df_long, aes(x = Variable, y = Valor, fill = Variable)) +
    geom_boxplot(show.legend = FALSE, outlier.color = COL_ROJO, outlier.size = 1) +
    scale_fill_manual(values = rep(c(COL_AZUL, COL_MORADO, COL_VERDE, COL_NARANJA), 10)) +
    coord_flip() +
    tema_ml() +
    labs(title = "Distribución de variables (estandarizadas)", x = NULL, y = "Z-score")
}

# ── 8. Mapa de valores faltantes ─────────────────
grafico_nulos <- function(df) {

  pct <- colSums(is.na(df)) / nrow(df) * 100
  pct <- pct[pct > 0]

  if (length(pct) == 0) {
    return(
      ggplot() +
        annotate("text", x = 0.5, y = 0.5, label = "✓ Sin valores faltantes",
                 color = COL_VERDE, size = 6) +
        tema_ml() +
        theme(axis.text = element_blank(), axis.ticks = element_blank()) +
        labs(title = "Valores faltantes por columna", x = NULL, y = NULL)
    )
  }

  df_nulos <- data.frame(
    Columna   = names(pct),
    Porcentaje = round(pct, 2)
  )

  ggplot(df_nulos, aes(x = reorder(Columna, Porcentaje), y = Porcentaje, fill = Porcentaje)) +
    geom_col(show.legend = FALSE) +
    geom_hline(yintercept = 30, linetype = "dashed", color = COL_ROJO, alpha = 0.8) +
    scale_fill_gradient(low = COL_AZUL, high = COL_ROJO) +
    coord_flip() +
    tema_ml() +
    labs(title = "% Valores faltantes por columna", x = NULL, y = "%")
}
