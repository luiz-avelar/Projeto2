library(shiny)
library(tidyverse)
library(DT)
library(plotly)
library(glue)
library(scales)
library(readr)

base <- read_csv("superliga_202122.csv", locale=locale(encoding="latin1"))
names(base) <- c("SET_1","SET_2","SET_3","SET_4","SET_5","Jogadora","Time","Partida","Vencedor","Servico_Err","Servico_Ace","Recepcao_Tot","Recepcao_Err","Ataque_Exc","Ataque_Err","Ataque_Blk","Bloqueio_Pts","Fase","Cat","Jogo","VV")

server <- function(input, output, session) {
  
  # Aba de times
  ##
  df_stats_team <-  base |> 
    group_by(Time) |>
    summarise(
      recepcoes_total = sum(Recepcao_Tot, na.rm = T), 
      recepcoes_erro = sum(Recepcao_Err, na.rm = T),
      recepcoes_prop = recepcoes_erro / recepcoes_total,
      ataques_total = sum(Ataque_Exc, na.rm = T), 
      ataques_erro = sum(Ataque_Err, na.rm = T),
      ataques_prop = ataques_erro / ataques_total
    )
  
  df_chosen_team <- reactive({
    df_stats_team |>
      select(
        Time,
        glue(input$stat_team, '_total'),
        glue(input$stat_team, '_erro'),
        glue(input$stat_team, '_prop')
      ) |>
      rename(
        quantidade_tentativas = glue(input$stat_team, '_total'),
        quantidade_erros = glue(input$stat_team, '_erro'),
        proporcao = glue(input$stat_team, '_prop')
      ) |>
      filter(quantidade_tentativas > 0)
  })
  
  output$plot3 <- renderPlot({
    ggplot(df_chosen_team(), mapping = aes(x = quantidade_tentativas, y = quantidade_erros)) +
      geom_point() + 
      labs(
        x = "Quantidade de Tentativas",
        y = "Quantidade de Erros"
      )
  })
  
  output$table_click <- renderUI({
    if(is.null(input$plot_click)){
      h4("Clique em um ponto no gráfico para informações detalhadas")
    } else {
      renderTable({
        nearPoints(df_chosen_team(), input$plot_click)
      })
    }
  })
  ##
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
    
    base |> filter(Fase != filtro) |> group_by(Time) |> summarise(VV = sum(VV)) |> arrange(desc(VV)) |> filter(VV > 0)
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
        ) |>
        filter(quantidade_tentativas > 0)
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
      h4("Destaque uma área no gráfico para informações detalhadas")
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
    
    base |> filter(Fase != filtro) |> group_by(Jogadora, Time) |> summarise(VV = sum(VV)) |> arrange(desc(VV)) |> filter(VV > 0)
  })
  
    df_jogos <- base |>
      mutate(
        titular = case_when(
          !SET_1 %in% c('*', "") ~ TRUE,
           SET_1 %in% c('*', "") ~ FALSE
        )
      ) |>
      group_by(Jogadora) |>
      summarise(
        total_jogos = n_distinct(Jogo),
        titular_jogos = sum(titular),
        proporcao = titular_jogos / total_jogos
      )
    
    output$plot2 <- renderPlot({
      ggplot(df_jogos, mapping = aes(x = total_jogos, y = titular_jogos)) +
        geom_point() + 
        labs(
          x = "Número de jogos",
          y = "Número de jogos como titular"
        )
    })
    
    output$plot2_brush <- renderUI({
      if(is.null(input$brush_quantidade_jogos)){
        h4("Destaque uma área no gráfico para informações detalhadas")
      } else {
        renderTable({
          brushedPoints(df_jogos, input$brush_quantidade_jogos)
        })
      }
    })

  # Aba geral
  
  df_fund <-  base |> 
    mutate(
      Cat = factor(Cat, levels = c("turno", "returno", "quartas", "semi", "final"))
    ) |>
    group_by(Partida, Cat) |>
    summarise(
      Pontos_bloqueio = sum(Bloqueio_Pts, na.rm = TRUE),
      Ataques_bloqueados = sum(Ataque_Blk, na.rm = TRUE),
      Aces = sum(Servico_Ace, na.rm = TRUE)
    ) |>
    select(
      Cat,
      Pontos_bloqueio,
      Ataques_bloqueados,
      Aces
    )
  
  filtro_fund <- reactive({
    switch(input$fundamento_geral,
           "Pontos de Bloqueio" = "Pontos_bloqueio",
           "Ataques Bloqueados" = "Ataques_bloqueados",
           "Aces" = "Aces"
    )
  })
  
  output$boxplot1 <- renderPlot({
    ggplot(df_fund) + aes(x= Cat,y= eval(parse(text = filtro_fund()))) +
      geom_boxplot() + 
      labs(
        x = "Fase secundária do torneio",
        y = "Quantidade"
      )
  })
  
  df_sets <- base |>
    select(SET_1, SET_2, SET_3, SET_4, SET_5, Cat, Partida) |>
    mutate(
      SET_4 = case_when(SET_4 == "" ~ FALSE, TRUE ~ TRUE),
      SET_5 = case_when(SET_5 == "" ~ FALSE, TRUE ~ TRUE)
    ) |>
    group_by(Partida, Cat) |>
    summarise(
      qtd_sets_5 = sum(SET_5),
      qtd_sets_4 = sum(SET_4)
    ) |>
    group_by(Partida, Cat) |>
    summarise(
      qtd_sets = case_when(
        qtd_sets_5 > 0 ~ "Cinco",
        qtd_sets_4 > 0 ~ "Quatro",
        TRUE ~ "Três"
      )
    )

  df_set_choices <- reactive({
    filtro_turno   <- case_when(input$check_turno   == FALSE ~ "", TRUE ~ "turno")
    filtro_returno <- case_when(input$check_returno == FALSE ~ "", TRUE ~ "returno")
    filtro_quartas <- case_when(input$check_quartas == FALSE ~ "", TRUE ~ "quartas")
    filtro_semi    <- case_when(input$check_semi    == FALSE ~ "", TRUE ~ "semi")
    filtro_final   <- case_when(input$check_final   == FALSE ~ "", TRUE ~ "final")
    
    df_sets |>
      filter(
        Cat %in% c(filtro_turno, filtro_returno, filtro_quartas, filtro_semi, filtro_final)
      ) |>
      mutate(
        qtd_sets = factor(qtd_sets, levels = c("Três", "Quatro", "Cinco"))
      )
  })
  
  output$barplot1 <- renderPlot({
    ggplot(data = df_set_choices(), aes(x = qtd_sets)) +
      geom_bar(aes(y = (..count..)/sum(..count..))) + 
      labs(
        x = "Quantidade de sets",
        y = "Porcentagem"
      ) +
      scale_y_continuous(labels = percent)
  })
    
}
