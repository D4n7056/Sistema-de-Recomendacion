# =====================================
# RECOMMENDER — Sistema de scoring ML
# Modelos evaluados: 10
# =====================================

recomendar_modelos <- function(df) {

  caract <- caracteristicas_problema(df)
  tipo   <- caract$tipo
  n      <- caract$n
  p      <- caract$p
  nums   <- df[sapply(df, is.numeric)]

  scores <- c(
    "K-Means"           = 0,
    "DBSCAN"            = 0,
    "PCA"               = 0,
    "Árbol Decisión"    = 0,
    "Random Forest"     = 0,
    "Gradient Boosting" = 0,
    "SVM"               = 0,
    "KNN"               = 0,
    "Regresión Lineal"  = 0,
    "Lasso / Ridge"     = 0,
    "Naive Bayes"       = 0
  )

  # ── Dimensionalidad ──────────────────────────────
  if (p > 10) {
    scores["PCA"]               <- scores["PCA"] + 40
    scores["Lasso / Ridge"]     <- scores["Lasso / Ridge"] + 20
  }
  if (p > 30) {
    scores["PCA"]               <- scores["PCA"] + 20
    scores["Random Forest"]     <- scores["Random Forest"] + 15
    scores["SVM"]               <- scores["SVM"] - 10   # costoso en alta dim
  }

  # ── Tamaño del dataset ───────────────────────────
  if (n > 500) {
    scores["Random Forest"]     <- scores["Random Forest"] + 30
    scores["Gradient Boosting"] <- scores["Gradient Boosting"] + 30
    scores["SVM"]               <- scores["SVM"] + 15
  }
  if (n < 200) {
    scores["KNN"]               <- scores["KNN"] + 20
    scores["Naive Bayes"]       <- scores["Naive Bayes"] + 15
    scores["SVM"]               <- scores["SVM"] + 20
    scores["Random Forest"]     <- scores["Random Forest"] - 10
  }
  if (n > 5000) {
    scores["Gradient Boosting"] <- scores["Gradient Boosting"] + 20
    scores["KNN"]               <- scores["KNN"] - 20   # lento en grandes N
  }

  # ── Tipo de problema ─────────────────────────────
  if (tipo %in% c("Clasificación binaria", "Clasificación multiclase")) {
    scores["Árbol Decisión"]    <- scores["Árbol Decisión"] + 35
    scores["Random Forest"]     <- scores["Random Forest"] + 35
    scores["Gradient Boosting"] <- scores["Gradient Boosting"] + 35
    scores["SVM"]               <- scores["SVM"] + 30
    scores["KNN"]               <- scores["KNN"] + 25
    scores["Naive Bayes"]       <- scores["Naive Bayes"] + 25
  }
  if (tipo == "Clasificación binaria") {
    scores["Regresión Lineal"]  <- scores["Regresión Lineal"] + 10  # logística
    scores["Lasso / Ridge"]     <- scores["Lasso / Ridge"] + 10
  }
  if (tipo == "Regresión") {
    scores["Regresión Lineal"]  <- scores["Regresión Lineal"] + 60
    scores["Lasso / Ridge"]     <- scores["Lasso / Ridge"] + 55
    scores["Random Forest"]     <- scores["Random Forest"] + 30
    scores["Gradient Boosting"] <- scores["Gradient Boosting"] + 30
    scores["SVM"]               <- scores["SVM"] + 20
    scores["Árbol Decisión"]    <- scores["Árbol Decisión"] + 15
  }
  if (tipo == "No supervisado") {
    scores["K-Means"]           <- scores["K-Means"] + 50
    scores["DBSCAN"]            <- scores["DBSCAN"] + 45
    scores["PCA"]               <- scores["PCA"] + 30
  }

  # ── Multicolinealidad ────────────────────────────
  if (isTRUE(caract$multicol)) {
    scores["Lasso / Ridge"]     <- scores["Lasso / Ridge"] + 25
    scores["PCA"]               <- scores["PCA"] + 20
    scores["Regresión Lineal"]  <- scores["Regresión Lineal"] - 15
  }

  # ── Desbalance de clases ─────────────────────────
  if (!is.na(caract$balance) && caract$balance == "Desbalanceado") {
    scores["Random Forest"]     <- scores["Random Forest"] + 15
    scores["Gradient Boosting"] <- scores["Gradient Boosting"] + 15
    scores["KNN"]               <- scores["KNN"] - 10
    scores["Naive Bayes"]       <- scores["Naive Bayes"] - 5
  }

  # ── Outliers ─────────────────────────────────────
  if (isTRUE(caract$outliers)) {
    scores["DBSCAN"]            <- scores["DBSCAN"] + 25
    scores["Random Forest"]     <- scores["Random Forest"] + 10
    scores["SVM"]               <- scores["SVM"] + 10
    scores["KNN"]               <- scores["KNN"] - 15
    scores["Regresión Lineal"]  <- scores["Regresión Lineal"] - 10
  }

  # ── Variables categóricas presentes ──────────────
  n_cats <- sum(sapply(df, function(x) is.factor(x) || is.character(x)))
  if (n_cats > 0) {
    scores["Árbol Decisión"]    <- scores["Árbol Decisión"] + 10
    scores["Random Forest"]     <- scores["Random Forest"] + 10
    scores["Naive Bayes"]       <- scores["Naive Bayes"] + 10
  }

  # Clamp a 0
  scores <- pmax(scores, 0)

  # Normalizar a 0–100
  mx <- max(scores)
  if (mx > 0) scores <- round(scores / mx * 100)

  sort(scores, decreasing = TRUE)
}
