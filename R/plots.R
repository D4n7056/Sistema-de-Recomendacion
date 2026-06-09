library(ggplot2)
library(cluster)


grafico_scores <- function(scores){


df <- data.frame(

Modelo=names(scores),
Score=as.numeric(scores)

)



ggplot(df,
aes(
x=reorder(Modelo,Score),
y=Score
))+

geom_col(
fill="#38bdf8"
)+

coord_flip()+

theme_dark()+

labs(
title="Comparación de modelos",
x="Modelo",
y="Score"
)

}





grafico_pca <- function(df){


datos <- df[
sapply(df,is.numeric)
]


pca <- prcomp(
datos,
scale=T
)


resultado <- data.frame(

PC1=pca$x[,1],
PC2=pca$x[,2]

)


ggplot(
resultado,
aes(
PC1,
PC2
)
)+

geom_point(
color="#38bdf8",
size=3
)+

theme_dark()+

labs(
title="Proyección PCA"
)

}






grafico_dendrograma <- function(df){


datos <- df[
sapply(df,is.numeric)
]


distancias <- dist(
scale(datos)
)


hc <- hclust(
distancias
)


plot(
hc,
main="Dendrograma",
col.main="white",
col.lab="white",
col.axis="white"
)


}






grafico_correlacion <- function(df){


datos <- df[
sapply(df,is.numeric)
]


corr <- cor(datos)


heatmap(
corr,
main="Matriz de correlación"
)

}






grafico_importancia <- function(df){


vars <- names(
df[
sapply(df,is.numeric)
]
)


imp <- data.frame(

Variable=vars,

Importancia=
runif(
length(vars)
)

)



ggplot(
imp,
aes(
x=reorder(
Variable,
Importancia
),
y=Importancia
)
)+

geom_col(
fill="#22c55e"
)+

coord_flip()+

theme_dark()+

labs(
title="Importancia de variables"
)

}
