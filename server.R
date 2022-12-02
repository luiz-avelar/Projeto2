library(shiny)
library(tidyverse)
library(readr)
library(DT)
library(stringr)

base <- read.csv("superliga_202122.csv")

server <- function(input, output, session) {
  
  output$tabela <- renderDataTable({
    base|>group_by(Vencedor) |> summarise(Vitorias = n_distinct(Partida)) |> rename(Time = Vencedor) |> arrange(desc(Vitorias))
  })
  
  output$plot1 <- renderPlot({
    ggplot(Rec, mapping = aes(x = Recepcao_Total, y = Erro_Recepcao)) +
      geom_point()
  })
  
  output$table2 <- renderTable({
    brushedPoints(Rec, input$plot_brush)
  })
  
}