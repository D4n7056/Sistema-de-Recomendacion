library(dplyr)


perfil_dataset <- function(df){


list(

filas=nrow(df),

columnas=ncol(df),

nulos=sum(is.na(df)),

duplicados=sum(
duplicated(df)
),

numericas=sum(
sapply(df,is.numeric)
),

categoricas=sum(
sapply(df,is.character)
)

)

}