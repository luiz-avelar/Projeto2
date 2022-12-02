vars <- c("Serviço.Err", "Serviço.Ace", "Recepção.Tot", "Recepção.Err", "Ataque.Exc.", "Ataque.Err", "Ataque.Blk", "Bloqueio.Pts")

   


ui <- navbarPage(
  
  theme = bslib::bs_theme(primary = "#5F2A90", secondary = "#90E124", success = "#DFB60B", bootswatch = "flatly"),
  
  "Superliga Brasileira de Voleibol Feminino (21/22)",
  tabPanel("Jogadoras",
           tabsetPanel(
             tabPanel("Recepcao", plotOutput("plot1", brush = "plot_brush"), tableOutput("table2"))
           ),
           
           tabsetPanel(
             sidebarPanel(
               selectInput('ycol','Y Variable', vars),
               selected = "Serviço.Ace"
            ),
            tabPanel("Stats",
               plotlyOutput('plot')
             )
           )
  ),
  tabPanel("Times",
           h3("Quantidade de vitórias por time"),
           tabPanel("teste",dataTableOutput("tabela"))
  )
  
)

