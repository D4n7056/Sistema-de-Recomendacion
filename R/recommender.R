recomendar_modelos <- function(df){


scores <- c(

"K-Means"=0,
"PCA"=0,
"Árbol Decisión"=0,
"Random Forest"=0,
"Regresión"=0

)


filas <- nrow(df)
cols <- ncol(df)



if(cols>10){

scores["PCA"] <-
scores["PCA"]+40

}



if(filas>1000){

scores["Random Forest"] <-
scores["Random Forest"]+40

}



if(cols>5){

scores["Árbol Decisión"] <-
scores["Árbol Decisión"]+25

}



if(is.numeric(df[[ncol(df)]])){


scores["Regresión"] <-
scores["Regresión"]+50

}



scores

}