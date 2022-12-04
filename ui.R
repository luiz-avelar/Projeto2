stats <- c("recepcoes", "ataques")
   
ui <- navbarPage(
  
  theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
  
  "Superliga Brasileira de Voleibol Feminino (21/22)",
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
      
       tabPanel('Tentativa',
         tabsetPanel(
           sidebarPanel(
             selectInput('stat','Estatística', stats),
             selected = "ataques"
          ),
          tabPanel("Stats",
             plotlyOutput('plot')
           )
         )
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
  )
)

