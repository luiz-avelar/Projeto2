stats <- c("recepcoes", "ataques")
   
ui <- navbarPage(
  
  theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
  
  "Superliga Brasileira de Voleibol Feminino (21/22)",
  tabPanel("Jogadoras",
    
     navbarPage(
       theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
       "Análises",
       
       tabPanel("Tentativas e erros",
           h3("Quantidade de tentativas e erros por estatística"),
           h6("Destaque um ponto para informações detalhadas"),
           sidebarPanel(
             selectInput('stat','Estatística', stats),
             selected = "ataques"
           ),
           plotOutput("plot1", brush = "plot_brush"),
           uiOutput("table_brush")
           # tableOutput("table1")
           # plotOutput("plot1", brush = "plot_brush"), 
           # tableOutput("table1")
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
       )
    )
  ),
           
  tabPanel("Times",
           
           h3("Quantidade de vitórias por time"),
           tabPanel("tabela1", dataTableOutput("tabela1")),
           
           h3("Quantidade de prêmios de melhor jogadora da partida por time"),
           tabPanel("tabela2", dataTableOutput("tabela2")),
  )
  
)

