library(readr)
library(readxl)


cargar_archivo <- function(file){

extension <- tools::file_ext(file$name)


if(extension=="csv"){

return(
read_csv(file$datapath,
show_col_types = FALSE)
)

}


if(extension %in% c("xlsx","xls")){

return(
read_excel(file$datapath)
)

}


stop("Formato no soportado")

}