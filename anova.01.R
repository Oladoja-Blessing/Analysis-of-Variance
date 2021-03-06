################################################################################
library(shiny)
library(shinydashboard)
################################################################################
ui <- dashboardPage(
  
  dashboardHeader(title = "Analysis of Variance"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("One-way ANOVA",
               tabName = "one"),
      menuItem("Two-way ANOVA",
               tabName = "two"),
      menuItem("Latin square Anova",
               tabName = "latin")
      
    )
  ),
  
  dashboardBody(
    tabItems(
################################################################################      
      tabItem(tabName = "one",
              sidebarLayout(
                sidebarPanel(
                  fileInput("csv_input","Choose input file",
                            accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv"),buttonLabel = "Upload..."
                            
                  ),
                  selectInput("value_one","Observation",""),
                  selectInput("trt_one", "Treatment",""),
                  selectInput("follow_1","Choose follow up test",
                              choices = c("LSD","HSD","Duncan")),
                  selectInput("focus","select focus",""),
                  submitButton("Apply Change", icon("refresh"))
                ),
######################################################                
                mainPanel(
                  tabsetPanel(
                    type = "tab",
                    tabPanel("Data", tableOutput("one_data")
                             
                    ),
                    tabPanel("Analysis of Variance",
                             verbatimTextOutput("aov_one"),
                             downloadButton("downloadaov_one",
                                            "Download result")),
                    tabPanel("Follow up Test",
                             plotOutput("fut_one"),
                             downloadButton("downloadfut_one",
                                            "Download plot"),
                             tableOutput("fut_table_one"),
                             downloadButton("downloadfut_table_one",
                                            "Download table")
                    )
                  )
                )
              )
      ),
################################################################################      
      tabItem(tabName = "two",
              sidebarLayout(
                sidebarPanel(
                  fileInput("csv_input_two","Choose input file",
                            accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv")),
                  selectInput("value_two","Observation",""),
                  selectInput("trt_two", "Treatment",""),
                  selectInput("block", "Block",""),
                  selectInput("follow_2","Choose follow up test",
                              choices = c("LSD","HSD","Duncan")),
                  selectInput("focus_2","Select focus",""),
                  submitButton("Apply Change",icon("refresh"))
                ),
########################################################                
                mainPanel(
                  tabsetPanel(
                    type = "tab",
                    tabPanel("Data", tableOutput("two_data")
                    ),
                    tabPanel("Analysis of Variance",
                             verbatimTextOutput("aov_two"),
                             downloadButton("downloadaov_two",
                                            "Download result")),
                    tabPanel("Follow up Test",
                             plotOutput("fut_two"),
                             downloadButton("downloadfut_two",
                                            "Download plot"),
                             tableOutput("fut_table_two"),
                             downloadButton("downloadfut_table_two",
                                            "Download table")
                    )
                  )
                )
              )
      ),
################################################################################     
       tabItem(tabName = "latin",
              sidebarLayout(
                sidebarPanel(
                  fileInput("csv_input_three","Choose input file",
                            accept = c(
                              "text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv")),
                  selectInput("value_three","Observation",""),
                  selectInput("trt_three", "Treatment",""),
                  selectInput("row", "Row",""),
                  selectInput("col", "Column",""),
                  selectInput("follow_3","Choose follow up test",
                              choices = c("LSD","HSD","Duncan")),
                  selectInput("focus_3","Select focus",""),
                  submitButton("Apply Change",icon("refresh"))
                ),
########################################################                
                mainPanel(
                  tabsetPanel(
                    type = "tab",
                    tabPanel("Data", tableOutput("latin_data")
                    ),
                    tabPanel("Analysis of Variance",
                             verbatimTextOutput("aov_three"),
                             downloadButton("downloadaov_three",
                                            "Download result")),
                    tabPanel("Follow up Test",
                             plotOutput("fut_three"),
                             downloadButton("downloadfut_three",
                                            "Download plot"),
                             tableOutput("fut_table_three"),
                             downloadButton("downloadfut_table_three",
                                            "Download table")
                                                )
                  )
                )
              )
      )
    )
  )
)
################################################################################
server <- function(input, output, session) {
################################################################################  
  load_data <- function(df){
    req(df)
    infile <- df
    datas <- infile$datapath
    read.csv(datas)
  }
################################################################################   
  output$one_data <- renderTable(load_data(input$csv_input))
  output$two_data <- renderTable(load_data(input$csv_input_two))
  output$latin_data <- renderTable(load_data(input$csv_input_three))
################################################################################
  reactives <- reactiveValues(
    
    mydata = NULL
    
  )
  observeEvent(input$csv_input, {
    
    #Store loaded data in reactive
    reactives$mydata <- read.csv(file = input$csv_input$datapath)
    
    #Update select input
    updateSelectInput(session, inputId = 'focus', label = 'select focus', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'value_one', label = 'Observation', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'trt_one', label = 'Treatment', choices  = colnames(reactives$mydata))
  })
  
  reactive <- reactiveValues(
    
    mydata = NULL
    
  )
  observeEvent(input$csv_input_two, {
    
    #Store loaded data in reactive
    reactives$mydata <- read.csv(file = input$csv_input_two$datapath)
    
    #Update select input
    updateSelectInput(session, inputId = 'focus_2', label = 'select focus', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'value_two', label = 'Observation', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'trt_two', label = 'Treatment', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'block', label = 'Block', choices  = colnames(reactives$mydata))
    })  
  
  reactive <- reactiveValues(
    
    mydata = NULL
    
  )
  observeEvent(input$csv_input_three, {
    
    #Store loaded data in reactive
    reactives$mydata <- read.csv(file = input$csv_input_three$datapath)
    
    #Update select input
    updateSelectInput(session, inputId = 'focus_3', label = 'select focus', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'value_three', label = 'Observation', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'trt_three', label = 'Treatment', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'row', label = 'Row', choices  = colnames(reactives$mydata))
    updateSelectInput(session, inputId = 'col', label = 'Column', choices  = colnames(reactives$mydata))
  }) 
  
################################################################################
  one <- function(){
    datas <- load_data(input$csv_input)
    Treatment <- datas[,input$trt_one]
    aov(datas[,input$value_one] ~ Treatment, data = datas)
  }
  two <- function(){
    datas <- load_data(input$csv_input_two)
    Treatment <- datas[,input$trt_two]
    Block <- datas[,input$block]
    aov(datas[,input$value_two]~ Treatment + Block,data = datas)
  }
  latin <- function(){
    datas <- load_data(input$csv_input_three)
    Treatment <- datas[,input$trt_three]
    Row <- datas[,input$row]
    Column <- datas[,input$col]
    aov(datas[,input$value_three] ~ Treatment + Row + Column
        ,data = datas)
  }
################################################################################  
  output$aov_one <- renderPrint(broom::tidy(one())
  )
  
  output$aov_two <- renderPrint(broom::tidy(two())
   )
  

  output$aov_three <- renderPrint(broom::tidy(latin())  
  )
################################################################################  
  output$downloadaov_one <- downloadHandler(
    filename = function(){
      paste("aov","csv",sep = ".")
    } ,
    content = function(file){
      write.csv((broom::tidy(one())),file)
    }
  )
  output$downloadaov_two <- downloadHandler(
    filename = function(){
      paste("aov","csv",sep = ".")
    } ,
    content = function(file){
      write.csv((broom::tidy(two())),file)
    }
  )
  output$downloadaov_three <- downloadHandler(
    filename = function(){
      paste("aov","csv",sep = ".")
    } ,
    content = function(file){
      write.csv((broom::tidy(latin())),file)
    }
  )
################################################################################
lsd_plot <- function(dd,id){
  plot(agricolae::LSD.test(dd, id,p.adj = "bonferroni"))
}
hsd_plot <- function(dd,id){
  plot(agricolae::HSD.test(dd, id))
}
dun_plot <- function(dd,id){
  plot(agricolae::duncan.test(dd,id))
}
follow_up <- function(anov){
  switch (anov,
    LSD = lsd_plot(),
    HSD = hsd_plot(),
    Duncan = dun_plot()
  )
} 
################################################################################

  output$fut_one <- renderPlot({
    datas <- load_data(input$csv_input)
    dd.aov <- aov(as.formula(paste("datas[,input$value_one]~",
                                   input$trt_one)), data = datas)
    switch (input$follow_1,
            LSD = lsd_plot(dd.aov,input$focus),
            HSD = hsd_plot(dd.aov,input$focus),
            Duncan = dun_plot(dd.aov,input$focus))
    })
  output$fut_two <- renderPlot({
    datas <- load_data(input$csv_input_two)
    dd.aov <- aov(as.formula(paste("datas[,input$value_two]~",input$trt_two,"+", input$block)), data = datas)
    switch (input$follow_2,
            LSD = lsd_plot(dd.aov,input$focus_2),
            HSD = hsd_plot(dd.aov,input$focus_2),
            Duncan = dun_plot(dd.aov,input$focus_2)
    )
  }) 
  output$fut_three <- renderPlot({
    datas <- load_data(input$csv_input_three)
    dd.aov <- aov(as.formula(paste("datas[,input$value_three]~",
                                   input$trt_three,"+", input$row,
                                   "+",input$col)),
                  data = datas)
    switch (input$follow_3,
            LSD = lsd_plot(dd.aov,input$focus_3),
            HSD = hsd_plot(dd.aov,input$focus_3),
            Duncan = dun_plot(dd.aov,input$focus_3)
    )
  })
################################################################################
output$downloadfut_one <- downloadHandler(
  filename = function(){
    switch (input$follow_1,
            LSD = paste("lsd_plot",".jpeg",sep = ""),   
            HSD = paste("hsd_plot",".jpeg",sep = ""),
            Duncan = paste("duncan_plot",".jpeg",sep = ""))
  },
  content = function(file){
    jpeg(file,width = 900,height = 450)
    datas <- load_data(input$csv_input)
    dd.aov <- aov(as.formula(paste("datas[,input$value_one]~",
                                   input$trt_one)), data = datas)
    switch (input$follow_1,
            LSD = lsd_plot(dd.aov,input$focus),
            HSD = hsd_plot(dd.aov,input$focus),
            Duncan = dun_plot(dd.aov,input$focus)
    )
      dev.off()
  }
)
  output$downloadfut_two <- downloadHandler(
    filename = function(){
      switch (input$follow_2,
              LSD = paste("lsd_plot",".jpeg",sep = ""),   
              HSD = paste("hsd_plot",".jpeg",sep = ""),
              Duncan = paste("duncan_plot",".jpeg",sep = ""))
    },
    content = function(file){
      jpeg(file,width = 900,height = 450)
      datas <- load_data(input$csv_input_two)
      dd.aov <- aov(as.formula(paste("datas[,input$value_two]~",input$trt_two,"+", input$block)), data = datas)
      switch (input$follow_2,
              LSD = lsd_plot(dd.aov,input$focus_2),
              HSD = hsd_plot(dd.aov,input$focus_2),
              Duncan = dun_plot(dd.aov,input$focus_2)
      )
      dev.off()
    }
  )
  output$downloadfut_three <- downloadHandler(
    filename = function(){
      switch (input$follow_3,
              LSD = paste("lsd_plot",".jpeg",sep = ""),   
              HSD = paste("hsd_plot",".jpeg",sep = ""),
              Duncan = paste("duncan_plot",".jpeg",sep = ""))
    },
    content = function(file){
      jpeg(file,width = 900,height = 450)
      datas <- load_data(input$csv_input_three)
      dd.aov <- aov(as.formula(paste("datas[,input$value_three]~",
                                     input$trt_three,"+", input$row,
                                     "+",input$col)),
                    data = datas)
      switch (input$follow_3,
        LSD = lsd_plot(dd.aov,input$focus_3),
        HSD = hsd_plot(dd.aov,input$focus_3),
        Duncan = dun_plot(dd.aov,input$focus_3)
      )
      dev.off()
    }
  )
################################################################################
  lsd_t <- function(dd,id){
    agricolae::LSD.test(dd, id,p.adj = "bonferroni")
  }
  hsd_t <- function(dd,id){
    agricolae::HSD.test(dd, id)
  }
  dun_t <- function(dd,id){
    agricolae::duncan.test(dd, id)
  }
   
################################################################################
  output$fut_table_one <- renderTable({
    datas <- load_data(input$csv_input)
    dd.aov <- aov(as.formula(paste("datas[,input$value_one]~",
                                   input$trt_one)), data = datas)
    tt <- switch (input$follow_1,
                  LSD = lsd_t(dd.aov,input$focus),
                  HSD = hsd_t(dd.aov,input$focus),
                  Duncan = dun_t(dd.aov,input$focus)
    )
    cc <-  as.data.frame(tt[["groups"]])
    names(cc) <- c("average","groups")
    cc
  })
  output$fut_table_two <- renderTable({
    datas <- load_data(input$csv_input_two)
    dd.aov <- aov(as.formula(paste("datas[,input$value_two]~",input$trt_two,"+", input$block)), data = datas)
    tt <- switch (input$follow_2,
                  LSD = lsd_t(dd.aov,input$focus_2),
                  HSD = hsd_t(dd.aov,input$focus_2),
                  Duncan = dun_t(dd.aov,input$focus_2)
    )
    cc <-  as.data.frame(tt[["groups"]])
    names(cc) <- c("average","groups")
    cc
  })
  output$fut_table_three <- renderTable({
    datas <- load_data(input$csv_input_three)
    dd.aov <- aov(as.formula(paste("datas[,input$value_three]~",
                                   input$trt_three,"+", input$row,
                                   "+",input$col)),
                  data = datas)
    tt <- switch (input$follow_3,
      LSD = lsd_t(dd.aov,input$focus_3),
      HSD = hsd_t(dd.aov,input$focus_3),
      Duncan = dun_t(dd.aov,input$focus_3)
    )
    cc <-  tt[["groups"]]
    names(cc) <- c("average","groups")
    cc
  })
################################################################################
output$downloadfut_table_one <- downloadHandler(
  filename = function(){
    switch (input$follow_1,
      LSD = paste("lsd_table","csv",sep = "."),   
      HSD =  paste("hsd_table","csv",sep = "."),
      Duncan =  paste("duncan_table","csv",sep = "."))
   
  },
  content = function(file){
  datas <- load_data(input$csv_input)
  dd.aov <- aov(as.formula(paste("datas[,input$value_one]~",
                                 input$trt_one)), data = datas)
  tt <- switch (input$follow_1,
    LSD = lsd_t(dd.aov,input$focus),
    HSD = hsd_t(dd.aov,input$focus),
    Duncan = dun_t(dd.aov,input$focus)
  )
  result <-  tt[["groups"]]
  names(result) <- c("average","groups")
  result
  write.csv(result,file)
  }
)
  output$downloadfut_table_two <- downloadHandler(
    filename = function(){
      switch (input$follow_2,
              LSD = paste("lsd_table","csv",sep = "."),   
              HSD =  paste("hsd_table","csv",sep = "."),
              Duncan =  paste("duncan_table","csv",sep = "."))
      
    },
    content = function(file){
      datas <- load_data(input$csv_input_two)
      dd.aov <- aov(as.formula(paste("datas[,input$value_two]~",input$trt_two,"+", input$block)), data = datas)
      tt <- switch (input$follow_2,
        LSD = lsd_t(dd.aov,input$focus_2),
        HSD = hsd_t(dd.aov,input$focus_2),
        Duncan = dun_t(dd.aov,input$focus_2)
      )
      result <-  tt[["groups"]]
      names(result) <- c("average","groups")
      result
      write.csv(result,file)
    }
  )
  output$downloadfut_table_three <- downloadHandler(
    filename = function(){
      switch (input$follow_3,
              LSD = paste("lsd_table","csv",sep = "."),   
              HSD =  paste("hsd_table","csv",sep = "."),
              Duncan =  paste("duncan_table","csv",sep = "."))
      
    },
    content = function(file){
      datas <- load_data(input$csv_input_three)
      dd.aov <- aov(as.formula(paste("datas[,input$value_three]~",
                                     input$trt_three,"+", input$row,
                                     "+",input$col)),
                    data = datas)
      tt <- switch (input$follow_3,
        LSD = lsd_t(dd.aov,input$focus_3),
        HSD = hsd_t(dd.aov,input$focus_3),
        Duncan = dun_t(dd.aov,input$focus_3)
      )
      result <-  tt[["groups"]]
      names(result) <- c("average","groups")
      result
      write.csv(result,file)
    }
  )
}

shinyApp(ui = ui,server = server)

