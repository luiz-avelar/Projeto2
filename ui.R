vars <- c("Servico_Err","Servico_Ace","Recepcao_Tot","Recepcao_Err","Ataque_Exc","Ataque_Err","Ataque_Blk","Bloqueio_Pts")
   
ui <- navbarPage(
  
  theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
  
  "Superliga Brasileira de Voleibol Feminino (21/22)",
  tabPanel("Jogadoras",
           tabsetPanel(
             h3("Quantidade de Erros de recepção por recepções tentadas"),
             h6("Destaque um ponto para informações detalhadas"),
             tabPanel("Recepção", plotOutput("plot1", brush = "plot_brush"), tableOutput("table2"))
           ),
           
           tabsetPanel(
             sidebarPanel(
               selectInput('ycol','Y Variable', vars),
               selected = "Servico_Ace"
            ),
            tabPanel("Stats",
               plotlyOutput('plot')
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

