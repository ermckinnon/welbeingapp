
# This is the user-interface definition of a Shiny web application.
# The web application is to compare the user's wellbeing with those in different careers


library(shiny)
library(xlsx)

#Download wellbeing file
#url = "http://whatworkswellbeing.files.wordpress.com/2016/03/wellbeing-by-standard-occupations_2012-15_final.xlsx"
#download.file(url, destfile="./wellbeingdata.xlsx",mode='wb',cacheOK = FALSE)
data <- read.xlsx("./wellbeingdata.xlsx",sheetName="SOC3_Wellbeing",header=TRUE,)
#Remove missing data
data <- data[-c(37,42),]
#Sort by occupation
data <- data[order(data$Standard.Occupation.Code..SOC....Minor.Group),]

shinyUI(fluidPage(

  # Comparing Wellbeing
  titlePanel("Happy Jobs! - How does your well-being compare to people in different jobs in the UK?"),
  
  tags$p(id="intro1",
           'There has been much interest in well-being in recent years. We can now measure personal well-being through simple survey questions. 
           This application asks two such questions on Life Satisfaction and Sense of Worthwhile that are being measured at a population level
           by the Office of National Statistics in the UK. Recent data released by the What Works Centre for Well-being in the UK presents 
           average responses to these questions for people working in different occupations - see the source data at the link below.'),
  tags$p(id="intro2",
           'In this application you can explore the data by answering the survey questions, and then picking two types of career from the standard international list of occupations. 
           Pick two occupations that you would like to compare - perhaps your current chosen career, with something else you would have liked to pursue or 
           will consider pursuing in the future. The graphs then compare your current well-being with the average answers given by people in the two chosen occupations.
           Furthermore - the median pay in the UK for that occupation is provided. Submit your choices to see if you have chosen one of the happier occupations....'),
  
  tags$a(href="https://whatworkswellbeing.org/wellbeing-2/wellbeing-data/personal-wellbeing-for-major-and-sub-major-standard-occupation-codes/",
              "Source Data"),
  
  # Sidebar with a slider for Life Satisfaction
  sidebarLayout(
    sidebarPanel(
      sliderInput("satisfied",
                  "On a scale of zero to 10 how satisfied are you with your life nowadays? (where 0 means NOT AT ALL and 10 means COMPLETELY SATISFIED):",
                  min = 0,
                  max = 10,
                  value = 0),
      
      sliderInput("worthwhile",
                  "On a scale of zero to 10 how worthwhile are the activities you do in life? (where 0 means NOT AT ALL and 10 means COMPLETELY):",
                  min = 0,
                  max = 10,
                  value = 0),
      selectInput("currjob",
                  "Which of these occupations most closely matches your current occupation or current choice of occupation?", 
                  as.character(data[,2]),
                  selected=""),
      selectInput("compjob",
                  "Which alternative occupation would you like to compare your current job choice with?", 
                  as.character(data[,2]),
                  selected=""),
      submitButton("Submit")
      
    ),
    
    # Show the well-being plots
    mainPanel(
      plotOutput("distPlot1"),
      plotOutput("distPlot2")
    )
  )
))
