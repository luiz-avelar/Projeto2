library(shiny)
library(tidyverse)
library(DT)
library(plotly)

base <- read.csv("superliga_202122.csv")
names(base) <- c("SET_1","SET_2","SET_3","SET_4","SET_5","Jogadora","Time","Partida","Vencedor","Servico_Err","Servico_Ace","Recepcao_Tot","Recepcao_Err","Ataque_Exc","Ataque_Err","Ataque_Blk","Bloqueio_Pts","Fase","Cat","Jogo","VV")

server <- function(input, output, session) {
  
  # Aba de times
  output$tabela1 <- renderDataTable({
    filtro <- switch(input$fase_vitorias,
                   "classificatoria" = "playoffs",
                   "playoffs" = "classificatoria",
                   "Ambas" = ""
                   )
    
    base|> filter(Fase != filtro) |> group_by(Vencedor) |> summarise(Vitorias = n_distinct(Partida)) |> rename(Time = Vencedor) |> arrange(desc(Vitorias))
  })
  
  output$tabela2 <- renderDataTable({
    filtro <- switch(input$fase_vv,
                     "classificatoria" = "playoffs",
                     "playoffs" = "classificatoria",
                     "Ambas" = ""
    )
    
    base |> filter(Fase != filtro) |> group_by(Time) |> summarise(VV = sum(VV)) |> arrange(desc(VV))
  })
  
  # Aba jogadoras
  
  df_stats <-  base |> 
    group_by(Jogadora, Time) |>
    summarise(
      recepcoes_total = sum(Recepcao_Tot, na.rm = T), 
      recepcoes_erro = sum(Recepcao_Err, na.rm = T),
      recepcoes_prop = recepcoes_erro / recepcoes_total,
      ataques_total = sum(Ataque_Exc, na.rm = T), 
      ataques_erro = sum(Ataque_Err, na.rm = T),
      ataques_prop = ataques_erro / ataques_total
    )

    df_chosen <- reactive({
      df_stats |>
        select(
          glue(input$stat, '_total'),
          glue(input$stat, '_erro'),
          glue(input$stat, '_prop')
        ) |>
        rename(
          quantidade_tentativas = glue(input$stat, '_total'),
          quantidade_erros = glue(input$stat, '_erro'),
          proporcao = glue(input$stat, '_prop')
        )
    })
    
  output$plot1 <- renderPlot({
    ggplot(df_chosen(), mapping = aes(x = quantidade_tentativas, y = quantidade_erros)) +
      geom_point() + 
      labs(
        x = "Quantidade de Tentativas",
        y = "Quantidade de Erros"
      )
  })
  
  output$table_brush <- renderUI({
    if(is.null(input$plot_brush)){
      h4("Destaque uma área no gráfico informações detalhadas")
    } else {
      renderTable({
        brushedPoints(df_chosen(), input$plot_brush)
      })
    }
  })
  
  output$tabela3 <- renderDataTable({
    filtro <- switch(input$fase_vv_jogadora,
                     "classificatoria" = "playoffs",
                     "playoffs" = "classificatoria",
                     "Ambas" = ""
    )
    
    base |> filter(Fase != filtro) |> group_by(Jogadora, Time) |> summarise(VV = sum(VV)) |> arrange(desc(VV))
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