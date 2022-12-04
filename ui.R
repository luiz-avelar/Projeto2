stats <- c("recepcoes", "ataques")
   
ui <- navbarPage(
  
  theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
  
  "Superliga Brasileira de Voleibol Feminino (21/22)",
  tabPanel("Sobre",
    fluidRow(
      p("O banco de dados “Brazilian Volleyball Superliga 2021/22 (Women)”, disponível", a("na plataforma Kaggle", href="https://www.kaggle.com/datasets/smnlgn/superliga-202122"), "é um banco de dados que contém informações estatísticas de todas as jogadoras para cada partida disputada na Superliga Feminina 2021/22, que é o Campeonato Brasileiro Interclubes, organizado pela Confederação Brasileira de Clubes.")
    ),
    p("Essa base de informações está disponibilizada em formato csv, com tamanho aproximado de 501Kb. O banco é composto por 21 variávies e 3161 observações, sendo elas desde o primeiro jogo realizado em 28/10/2021 entre Brasília Vôlei e Maringá Vôlei, até o segundo jogo da grande final entre Minas Tênis Clube e Praia Clube no dia 29/04/2022."),
    p("Dentre as variávies, pode-se destacar:"),
    tags$ul(
      tags$li("Equipe vencedora;"),
      tags$li("Jogadora;"),
      tags$li("Quantidade de aces feitos;"),
      tags$li("Quantidade de servições desperdiçados;"),
      tags$li("Pontos de bloqueio;"),
      tags$li("Quantidade de ataques executados e errados;"),
      tags$li("Quantidade de recepções executadas e erradas;"),
      tags$li("Fase da partida (Playoff, Classificatória;"),
      tags$li("Posição em que a jogadora iniciou o set.")
    ),
    p("Apesar de ser um banco de dados bem completo, algumas informações relevantes, tais como a posição da jogadora, quantidade de pontos feitos e o vencedor de cada set não estavam presentes no dataset. Estas variáveis poderiam ser interessantes para análises mais completas."),
    p("O Shiny dashboard desenvolvido a partir deste banco de dados leva em consideração o formado do mesmo, por isso foi dividido em três abas:"), 
    tags$ul(
      tags$li(tags$strong("Times:"), "análises levando em consideração o agrupamento por time;"),
      tags$li(tags$strong("Jogadoras:"), "análises levando em consideração o agrupamento por jogadora;"),
      tags$li(tags$strong("Geral:"), "análises gerais sobre todo o conjunto de dados.")
    )
  ),
  
  tabPanel("Jogadoras",
    
     navbarPage(
       theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
       "Análises",
       
       tabPanel("Tentativas e erros",
           h3("Quantidade de tentativas e erros por fundamento"),
           h6("Selecione um fundamento"),
           sidebarPanel(
             selectInput('stat','Fundamento', stats),
             selected = "ataques"
           ),
           plotOutput("plot1", brush = "plot_brush"),
           uiOutput("table_brush")
      ),
      
       tabPanel('Quantidade de jogos', 
                h3("Quantidade de jogos por jogadora"),
                plotOutput("plot2", brush = "brush_quantidade_jogos"),
                uiOutput("plot2_brush")
          ),
      
      tabPanel("Melhor da partida",
               h3("Quantidade de prêmios de melhor jogadora da partida por jogadora"),
               h4("O prêmio VivaVolêi(VV) é dado a melhor jogadora no final de cada partida"),
               radioButtons("fase_vv_jogadora", "Selecione a fase do torneio:",
                            c("Classificatória" = "classificatoria",
                              "Playoff" = "playoffs",
                              "Ambas" = "Ambas")),
               tabPanel("tabela3", dataTableOutput("tabela3"))
      )
      
    )
  ),
  
  tabPanel("Times",
           
    navbarPage(
      theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
      "Análises",
      tabPanel("Tentativas e erros",
               h3("Quantidade de tentativas e erros por fundamento"),
               h6("Selecione um fundamento"),
               sidebarPanel(
                 selectInput('stat_team','Fundamento', stats),
                 selected = "ataques"
               ),
               plotOutput("plot3", click = "plot_click"),
               uiOutput("table_click")
      ),
      tabPanel("Vitórias",
         h3("Quantidade de vitórias por time"),
         radioButtons("fase_vitorias", "Selecione a fase do torneio:",
                      c("Classificatória" = "classificatoria",
                        "Playoff" = "playoffs",
                        "Ambas" = "Ambas")),
         tabPanel("tabela1", dataTableOutput("tabela1"))
      ),
      
      tabPanel("Melhor da partida",
       h3("Quantidade de prêmios de melhor jogadora da partida por time"),
       h4("O prêmio VivaVolêi(VV) é dado a melhor jogadora no final de cada partida"),
       radioButtons("fase_vv", "Selecione a fase do torneio:",
                    c("Classificatória" = "classificatoria",
                      "Playoff" = "playoffs",
                      "Ambas" = "Ambas")),
       tabPanel("tabela2", dataTableOutput("tabela2"))
      )
    ) 
  ),
  
  tabPanel("Geral",
     navbarPage(
       theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
       "Análises",
       tabPanel("Fundamentos por fase",
                h3("Média dos fundamentos por partida em cada fase secundária do torneio"),
                h6("Selecione um fundamento"),
                sidebarPanel(
                  selectInput('fundamento_geral', label = 'Fundamento', choices = c("Pontos de Bloqueio", "Ataques Bloqueados", "Aces")),
                  selected = "Aces"
                ),
                plotOutput("boxplot1")
       ),
       tabPanel("Sets por fase",
                h3("Frequência de cada set por fase secundária do torneio"),
                h6("Selecione quais fases considerar"),
                sidebarPanel(
                  checkboxInput('check_turno', label = 'turno', value = TRUE),
                  checkboxInput('check_returno', label = 'returno', value = FALSE),
                  checkboxInput('check_quartas', label = 'quartas', value = FALSE),
                  checkboxInput('check_semi', label = 'semi', value = FALSE),
                  checkboxInput('check_final', label = 'final',  value = FALSE)
                ),
                plotOutput("barplot1")
       )
     ) 
  )
)

