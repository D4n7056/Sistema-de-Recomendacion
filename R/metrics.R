library(cluster)


calcular_silhouette <- function(df){


datos <- df[
sapply(df,is.numeric)
]


if(ncol(datos)<2){

return(0)

}


modelo <- kmeans(
scale(datos),
centers=3
)


sil <- silhouette(
modelo$cluster,
dist(scale(datos))
)


mean(sil[,3])

}



calcular_pca <- function(df){


datos <- df[
sapply(df,is.numeric)
]


modelo <- prcomp(
datos,
scale=T
)


sum(
summary(modelo)$importance[2,1:3]
)

}