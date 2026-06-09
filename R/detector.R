detectar_tipo <- function(df){


target <- df[[ncol(df)]]

unicos <- length(unique(target))


if(unicos <= 10){

return(
"Clasificación"
)

}


if(is.numeric(target)){

return(
"Regresión"
)

}


"No supervisado"

}