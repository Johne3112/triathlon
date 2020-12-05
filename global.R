#### Shiny app to download and analyse results from tirathlon.org ####

#### Load all the required Libraries here ####
library(shiny)
library(bs4Dash)
library(DT)
library(tidyverse)
library(httr)


#### Global functions and variables ####


getEvents_API <- function(startdate, enddate){
# function to get events based on filter parameters #
  
  
  url = "https://api.triathlon.org/v1/search/events"
  
  npage <- 1
  bfirst <- TRUE
  
  
  while (npage > 0){
    
    # Query the API 
    res <- GET(url, 
               add_headers( 
                 c("apikey" = "2649776ef9ece4c391003b521cbfce7a") 
               ),
               query = list(page = npage, per_page = 100, start_date = startdate, end_date = enddate)
    ) 
    
    # Turn the result in a dataframe 
    df <- jsonlite::fromJSON(rawToChar(res$content)) 
    
    events <- df$data
    
    if( length(df$data) > 0 ){
      
      npage <- npage + 1
      
      events <- events %>% dplyr::filter(event_cancelled == FALSE)
      events <- events[,c("event_id","event_title","event_venue","event_country","event_finish_date")]
      if(bfirst == TRUE){
        dfout <- events
        bfirst <- FALSE
      } else {
        dfout <- rbind(dfout,events)
      }
    } else{
      npage <- 0
    }
    
  }
  
  return(dfout)
  
}


getProg_API <- function(events, ind_team){
# function to get programmes (races with an event) for the selected events #

  bfirst <- TRUE
  for( event_id in events$event_id ){
    
    url <- paste0("https://api.triathlon.org/v1/events/",event_id,"/programs")
    # Query the API 
    res <- GET(url, 
               add_headers( 
                 c("apikey" = "2649776ef9ece4c391003b521cbfce7a") 
               ) 
    ) 
    # Turn the result in a dataframe 
    df <- jsonlite::fromJSON(rawToChar(res$content)) 
    prog <- df$data
    
    if(ind_team == 1){
      team_filter <- FALSE
    } else {
      team_filter <- TRUE
    }
    prog <- prog %>% dplyr::filter(results == TRUE & team == team_filter)
    
    if(bfirst == TRUE){
      dfout <- prog
      bfirst <- FALSE
    } else {
      dfout <- rbind(dfout,prog)
    }
    
  }
  
  return(dfout)
  
}

getRes_API <- function(progs, ind_team){
# reactive function to get results for the selected prgrammes #

  
  bfirst <- TRUE
  for(i in 1:nrow(progs)){
    
    event_id <- progs$event_id[i]
    prog_id <- progs$prog_id[i]
    
    print(event_id)
    print(prog_id)
    
    url = paste0("https://api.triathlon.org/v1/events/",event_id,"/programs/",prog_id,"/results")
    # url = paste0("https://api.triathlon.org/v1/events/131696/programs/352282/results")
    
    # Query the API 
    res <- GET(url, 
               add_headers( 
                 c("apikey" = "2649776ef9ece4c391003b521cbfce7a") 
               ) 
    ) 
    
    # Turn the result in a dataframe 
    df <- jsonlite::fromJSON(rawToChar(res$content)) 
    
    res <- df$data$results
    
    if(ind_team == 2){
      for(i in 1:length(res$team_members)){
        team <- res$team_members[[i]]
        if(i==1){
          temp <- team
        } else {
          temp <- plyr::rbind.fill(temp,team)
        }
      }
      res <- temp
    }
    
    res$event_id <- event_id
    res$prog_id <- prog_id
    if(!("athlete_id" %in% colnames(res))){ res$athlete_id <- "" }
    if(!("athlete_title" %in% colnames(res))){ res$athlete_title <- "" }
    if(!("athlete_gender" %in% colnames(res))){ res$athlete_gender <- "" }
    if(!("athlete_yob" %in% colnames(res))){ res$athlete_yob <- "" }
    if(!("athlete_noc" %in% colnames(res))){ res$athlete_noc <- "" }
    if(!("position" %in% colnames(res))){ res$position <- "" }
    if(!("total_time" %in% colnames(res))){ res$total_time <- "" }
    # res$swim <- lapply(res$splits, `[[`, 1)
    # res$T1 <- lapply(res$splits, `[[`, 2)
    # res$bike <- lapply(res$splits, `[[`, 3)
    # res$T2 <- lapply(res$splits, `[[`, 4)
    # res$run <- lapply(res$splits, `[[`, 5)
    
    temp_res <- res[,c("event_id","prog_id","athlete_id","athlete_title","athlete_gender","athlete_yob","athlete_noc","position","total_time")]
    
    for(i in 1:length(res$splits[[1]])) {
      temp_res$split_i <- unlist(lapply(res$splits, `[[`, i))
      colnames(temp_res)[length(colnames(temp_res))] <- paste0("split_",i)
    }
    
    if( bfirst == TRUE ){
      dfout <- temp_res
      bfirst <- FALSE
    } else {
      dfout <- plyr::rbind.fill(dfout,temp_res)
    }
    
  }
  
  return(dfout)
  
}