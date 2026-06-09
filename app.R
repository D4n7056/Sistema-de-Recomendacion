# =====================================
# ML ADVISOR - APP PRINCIPAL
# =====================================
library(shiny)
library(shinydashboard)
library(plotly)

# Cargar módulos
source("R/loader.R")
source("R/profiler.R")
source("R/detector.R")
source("R/recommender.R")
source("R/metrics.R")
source("R/plots.R")

# =====================================
# UI
# =====================================
ui <- dashboardPage(

  skin="blue",

  dashboardHeader(title="ML Advisor"),

  dashboardSidebar(
    sidebarMenu(

      menuItem("Analizador",tabName="analizar", icon=icon("database")),

      menuItem("Resultados", tabName="resultados", icon=icon("chart-line"))
    )
  ),

  dashboardBody(

    tags$head(tags$link(rel="stylesheet", href="styles.css")),





    tabItems(



      # ----------------------------
      # TAB ANALIZADOR
      # ----------------------------


      tabItem(

        tabName="analizar",


        h2("Cargar Dataset"),



        fileInput(

          "archivo",

          "Seleccione archivo CSV/XLSX",

          accept=c(
            ".csv",
            ".xlsx",
            ".xls"
          )

        ),





        box(

          width=12,

          title="Vista previa del dataset",

          solidHeader=TRUE,

          tableOutput(
            "tabla"
          )

        )



      ),







      # ----------------------------
      # TAB RESULTADOS
      # ----------------------------



      tabItem(

        tabName="resultados",




        h2("Análisis ML"),





        div(

          class="success-box",

          icon("check-circle"),

          " Comparación completada",

          br(),

          "Los algoritmos fueron evaluados y se generaron recomendaciones."

        ),






        box(

          width=12,

          title="Resumen del análisis",

          verbatimTextOutput(
            "info"
          )

        ),






        fluidRow(



          box(

            width=6,

            title="Ranking de modelos",

            plotOutput(
              "ranking"
            )

          ),




          box(

            width=6,

            title="PCA - Distribución",

            plotOutput(
              "pca"
            )

          )



        ),








        fluidRow(



          box(

            width=6,

            title="Dendrograma",

            plotOutput(
              "dendro"
            )

          ),




          box(

            width=6,

            title="Matriz de correlación",

            plotOutput(
              "corr"
            )

          )



        ),







        box(

          width=12,

          title="Importancia de variables",

          plotOutput(
            "importance"
          )

        )





      )




    )

  )


)





# =====================================
# SERVER
# =====================================



server <- function(input, output){



  # -------------------------------
  # CARGAR DATASET
  # -------------------------------


  datos <- reactive({


    req(input$archivo)


    cargar_archivo(
      input$archivo
    )


  })






  # -------------------------------
  # TABLA INTERACTIVA SIMPLE
  # -------------------------------


  output$tabla <- renderTable({


    req(datos())


    head(
      datos(),
      10
    )


  })









  # -------------------------------
  # RECOMENDACIONES
  # -------------------------------


  resultado <- reactive({


    req(datos())


    recomendar_modelos(
      datos()
    )


  })









  # -------------------------------
  # INFORMACIÓN
  # -------------------------------


  output$info <- renderPrint({



    cat(
      "Tipo de problema detectado:\n\n"
    )


    print(
      detectar_tipo(
        datos()
      )
    )



    cat(
      "\n\nRanking de modelos:\n\n"
    )


    print(
      sort(
        resultado(),
        decreasing=TRUE
      )
    )



  })









  # -------------------------------
  # GRÁFICO RANKING
  # -------------------------------


  output$ranking <- renderPlot({


    grafico_scores(
      resultado()
    )


  })










  # -------------------------------
  # PCA
  # -------------------------------


  output$pca <- renderPlot({


    grafico_pca(
      datos()
    )


  })









  # -------------------------------
  # DENDROGRAMA
  # -------------------------------


  output$dendro <- renderPlot({


    grafico_dendrograma(
      datos()
    )


  })









  # -------------------------------
  # CORRELACIÓN
  # -------------------------------


  output$corr <- renderPlot({


    grafico_correlacion(
      datos()
    )


  })









  # -------------------------------
  # IMPORTANCIA VARIABLES
  # -------------------------------


  output$importance <- renderPlot({


    grafico_importancia(
      datos()
    )


  })





}





# =====================================
# EJECUTAR APP
# =====================================


shinyApp(
  ui,
  server
)