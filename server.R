
# This is the server logic for a Shiny web application.
# The web application is to compare the user's wellbeing with those in different careers
#


library(shiny)

#download wellbeing file
#url = "http://whatworkswellbeing.files.wordpress.com/2016/03/wellbeing-by-standard-occupations_2012-15_final.xlsx"
#download.file(url, destfile="./wellbeingdata.xlsx",mode='wb',cacheOK = FALSE)

data1 <- read.xlsx("./wellbeingdata.xlsx",sheetName="SOC3_Wellbeing",header=TRUE)
data2 <- read.xlsx("./wellbeingdata.xlsx",sheetName="SOC3_ASHE",header=TRUE,colIndex=c(1:7))
data <- merge(data1,data2,by="SOC3")
data <- data[-c(37,42),]
data$median_GAP <- as.numeric(paste(data$median_GAP))


shinyServer(function(input, output) {

  output$distPlot1 <- renderPlot({

    plot(as.numeric(data$median_GAP),data$LS_mean,  main="Life Satisfaction and Median Pay by career", 
         xlab="Median Pay (£)", ylab="Life Satisfaction", pch=19)
    abline(h=input$satisfied, col="red")
    points(data[data$Standard.Occupation.Code..SOC....Minor.Group==input$currjob,26],
           data[data$Standard.Occupation.Code..SOC....Minor.Group==input$currjob,3],pch=17,cex=2,col="green")
    
    points(data[data$Standard.Occupation.Code..SOC....Minor.Group==input$compjob,26],
           data[data$Standard.Occupation.Code..SOC....Minor.Group==input$compjob,3],pch=17,cex=2,col="blue")
        
    points(40000,7.4,pch=17,cex=2,col="green")
    points(40000,7.36,pch=17,cex=2,col="blue")
    
    text(41500,7.44,paste("Current Life Satisfaction = ",input$satisfied),pos=4)
    text(41500,7.40,input$currjob,pos=4)
    text(41500,7.36,input$compjob,pos=4)
    text(66000,input$satisfied,"Your Current Life Satisfaction",pos=1)
    

  })
  
  output$distPlot2 <- renderPlot({
    
    plot(as.numeric(data$median_GAP),data$WW_mean,  main="Sense of Worthwhile and Median Pay by career", 
         xlab="Median Pay (£)", ylab="Sense of Worthwhile", pch=19)
    abline(h=input$worthwhile, col="red")
    points(data[data$Standard.Occupation.Code..SOC....Minor.Group==input$currjob,26],
           data[data$Standard.Occupation.Code..SOC....Minor.Group==input$currjob,4],pch=17,cex=2,col="green")
    
    points(data[data$Standard.Occupation.Code..SOC....Minor.Group==input$compjob,26],
           data[data$Standard.Occupation.Code..SOC....Minor.Group==input$compjob,4],pch=17,cex=2,col="blue")
    
    
    points(40000,7.5,pch=17,cex=2,col="green")
    points(40000,7.46,pch=17,cex=2,col="blue")
    
    text(41500,7.54,paste("Current Sense of Worthwhile = ",input$worthwhile),pos=4)
    text(41500,7.50,input$currjob,pos=4)
    text(41500,7.46,input$compjob,pos=4)
    text(66000,input$worthwhile,"Your Current Sense of Worthwhile",pos=1)
    
    
  })


})
