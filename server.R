library(shiny)
library(tidyverse)
library(DT)
library(plotly)

base <- read.csv("superliga_202122.csv")
names(base) <- c("SET_1","SET_2","SET_3","SET_4","SET_5","Jogadora","Time","Partida","Vencedor","Servico_Err","Servico_Ace","Recepcao_Tot","Recepcao_Err","Ataque_Exc","Ataque_Err","Ataque_Blk","Bloqueio_Pts","Fase","Cat","Jogo","VV")

server <- function(input, output, session) {
  
  # Aba de times
  output$tabela1 <- renderDataTable({
    base|> group_by(Vencedor) |> summarise(Vitorias = n_distinct(Partida)) |> rename(Time = Vencedor) |> arrange(desc(Vitorias))
  })
  
  output$tabela2 <- renderDataTable({
    base|> group_by(Time) |> summarise(VV = sum(VV)) |> arrange(desc(VV))
  })
  
  # Aba jogadoras
  
  Rec <-  base |> 
    group_by(Jogadora, Time) %>%
    summarise(Quantidade_de_Recepções = sum(Recepcao_Tot, na.rm = T), Erros_de_Recepção = sum(Recepcao_Err, na.rm = T)) %>%
    mutate('Proporção entre Erros e Recepções' = Erros_de_Recepção / Quantidade_de_Recepções) %>%
    filter(Quantidade_de_Recepções > 100)
  
  output$plot1 <- renderPlot({
    ggplot(Rec, mapping = aes(x = Quantidade_de_Recepções, y = Erros_de_Recepção)) +
      geom_point()
  })
  
  output$table2 <- renderTable({
    brushedPoints(Rec, input$plot_brush)
  })
  
# Rererência: https://community.plotly.com/t/incorporate-a-plotly-graph-into-a-shiny-app/5329
  
  y <- reactive({
    base[,input$ycol]
  })
  
  output$plot <- renderPlotly(
    plot1 <- plot_ly(
      y = y(),
      x = base$Jogo, 
      type = 'scatter',
      mode = 'markers')
  )
}