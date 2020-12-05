#### Server File ####

shinyServer(function(input, output) {

    getEvents <- reactive({
        #reactive variable - calls the API function to get events based on filter params
        
        #call the API function
        data <- getEvents_API(input$dateRange[1],input$dateRange[2])
        return(data)
        
    })
    
    
    getProg <- reactive({
        #reactive variable - calls the API to get programmes based on selected events
        
        #get the subset of selected events        
        row_count <- input$events_rows_selected
        if(is.null(row_count)){ return() }
        events <- getEvents()[row_count,]
        
        #call the API function
        data <- getProg_API(events, input$ind_team)
        return(data)
        
    })
    
    getRes <- reactive({
        #reactive variable - calls the API to get results for the selected programmes
        
        #get the subset of selected programmes        
        row_count <- input$prog_rows_selected
        if(is.null(row_count)){ return() }
        progs <- getProg()[row_count,]
        
        #call the API function
        data <- getRes_API(progs, input$ind_team)
        return(data)
        
    })
    
    
    output$events <- DT::renderDataTable({
        
        #get the events based on the filter params
        data <- getEvents()
        
        #populate the data table
        DT::datatable(data, options = list(scrollX=TRUE))
        
    })
    
    output$prog <- DT::renderDataTable({ 
        
        #get the programmes based on selected events
        data <- getProg()

        #populate the data table
        DT::datatable(data, options = list(scrollX=TRUE))
        
    })
    
    output$results <- DT::renderDataTable({
        
        #get the results based on selected programmes
        data <- getRes()
        
        #populate the data table
        DT::datatable(data, options = list(scrollX=TRUE))
        
    })
    
    
    output$downloadData <- downloadHandler(
        
        filename = function() {
            paste("triathlon-", Sys.Date(), ".csv", sep="")
        },
        content = function(file) {
            data <- getRes()
            write.csv(data, file)
        }
        
    )
    

})
