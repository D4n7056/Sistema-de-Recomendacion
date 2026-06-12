# =====================================
# LOADER — Carga y validación de datos
# =====================================
library(readr)
library(readxl)
library(dplyr)

cargar_archivo <- function(file) {

  extension <- tools::file_ext(file$name)

  df <- if (extension == "csv") {

    tryCatch(
      read_csv(file$datapath, show_col_types = FALSE, locale = locale(encoding = "UTF-8")),
      error = function(e)
        read_csv(file$datapath, show_col_types = FALSE, locale = locale(encoding = "latin1"))
    )

  } else if (extension %in% c("xlsx", "xls")) {

    read_excel(file$datapath)

  } else {
    stop("Formato no soportado. Use CSV o XLSX.")
  }

  # Limpiar nombres de columnas
  names(df) <- make.names(names(df), unique = TRUE)

  # Eliminar columnas con 100% NA
  df <- df[, colSums(is.na(df)) < nrow(df)]

  # Convertir columnas de texto con baja cardinalidad a factor
  df <- df %>%
    mutate(across(where(is.character), ~ {
      u <- length(unique(.x))
      if (u <= 50) as.factor(.x) else .x
    }))

  df
}
